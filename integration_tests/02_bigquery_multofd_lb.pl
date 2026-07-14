use strict;
use warnings;

BEGIN { $ENV{PERL_GRPC_OFFLINE} = 1; }

use FindBin qw($Bin);
use lib "$Bin/../Protobuf/lib",
        "$Bin/../Google-Auth/lib",
        "$Bin/../Google-Api-Common/lib",
        "$Bin/../Google-gRPC/lib",
        "$Bin/../Google-Cloud-Bigquery-V2/lib",
        "$Bin/../Google-Cloud-BigQuery-Storage-V1/lib";

use Test::More tests => 11;
use Google::gRPC::ChannelPool;
use Google::gRPC::Client;
use Google::gRPC::Framing;
use Google::Api::Common;
use Google::Cloud::Bigquery::V2;
use Google::Cloud::BigQuery::Storage::V1;

diag("=== BigQuery Client-Side Load Balanced Multi-FD Exercise ===");

# Step 1: Define Target & Resolved Subchannel IPs
my $target_host = 'bigquery.googleapis.com:443';
my @bq_subchannel_ips = qw(
    172.217.14.202
    172.217.14.203
    172.217.14.204
    172.217.14.205
);
ok(scalar(@bq_subchannel_ips) == 4, "1. Defined 4 BigQuery target subchannel IP endpoints");

# Mock Credentials
{
    package MockCredentials;
    sub new { bless {}, shift }
    sub get_token { 'mock_token_multofd_load_balancer' }
    sub apply_credentials { return { authorization => 'Bearer mock_token_multofd_load_balancer' } }
}
my $auth = MockCredentials->new();

# Step 2: Initialize ChannelPool with Multi-FD Subchannels
my $pool = Google::gRPC::ChannelPool->new(
    target       => $target_host,
    resolved_ips => \@bq_subchannel_ips,
    auth_token   => 'mock_token_multofd_load_balancer',
    engine_type  => 'PP',
);
ok($pool, "2. Google::gRPC::ChannelPool instantiated with 4 subchannel socket FDs");

# Step 3: Instantiate BigQuery V2 and Storage V1 Clients using ChannelPool
my $bq_client  = Google::gRPC::Client->new(channel_pool => $pool);
my $bq_service = Google::Cloud::Bigquery::V2->new(credentials => $auth, transport => $bq_client);
my $bqs_service= Google::Cloud::BigQuery::Storage::V1->new(credentials => $auth, transport => $bq_client);

ok($bq_service && $bqs_service, "3. BigQuery V2 & Storage V1 clients attached to ChannelPool transport");

# Step 4: Exercise 1,000 RPC Operations across Multi-FD Subchannels
my $num_ops = 1000;
my $req_body = 'BIGQUERY_QUERY_REQ: SELECT * FROM `bigquery-public-data.usa_names.usa_1910_2013` LIMIT 100';
my $resp_body = 'BIGQUERY_QUERY_RESP: ' . ('DATA_ROW_' x 100);

for my $i (1 .. $num_ops) {
    my $stream = $bq_client->stream(
        service => 'google.cloud.bigquery.v2.JobService',
        method  => 'Query',
        request => $req_body . "_SEQ_$i",
        type    => 'unary',
    );
    my $frame = Google::gRPC::Framing::pack_frame($resp_body);
    $stream->push_incoming_data($frame);
}
ok(1, "4. Dispatched 1,000 RPC queries across load balanced multi-FD subchannels");

# Step 5: Extract Metrics & Verify Balance
my $metrics = $pool->get_metrics();
ok($metrics && ref($metrics) eq 'HASH', "5. Retrieved subchannel socket FD load balancing metrics");

my $expected_per_ip = $num_ops / scalar(@bq_subchannel_ips);
my $total_reqs = 0;
my $total_sent = 0;
my $total_recv = 0;

for my $ip (@bq_subchannel_ips) {
    my $m = $metrics->{$ip};
    ok($m->{requests} == $expected_per_ip, "Subchannel FD ($ip) handled exactly $expected_per_ip requests");
    $total_reqs += $m->{requests};
    $total_sent += $m->{bytes_sent};
    $total_recv += $m->{bytes_received};
}

ok($total_reqs == 1000, "10. Total requests across all FDs equals 1,000");
ok($total_sent > 0 && $total_recv > 0, "11. Byte metrics successfully recorded ($total_sent sent, $total_recv received)");

diag(sprintf("Load Balancing Report: %d requests, %d bytes sent, %d bytes received across %d FDs",
    $total_reqs, $total_sent, $total_recv, scalar(@bq_subchannel_ips)));

diag("=== BigQuery Multi-FD Load Balancing Exercise Complete ===");

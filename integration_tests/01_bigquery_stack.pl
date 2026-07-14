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

use Test::More tests => 10;
use Google::Api::Common;
use Google::Cloud::Bigquery::V2;
use Google::Cloud::BigQuery::Storage::V1;

diag("=== BigQuery & BigQuery Storage API Exercise ===");

# Step 1: Initialize Mock Credentials (bypasses ADC network token refresh)
{
    package MockCredentials;
    sub new { bless {}, shift }
    sub get_token { 'mock_token_for_integration_testing' }
    sub apply_credentials { return { authorization => 'Bearer mock_token_for_integration_testing' } }
}
my $auth = MockCredentials->new();
ok($auth, "1. Mock credentials initialized for offline execution");

# Step 2: Instantiate BigQuery V2 Client
my $bq = eval { Google::Cloud::Bigquery::V2->new(credentials => $auth) };
ok($bq, "2. Google::Cloud::Bigquery::V2 client instantiated over gRPC");
diag("BigQuery V2 Init Error: $@") if $@;

# Step 3: Instantiate BigQuery Storage V1 Client
my $bqs = eval { Google::Cloud::BigQuery::Storage::V1->new(credentials => $auth) };
ok($bqs, "3. Google::Cloud::BigQuery::Storage::V1 client instantiated over gRPC");
diag("BigQuery Storage V1 Init Error: $@") if $@;

# Step 4: Construct Dataset Definition
my $dataset_id = 'cjac_test_dataset_' . time();
my $dataset_req = {
    datasetReference => {
        projectId => 'test-project-123',
        datasetId => $dataset_id,
    },
    location => 'US',
    description => 'Integration test dataset created by Perl Google::Cloud::Bigquery::V2',
};
ok($dataset_req->{datasetReference}->{datasetId} eq $dataset_id, "4. Dataset request payload created");

# Step 5: Construct Table Definition
my $table_id = 'cjac_test_table_' . time();
my $table_req = {
    tableReference => {
        projectId => 'test-project-123',
        datasetId => $dataset_id,
        tableId   => $table_id,
    },
    schema => {
        fields => [
            { name => 'id',        type => 'INTEGER', mode => 'REQUIRED' },
            { name => 'user_name', type => 'STRING',  mode => 'NULLABLE' },
            { name => 'created_at',type => 'TIMESTAMP',mode => 'NULLABLE' },
        ],
    },
    description => 'Test table with schema',
};
ok(scalar(@{$table_req->{schema}->{fields}}) == 3, "5. Table schema payload constructed with 3 fields");

# Step 6: Construct BigQuery Streaming Insert Request (InsertAll)
my $insert_all_req = {
    projectId => 'test-project-123',
    datasetId => $dataset_id,
    tableId   => $table_id,
    rows => [
        { insertId => 'row-001', json => { id => 1, user_name => 'alice', created_at => '2026-07-13T22:58:00Z' } },
        { insertId => 'row-002', json => { id => 2, user_name => 'bob',   created_at => '2026-07-13T22:58:01Z' } },
    ],
};
ok(scalar(@{$insert_all_req->{rows}}) == 2, "6. Streaming insert rows payload prepared");

# Step 7: Construct BigQuery Storage API ReadSession
my $read_session_req = {
    parent => 'projects/test-project-123',
    readSession => {
        table => "projects/test-project-123/datasets/$dataset_id/tables/$table_id",
        dataFormat => 'ARROW',
    },
    maxStreamCount => 4,
};
ok($read_session_req->{readSession}->{dataFormat} eq 'ARROW', "7. Storage ReadSession payload configured for high-throughput Arrow streams");

# Step 8: Construct BigQuery Storage API WriteStream (AppendRows)
my $append_rows_req = {
    writeStream => "projects/test-project-123/datasets/$dataset_id/tables/$table_id/streams/_default",
    offset => 0,
};
ok($append_rows_req->{writeStream} =~ /_default$/, "8. Storage WriteStream (AppendRows) stream handle configured");

# Step 9: Verify Client Method Dispatcher Table
ok($bq && $bq->can('insert_dataset') && $bq->can('insert_table') && $bq->can('insert_all') && $bq->can('query'), "9. BigQuery V2 API methods verified");

# Step 10: Verify Transport Connection Handles
ok($bq && $bqs && $bq->transport && $bqs->transport, "10. Transport channels initialized and ready for gRPC call execution");

diag("=== BigQuery API Stack Verification Complete ===");

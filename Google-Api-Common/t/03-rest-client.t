use strict;
use warnings;
use Test::More;
use Test::LWP::UserAgent;
use HTTP::Response;
use JSON::MaybeXS qw(encode_json);

use Google::Cloud::REST::Client;

subtest 'REST Client Initialization' => sub {
    my $client = Google::Cloud::REST::Client->new(
        target     => 'bigquery.googleapis.com',
        auth_token => 'mock-bearer-token-12345',
    );
    ok($client, 'Created REST client');
    is($client->target, 'bigquery.googleapis.com', 'Target set correctly');
    is($client->auth_token, 'mock-bearer-token-12345', 'Auth token set correctly');
};

subtest 'REST Request Execution with Mock LWP UserAgent' => sub {
    my $mock_ua = Test::LWP::UserAgent->new;
    $mock_ua->map_response(
        sub {
            my $req = shift;
            return $req->url->path eq '/bigquery/v2/projects/test-project/datasets'
                && $req->header('Authorization') eq 'Bearer mock-bearer-token-12345';
        },
        HTTP::Response->new(
            200, 'OK',
            ['Content-Type' => 'application/json'],
            encode_json({ kind => 'bigquery#datasetList', datasets => [{ id => 'ds1' }] })
        )
    );

    my $client = Google::Cloud::REST::Client->new(
        target     => 'bigquery.googleapis.com',
        auth_token => 'mock-bearer-token-12345',
        user_agent => $mock_ua,
    );

    my $res = $client->call({
        method => 'GET',
        path   => 'bigquery/v2/projects/test-project/datasets',
    });

    ok($res, 'Got REST response');
    is($res->{kind}, 'bigquery#datasetList', 'Response kind matches');
    is($res->{datasets}->[0]->{id}, 'ds1', 'Dataset ID matches');
};

subtest 'REST Request Execution Async with Mock LWP UserAgent' => sub {
    my $mock_ua = Test::LWP::UserAgent->new;
    $mock_ua->map_response(
        sub {
            my $req = shift;
            return $req->url->path eq '/bigquery/v2/projects/test-project/datasets'
                && $req->header('Authorization') eq 'Bearer mock-bearer-token-12345';
        },
        HTTP::Response->new(
            200, 'OK',
            ['Content-Type' => 'application/json'],
            encode_json({ kind => 'bigquery#datasetList', datasets => [{ id => 'ds1' }] })
        )
    );

    my $client = Google::Cloud::REST::Client->new(
        target     => 'bigquery.googleapis.com',
        auth_token => 'mock-bearer-token-12345',
        user_agent => $mock_ua,
    );

    my $future = $client->call_async({
        method => 'GET',
        path   => 'bigquery/v2/projects/test-project/datasets',
    });

    ok($future, 'Got Future from call_async');
    
    my $res = $future->get();

    ok($res, 'Got REST response from future');
    is($res->{kind}, 'bigquery#datasetList', 'Response kind matches');
    is($res->{datasets}->[0]->{id}, 'ds1', 'Dataset ID matches');
};

subtest 'REST Request with Query Parameters' => sub {
    my $mock_ua = Test::LWP::UserAgent->new;
    $mock_ua->map_response(
        sub {
            my $req = shift;
            return $req->url->path eq '/bigquery/v2/projects/test-project/datasets'
                && $req->url->query eq 'maxResults=10&pageToken=xyz';
        },
        HTTP::Response->new(200, 'OK', ['Content-Type' => 'application/json'], '{}')
    );

    my $client = Google::Cloud::REST::Client->new(
        target     => 'bigquery.googleapis.com',
        user_agent => $mock_ua,
    );

    my $res = $client->call({
        method => 'GET',
        path   => 'bigquery/v2/projects/test-project/datasets',
        query_params => { maxResults => 10, pageToken => 'xyz' },
    });

    ok($res, 'Got response with query params');
};

subtest 'REST Request with Retries' => sub {
    my $mock_ua = Test::LWP::UserAgent->new;
    my $attempts = 0;
    
    $mock_ua->map_response(
        sub { $attempts++; return 1; },
        sub {
            if ($attempts < 3) {
                return HTTP::Response->new(503, 'Service Unavailable');
            } else {
                return HTTP::Response->new(200, 'OK', ['Content-Type' => 'application/json'], '{"success":true}');
            }
        }
    );

    my $client = Google::Cloud::REST::Client->new(
        target      => 'bigquery.googleapis.com',
        user_agent  => $mock_ua,
        max_retries => 3,
    );

    my $res = $client->call({ method => 'GET', path => 'test' });
    ok($res->{success}, 'Succeeded after retries');
    is($attempts, 3, 'Tried 3 times');
};

subtest 'REST Request Non-Transient Failure' => sub {
    my $mock_ua = Test::LWP::UserAgent->new;
    $mock_ua->map_response(
        qr/test/,
        HTTP::Response->new(400, 'Bad Request', ['Content-Type' => 'application/json'], '{"error":"bad"}')
    );

    my $client = Google::Cloud::REST::Client->new(
        target     => 'bigquery.googleapis.com',
        user_agent => $mock_ua,
    );

    my $future = $client->call_async({ method => 'GET', path => 'test' });
    ok($future->is_ready, 'Future ready');
    ok($future->is_failed, 'Future failed');
    
    my ($err, $cat) = $future->failure;
    like($err, qr/REST API HTTP Error 400/, 'Correct error message');
    is($cat, 'REST', 'Correct category');
};

done_testing();

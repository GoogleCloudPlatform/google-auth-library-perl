use strict;
use warnings;
use Test::More;
use Test::LWP::UserAgent;
use HTTP::Response;

use Google::Cloud::Transport::Adapter::LWP;

my $mock_ua = Test::LWP::UserAgent->new;
$mock_ua->map_response(
    qr{example.com/success} => HTTP::Response->new(200, 'OK', ['Content-Type' => 'text/plain'], 'Success Body')
);
$mock_ua->map_response(
    qr{example.com/fail} => HTTP::Response->new(500, 'Internal Server Error', ['Content-Type' => 'text/plain'], 'Error Body')
);

my $adapter = Google::Cloud::Transport::Adapter::LWP->new(user_agent => $mock_ua);

subtest 'Success request' => sub {
    my $future = $adapter->request(
        method => 'GET',
        url    => 'https://example.com/success',
    );
    
    ok($future, 'Got a future');
    ok($future->is_ready, 'Future is ready immediately (blocking transport)');
    
    my ($body, $headers) = $future->get();
    is($body, 'Success Body', 'Correct body');
    is($headers->header('Content-Type'), 'text/plain', 'Correct headers');
};

subtest 'Failed request' => sub {
    my $future = $adapter->request(
        method => 'GET',
        url    => 'https://example.com/fail',
    );
    
    ok($future, 'Got a future');
    ok($future->is_ready, 'Future is ready immediately');
    
    ok($future->is_failed, 'Future failed');
    
    my ($err, $cat, $res) = $future->failure;
    is($err, '500 Internal Server Error', 'Correct error message');
    is($cat, 'Transport', 'Correct category');
    isa_ok($res, 'HTTP::Response', 'Response object included');
};

subtest 'Request with Body' => sub {
    my $mock_ua = Test::LWP::UserAgent->new;
    my $captured_req;
    
    $mock_ua->map_response(
        qr{example.com/post} => sub {
            my ($request) = @_;
            $captured_req = $request;
            return HTTP::Response->new(200, 'OK', [], 'Success');
        }
    );

    my $adapter = Google::Cloud::Transport::Adapter::LWP->new(user_agent => $mock_ua);
    
    # Test string body
    my $future = $adapter->request(
        method => 'POST',
        url    => 'https://example.com/post',
        body   => 'Hello Body',
    );
    ok($future->is_done, 'Request done');
    is($captured_req->content, 'Hello Body', 'Correct string body sent');
    
    # Test scalar ref body
    my $body_scalar = 'Hello Scalar';
    my $future2 = $adapter->request(
        method => 'POST',
        url    => 'https://example.com/post',
        body   => \$body_scalar,
    );
    ok($future2->is_done, 'Request 2 done');
    is($captured_req->content, 'Hello Scalar', 'Correct scalar ref body sent');
};

subtest 'Input Validation (Request)' => sub {
    my $adapter = Google::Cloud::Transport::Adapter::LWP->new();
    
    # Missing URL in request()
    my $future = $adapter->request();
    ok($future->is_failed, 'Request without URL failed');
    my ($err, $cat) = $future->failure;
    is($err, 'URL/Path is required', 'Correct error message for missing URL in request');
};

done_testing();

use strict;
use warnings;
use Test::More;
use Test::MockModule;

BEGIN {
    eval 'use Net::HTTP2::nghttp2; 1'
      or plan skip_all => 'Net::HTTP2::nghttp2 required for this test';
}

use Google::Cloud::Transport::Adapter::Nghttp2;

{
    package MockTLS;
    sub ctx { return $_[0]->{ctx} }
}

subtest 'Input Validation' => sub {
    my $adapter = Google::Cloud::Transport::Adapter::Nghttp2->new();
    my $future = $adapter->request(); # Missing URL
    ok($future, 'Got a future');
    ok($future->is_failed, 'Future failed immediately on missing URL');
    my ($err, $cat) = $future->failure;
    is($err, 'URL/Path is required', 'Correct error message');
    is($cat, 'Transport', 'Correct category');
};

subtest 'Connection Failure' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    my $on_error_cb;
    
    $mock_handle->mock(
        new => sub {
            my ($class, %args) = @_;
            $on_error_cb = $args{on_error};
            return bless { %args }, $class;
        },
        destroy => sub { },
    );
    
    my $adapter = Google::Cloud::Transport::Adapter::Nghttp2->new();
    my $future = $adapter->request(url => 'https://example.com/fail');
    
    ok($on_error_cb, 'Captured on_error callback');
    
    $on_error_cb->(bless({}, 'AnyEvent::Handle'), 1, 'Connection refused');
    
    ok($future->is_ready, 'Future is ready');
    ok($future->is_failed, 'Future failed');
    my ($err, $cat) = $future->failure;
    is($err, 'Connection failed: Connection refused', 'Correct error message');
};

subtest 'Successful Request' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    my $mock_session = Test::MockModule->new('Net::HTTP2::nghttp2::Session');
    my $mock_ssleay = Test::MockModule->new('Net::SSLeay');
    
    my $captured_on_starttls;
    my $captured_on_read;
    my $captured_callbacks;
    my $mock_session_obj = bless {}, 'Net::HTTP2::nghttp2::Session';
    
    $mock_handle->mock(
        new => sub {
            my ($class, %args) = @_;
            $captured_on_starttls = $args{on_starttls};
            if ($args{tls_ctx} && $args{tls_ctx}{prepare}) {
                $args{tls_ctx}{prepare}->(bless { ctx => bless({}, 'MockCTX') }, 'MockTLS');
            }
            return bless { %args, tls => bless({}, 'MockSSL') }, $class;
        },
        on_read => sub {
            my ($self, $cb) = @_;
            $captured_on_read = $cb;
        },
        push_write => sub { },
        destroy => sub { },
    );
    
    $mock_session->mock(
        new_client => sub {
            my ($class, %args) = @_;
            $captured_callbacks = $args{callbacks};
            return $mock_session_obj;
        },
        send_connection_preface => sub { },
        submit_request => sub { return 1; }, # Stream ID 1
        want_write => sub { 0 },
        set_stream_user_data => sub { },
        get_stream_user_data => sub {
            return {
                future => $_[2],
            };
        },
        mem_recv => sub { },
    );
    
    my %stream_user_data;
    $mock_session->mock(
        set_stream_user_data => sub {
            my ($self, $id, $data) = @_;
            $stream_user_data{$id} = $data;
        },
        get_stream_user_data => sub {
            my ($self, $id) = @_;
            return $stream_user_data{$id};
        },
    );
    
    $mock_ssleay->mock(
        P_alpn_selected => sub { 'h2' },
        CTX_set_alpn_protos => sub { },
    );
    
    my $adapter = Google::Cloud::Transport::Adapter::Nghttp2->new();
    my $future = $adapter->request(url => 'https://example.com/success');
    
    ok($captured_on_starttls, 'Captured on_starttls callback');
    
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    
    ok($captured_callbacks, 'Captured nghttp2 callbacks');
    ok($captured_callbacks->{on_header}, 'Has on_header callback');
    ok($captured_callbacks->{on_data_chunk_recv}, 'Has on_data_chunk_recv callback');
    ok($captured_callbacks->{on_stream_close}, 'Has on_stream_close callback');
    
    ok($captured_on_read, 'Captured on_read callback');
    $captured_on_read->(bless { rbuf => 'Mock Wire Data' }, 'AnyEvent::Handle');

    $captured_callbacks->{on_header}->(1, ':status', '200');
    $captured_callbacks->{on_header}->(1, 'content-type', 'text/plain');
    
    $captured_callbacks->{on_data_chunk_recv}->(1, 'Success Body');
    
    $captured_callbacks->{on_stream_close}->(1, 0); # 0 = NO_ERROR
    
    ok($future->is_ready, 'Future is ready');
    ok($future->is_done, 'Future succeeded');
    
    my ($body, $headers) = $future->get;
    is($body, 'Success Body', 'Correct body');
    is($headers->header('content-type'), 'text/plain', 'Correct headers');
};

done_testing();

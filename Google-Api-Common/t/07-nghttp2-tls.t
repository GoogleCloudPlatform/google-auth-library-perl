use strict;
use warnings;
use Test::More;
use Test::MockModule;

BEGIN {
    eval 'use Net::HTTP2::nghttp2; 1'
      or plan skip_all => 'Net::HTTP2::nghttp2 required for this test';
}

use Google::Cloud::Transport::Adapter::Nghttp2;

subtest 'ALPN Negotiation Failure' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    my $mock_ssleay = Test::MockModule->new('Net::SSLeay');
    
    my $captured_on_starttls;
    
    $mock_handle->mock(
        new => sub {
            my ($class, %args) = @_;
            $captured_on_starttls = $args{on_starttls};
            return bless { %args, tls => bless({}, 'MockSSL') }, $class;
        },
        destroy => sub { },
    );
    
    $mock_ssleay->mock(
        P_alpn_selected => sub { 'http/1.1' }, # Fail to negotiate h2
    );
    
    my $adapter = Google::Cloud::Transport::Adapter::Nghttp2->new();
    my $future = $adapter->request(url => 'https://example.com/fail_alpn');
    
    ok($captured_on_starttls, 'Captured on_starttls callback');
    
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    
    ok($future->is_ready, 'Future is ready');
    ok($future->is_failed, 'Future failed');
    my ($err, $cat) = $future->failure;
    is($err, 'Failed to negotiate HTTP/2 (h2)', 'Correct error message');
};

subtest 'TLS Handshake Failure' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    
    my $captured_on_starttls;
    
    $mock_handle->mock(
        new => sub {
            my ($class, %args) = @_;
            $captured_on_starttls = $args{on_starttls};
            return bless { %args }, $class;
        },
        destroy => sub { },
    );
    
    my $adapter = Google::Cloud::Transport::Adapter::Nghttp2->new();
    my $future = $adapter->request(url => 'https://example.com/fail_tls');
    
    ok($captured_on_starttls, 'Captured on_starttls callback');
    
    $captured_on_starttls->(bless({}, 'AnyEvent::Handle'), 0, 'SSL Error');
    
    ok($future->is_ready, 'Future is ready');
    ok($future->is_failed, 'Future failed');
    my ($err, $cat) = $future->failure;
    is($err, 'TLS Handshake Failed: SSL Error', 'Correct error message');
};

subtest 'Non-default Port' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    my $mock_session = Test::MockModule->new('Net::HTTP2::nghttp2::Session');
    my $mock_ssleay = Test::MockModule->new('Net::SSLeay');
    
    my $captured_on_starttls;
    my $captured_submit_args;
    my $captured_connect;
    
    $mock_handle->mock(
        new => sub {
            my ($class, %args) = @_;
            $captured_on_starttls = $args{on_starttls};
            $captured_connect = $args{connect};
            return bless { %args, tls => bless({}, 'MockSSL') }, $class;
        },
        on_read => sub { },
        push_write => sub { },
        destroy => sub { },
    );
    
    $mock_session->mock(
        new_client => sub {
            return bless {}, 'Net::HTTP2::nghttp2::Session';
        },
        send_connection_preface => sub { },
        submit_request => sub {
            my ($self, %args) = @_;
            $captured_submit_args = \%args;
            return 1;
        },
        want_write => sub { 0 },
        set_stream_user_data => sub { },
        get_stream_user_data => sub { },
    );
    
    $mock_ssleay->mock(
        P_alpn_selected => sub { 'h2' },
    );
    
    my $adapter = Google::Cloud::Transport::Adapter::Nghttp2->new();
    my $future = $adapter->request(
        url => 'https://example.com:8443/path',
    );
    
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    
    ok($captured_connect, 'Captured connect arguments');
    is($captured_connect->[0], 'example.com', 'Correct host');
    is($captured_connect->[1], 8443, 'Correct port');
    
    ok($captured_submit_args, 'Captured submit_request arguments');
    is($captured_submit_args->{authority}, 'example.com:8443', 'Correct authority with port');
};

done_testing();

use strict;
use warnings;
use Test::More;
use Test::MockModule;

BEGIN {
    eval 'use Net::HTTP2::nghttp2; 1'
      or plan skip_all => 'Net::HTTP2::nghttp2 required for this test';
}

use Google::Cloud::Transport::Adapter::Nghttp2;

subtest 'Nghttp2 Error Callbacks' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    my $mock_session = Test::MockModule->new('Net::HTTP2::nghttp2::Session');
    my $mock_ssleay = Test::MockModule->new('Net::SSLeay');
    
    my $captured_on_starttls;
    my $captured_callbacks;
    
    $mock_handle->mock(
        new => sub {
            my ($class, %args) = @_;
            $captured_on_starttls = $args{on_starttls};
            return bless { %args, tls => bless({}, 'MockSSL') }, $class;
        },
        on_read => sub { },
        push_write => sub { },
        destroy => sub { },
    );
    
    $mock_session->mock(
        new_client => sub {
            my ($class, %args) = @_;
            $captured_callbacks = $args{callbacks};
            return bless {}, 'Net::HTTP2::nghttp2::Session';
        },
        send_connection_preface => sub { },
        submit_request => sub { return 1; },
        want_write => sub { 0 },
        set_stream_user_data => sub { },
        get_stream_user_data => sub { },
    );
    
    $mock_ssleay->mock(
        P_alpn_selected => sub { 'h2' },
    );
    
    my $adapter = Google::Cloud::Transport::Adapter::Nghttp2->new();
    my $future = $adapter->request(url => 'https://example.com/1');
    
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    
    ok($captured_callbacks->{on_invalid_frame_recv}, 'Has on_invalid_frame_recv');
    $captured_callbacks->{on_invalid_frame_recv}->({ type => 'HEADERS' }, 1);
    
    ok($captured_callbacks->{on_frame_recv}, 'Has on_frame_recv');
    $captured_callbacks->{on_frame_recv}->({ type => 'HEADERS', flags => 'END_STREAM', stream_id => 1, length => 10 });
    
    ok($captured_callbacks->{on_frame_send}, 'Has on_frame_send');
    $captured_callbacks->{on_frame_send}->({ type => 'HEADERS', flags => 'END_STREAM', stream_id => 1, length => 10 });
    
    ok($captured_callbacks->{on_error}, 'Has on_error');
    $captured_callbacks->{on_error}->(1, 'nghttp2 error');
};

subtest 'Stream Closed with Error' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    my $mock_session = Test::MockModule->new('Net::HTTP2::nghttp2::Session');
    my $mock_ssleay = Test::MockModule->new('Net::SSLeay');
    
    my $captured_on_starttls;
    my $captured_callbacks;
    my %stream_user_data;
    
    $mock_handle->mock(
        new => sub {
            my ($class, %args) = @_;
            $captured_on_starttls = $args{on_starttls};
            return bless { %args, tls => bless({}, 'MockSSL') }, $class;
        },
        on_read => sub { },
        push_write => sub { },
        destroy => sub { },
    );
    
    $mock_session->mock(
        new_client => sub {
            my ($class, %args) = @_;
            $captured_callbacks = $args{callbacks};
            return bless {}, 'Net::HTTP2::nghttp2::Session';
        },
        send_connection_preface => sub { },
        submit_request => sub { return 1; },
        want_write => sub { 0 },
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
    );
    
    my $adapter = Google::Cloud::Transport::Adapter::Nghttp2->new();
    my $future = $adapter->request(url => 'https://example.com/1');
    
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    
    $captured_callbacks->{on_stream_close}->(1, 1);
    
    ok($future->is_ready, 'Future is ready');
    ok($future->is_failed, 'Future failed');
    my ($err, $cat) = $future->failure;
    is($err, 'Stream closed with error: 1', 'Correct error message');
};

subtest 'Custom Headers and Body' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    my $mock_session = Test::MockModule->new('Net::HTTP2::nghttp2::Session');
    my $mock_ssleay = Test::MockModule->new('Net::SSLeay');
    
    my $captured_on_starttls;
    my $captured_submit_args;
    
    $mock_handle->mock(
        new => sub {
            my ($class, %args) = @_;
            $captured_on_starttls = $args{on_starttls};
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
        method  => 'POST',
        url     => 'https://example.com/post',
        headers => { 'X-Custom' => 'Value' },
        body    => 'Hello Body',
    );
    
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    
    ok($captured_submit_args, 'Captured submit_request arguments');
    is($captured_submit_args->{method}, 'POST', 'Correct method');
    is($captured_submit_args->{path}, '/post', 'Correct path');
    
    my $headers = $captured_submit_args->{headers};
    ok($headers, 'Has headers');
    is(scalar @$headers, 1, 'One custom header');
    is($headers->[0][0], 'x-custom', 'Header name lowercased');
    is($headers->[0][1], 'Value', 'Header value');
    
    is($captured_submit_args->{body}, 'Hello Body', 'Correct body');
};

done_testing();

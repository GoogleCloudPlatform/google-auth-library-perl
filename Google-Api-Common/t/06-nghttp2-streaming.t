use strict;
use warnings;
use Test::More;
use Test::MockModule;

BEGIN {
    eval 'use Net::HTTP2::nghttp2; 1'
      or plan skip_all => 'Net::HTTP2::nghttp2 required for this test';
}

use Google::Cloud::Transport::Adapter::Nghttp2;

subtest 'Streaming Request' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    my $mock_session = Test::MockModule->new('Net::HTTP2::nghttp2::Session');
    my $mock_ssleay = Test::MockModule->new('Net::SSLeay');
    
    my $captured_on_starttls;
    my $captured_callbacks;
    my $mock_session_obj = bless {}, 'Net::HTTP2::nghttp2::Session';
    
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
            return $mock_session_obj;
        },
        send_connection_preface => sub { },
        submit_request => sub { return 1; }, # Stream ID 1
        want_write => sub { 0 },
        set_stream_user_data => sub { },
        resume_stream => sub { },
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
    );
    
    my $adapter = Google::Cloud::Transport::Adapter::Nghttp2->new();
    
    my $data_received = '';
    my $eof_received = 0;
    
    my $stream_handle = $adapter->start_stream(
        url => 'https://example.com/stream',
        on_data => sub { $data_received .= $_[0]; },
        on_eof => sub { $eof_received = 1; },
    );
    
    ok($stream_handle, 'Got stream handle');
    
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    
    $captured_callbacks->{on_header}->(1, ':status', '200');
    $captured_callbacks->{on_header}->(1, 'content-type', 'application/grpc');

    $captured_callbacks->{on_data_chunk_recv}->(1, 'Chunk 1');
    $captured_callbacks->{on_data_chunk_recv}->(1, ' Chunk 2');
    
    is($data_received, 'Chunk 1 Chunk 2', 'Correct data received');
    
    is_deeply($stream_handle->get_metadata('headers'), { ':status' => '200', 'content-type' => 'application/grpc' }, 'Get metadata returns correct headers');
    
    ok($stream_handle->write('More Data'), 'Write returns success');
    $stream_handle->close_write();
    
    $captured_callbacks->{on_stream_close}->(1, 0);
    
    is($eof_received, 1, 'EOF received');
};

subtest 'Streaming Request with In-progress Connection' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    my $mock_session = Test::MockModule->new('Net::HTTP2::nghttp2::Session');
    my $mock_ssleay = Test::MockModule->new('Net::SSLeay');
    
    my $captured_on_starttls;
    my $captured_callbacks;
    my $mock_session_obj = bless {}, 'Net::HTTP2::nghttp2::Session';
    
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
    
    my $next_stream_id = 1;
    my %stream_user_data;
    
    $mock_session->mock(
        new_client => sub {
            my ($class, %args) = @_;
            $captured_callbacks = $args{callbacks};
            return $mock_session_obj;
        },
        send_connection_preface => sub { },
        submit_request => sub { return $next_stream_id++; },
        want_write => sub { 0 },
        set_stream_user_data => sub {
            my ($self, $id, $data) = @_;
            $stream_user_data{$id} = $data;
        },
        get_stream_user_data => sub {
            my ($self, $id) = @_;
            return $stream_user_data{$id};
        },
        resume_stream => sub { },
    );

    
    $mock_ssleay->mock(
        P_alpn_selected => sub { 'h2' },
    );
    
    my $adapter = Google::Cloud::Transport::Adapter::Nghttp2->new();
    
    my $future1 = $adapter->request(url => 'https://example.com/1');
    
    my $stream_handle = $adapter->start_stream(
        url => 'https://example.com/stream',
        on_data => sub { },
    );
    
    ok($stream_handle, 'Got stream handle');
    
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    
    $captured_callbacks->{on_stream_close}->(1, 0);
    
    ok($future1->is_done, 'First request done');
};

subtest 'Streaming Request with In-progress Connection Failure' => sub {
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
    
    my $future1 = $adapter->request(url => 'https://example.com/1');
    
    my $error_received;
    my $stream_handle = $adapter->start_stream(
        url => 'https://example.com/stream',
        on_data  => sub { },
        on_error => sub { $error_received = $_[0]; },
    );
    
    ok($stream_handle, 'Got stream handle');
    
    $captured_on_starttls->(bless({}, 'AnyEvent::Handle'), 0, 'SSL Error');
    
    ok($future1->is_failed, 'First request failed');
    is($error_received, 'TLS Handshake Failed: SSL Error', 'Stream error callback called');
};

subtest 'Streaming Request with New Connection Failure' => sub {
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
    
    my $error_received;
    my $stream_handle = $adapter->start_stream(
        url => 'https://example.com/stream',
        on_data  => sub { },
        on_error => sub { $error_received = $_[0]; },
    );
    
    ok($stream_handle, 'Got stream handle');
    
    $captured_on_starttls->(bless({}, 'AnyEvent::Handle'), 0, 'SSL Error');
    
    is($error_received, 'TLS Handshake Failed: SSL Error', 'Stream error callback called');
};

done_testing();

use strict;
use warnings;
use Test::More;
use Test::MockModule;

BEGIN {
    eval 'use Net::HTTP2::nghttp2; 1'
      or plan skip_all => 'Net::HTTP2::nghttp2 required for this test';
}

use Google::Cloud::Transport::Adapter::Nghttp2;

subtest 'Session Reuse' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    my $mock_session = Test::MockModule->new('Net::HTTP2::nghttp2::Session');
    my $mock_ssleay = Test::MockModule->new('Net::SSLeay');
    
    my $handle_new_count = 0;
    my $captured_on_starttls;
    my %stream_user_data;
    my $captured_callbacks;
    
    $mock_handle->mock(
        new => sub {
            my ($class, %args) = @_;
            $handle_new_count++;
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
    
    my $future1 = $adapter->request(url => 'https://example.com/1');
    is($handle_new_count, 1, 'Handle created for first request');
    
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    
    $captured_callbacks->{on_stream_close}->(1, 0);
    ok($future1->is_done, 'First request done');
    
    my $future2 = $adapter->request(url => 'https://example.com/2');
    is($handle_new_count, 1, 'Handle NOT created for second request (reused)');
    
    ok($future2, 'Got future for second request');
};

subtest 'In-progress Connection Reuse' => sub {
    my $mock_handle = Test::MockModule->new('AnyEvent::Handle');
    my $mock_session = Test::MockModule->new('Net::HTTP2::nghttp2::Session');
    my $mock_ssleay = Test::MockModule->new('Net::SSLeay');
    
    my $handle_new_count = 0;
    my $captured_on_starttls;
    my %stream_user_data;
    my $captured_callbacks;
    
    $mock_handle->mock(
        new => sub {
            my ($class, %args) = @_;
            $handle_new_count++;
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
    
    my $future1 = $adapter->request(url => 'https://example.com/1');
    is($handle_new_count, 1, 'Handle created for first request');
    
    my $future2 = $adapter->request(url => 'https://example.com/2');
    is($handle_new_count, 1, 'Handle NOT created for second request (waiting for same connection)');
    
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    
    ok($future1, 'Got future 1');
    ok($future2, 'Got future 2');
};

done_testing();

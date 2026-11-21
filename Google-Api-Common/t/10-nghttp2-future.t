use strict;
use warnings;
use Test::More;
use Test::MockModule;
use AnyEvent;

BEGIN {
    eval 'use Net::HTTP2::nghttp2; 1'
      or plan skip_all => 'Net::HTTP2::nghttp2 required for this test';
}

use Google::Cloud::Transport::Adapter::Nghttp2;

subtest 'Future Await' => sub {
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
    my $future = $adapter->request(url => 'https://example.com/await');
    
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    
    my $w = AnyEvent->timer(after => 0.1, cb => sub {
        $captured_callbacks->{on_stream_close}->(1, 0);
    });
    
    my $awaited_future = $future->await;
    ok($awaited_future->is_ready, 'Future is ready after await');
    
    my $future2 = $adapter->request(url => 'https://example.com/await_shortcut');
    $captured_on_starttls->(bless({ tls => {} }, 'AnyEvent::Handle'), 1);
    $captured_callbacks->{on_stream_close}->(1, 0); # Make ready
    
    my $awaited_future2 = $future2->await;
    ok($awaited_future2->is_ready, 'Future is ready after await (shortcut)');
};

done_testing();

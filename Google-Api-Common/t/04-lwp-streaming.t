use strict;
use warnings;
use Test::More;
use Test::LWP::UserAgent;
use HTTP::Response;

use Google::Cloud::Transport::Adapter::LWP;

subtest 'Streaming Success' => sub {
    my $mock_ua = Test::LWP::UserAgent->new;
    
    $mock_ua->map_response(
        qr{example.com/stream_success} => sub {
            my ($request) = @_;
            return HTTP::Response->new(200, 'OK', ['Content-Type' => 'text/plain'], "Chunk 1\nChunk 2");
        }
    );

    my $adapter = Google::Cloud::Transport::Adapter::LWP->new(user_agent => $mock_ua);
    
    my $data_received = '';
    my $eof_received = 0;
    
    my $stream_handle = $adapter->start_stream(
        url => 'https://example.com/stream_success',
        on_data => sub { $data_received .= $_[0]; },
        on_eof => sub { $eof_received = 1; },
    );
    
    ok($stream_handle, 'Got stream handle');
    
    is($data_received, "Chunk 1\nChunk 2", 'Correct data received via callback');
    is($eof_received, 1, 'EOF received');
    
    # get_metadata
    my $metadata = $stream_handle->get_metadata('headers');
    is($metadata->{'content-type'}, 'text/plain', 'StreamHandle get_metadata returns headers');
    is_deeply($stream_handle->get_metadata('other'), {}, 'StreamHandle get_metadata returns empty hash for other');
    
    # write (should croak)
    eval { $stream_handle->write('foo') };
    ok($@, 'StreamHandle write croaked');
    like($@, qr/Write not supported/, 'Correct croak message for write');
    
    # close_write (should croak)
    eval { $stream_handle->close_write() };
    ok($@, 'StreamHandle close_write croaked');
    like($@, qr/Close write not supported/, 'Correct croak message for close_write');
};

subtest 'Streaming Failure' => sub {
    my $mock_ua = Test::LWP::UserAgent->new;
    $mock_ua->map_response(
        qr{example.com/stream_fail} => HTTP::Response->new(500, 'Internal Server Error', ['Content-Type' => 'text/plain'], 'Error Body')
    );

    my $adapter = Google::Cloud::Transport::Adapter::LWP->new(user_agent => $mock_ua);
    
    my $data_received = '';
    my $error_received = 0;
    my $error_res;
    
    my $stream_handle = $adapter->start_stream(
        url => 'https://example.com/stream_fail',
        on_data  => sub { $data_received .= $_[0]; },
        on_error => sub { $error_received = 1; $error_res = $_[1]; },
    );
    
    ok($stream_handle, 'Got stream handle');
    is($error_received, 1, 'Error received');
    isa_ok($error_res, 'HTTP::Response', 'Error response object included');
};

subtest 'Input Validation (Streaming)' => sub {
    my $adapter = Google::Cloud::Transport::Adapter::LWP->new();
    
    # Missing URL
    eval { $adapter->start_stream(on_data => sub { }) };
    ok($@, 'Missing URL croaked');
    like($@, qr/URL\/Path is required/, 'Correct croak message for missing URL');
    
    # Missing on_data
    eval { $adapter->start_stream(url => 'https://example.com') };
    ok($@, 'Missing on_data croaked');
    like($@, qr/on_data callback is required/, 'Correct croak message for missing on_data');
};

done_testing();

use strict;
use warnings;
use Test::More;
use Test::Exception;
use Future;

use Google::Cloud::ClientBase::Stream;

subtest 'Handle Data and Read' => sub {
    my $stream = Google::Cloud::ClientBase::Stream->new();
    
    # Pre-queue data
    $stream->_handle_data("chunk1");
    $stream->_handle_data("chunk2");
    
    my $f1 = $stream->read();
    ok($f1->is_ready, 'Read Future 1 ready immediately');
    is($f1->get, 'chunk1', 'Correct chunk 1');
    
    my $f2 = $stream->read();
    ok($f2->is_ready, 'Read Future 2 ready immediately');
    is($f2->get, 'chunk2', 'Correct chunk 2');
    
    # Pending reads
    my $f3 = $stream->read();
    ok(!$f3->is_ready, 'Read Future 3 pending');
    
    $stream->_handle_data("chunk3");
    ok($f3->is_ready, 'Read Future 3 ready after data');
    is($f3->get, 'chunk3', 'Correct chunk 3');
};

subtest 'Handle EOF' => sub {
    my $stream = Google::Cloud::ClientBase::Stream->new();
    
    my $f1 = $stream->read();
    ok(!$f1->is_ready, 'Read Future 1 pending');
    
    $stream->_handle_eof();
    ok($f1->is_ready, 'Read Future 1 ready after EOF');
    is($f1->get, undef, 'EOF returns undef');
    
    my $f2 = $stream->read();
    ok($f2->is_ready, 'Read Future 2 ready immediately after EOF');
    is($f2->get, undef, 'EOF returns undef');
};

subtest 'Handle Error' => sub {
    my $stream = Google::Cloud::ClientBase::Stream->new();
    
    my $f1 = $stream->read();
    ok(!$f1->is_ready, 'Read Future 1 pending');
    
    $stream->_handle_error("boom");
    ok($f1->is_ready, 'Read Future 1 ready after error');
    ok($f1->is_failed, 'Read Future 1 failed');
    my ($err, $cat) = $f1->failure;
    is($err, 'boom', 'Correct error');
    
    my $f2 = $stream->read();
    ok($f2->is_ready, 'Read Future 2 ready immediately after error');
    ok($f2->is_failed, 'Read Future 2 failed');
};

subtest 'Delegation to Low Level Stream' => sub {
    my $mock_low_level = bless {}, 'MockLowLevelStream';
    
    # Quick and dirty inline mocking for this test
    my $written = '';
    my $closed = 0;
    my $metadata_requested = '';
    
    no strict 'refs';
    local *{'MockLowLevelStream::write'} = sub { $written .= $_[1]; return Future->done; };
    local *{'MockLowLevelStream::close_write'} = sub { $closed = 1; };
    local *{'MockLowLevelStream::get_metadata'} = sub { $metadata_requested = $_[1]; return { key => 'val' }; };
    use strict;
    
    my $stream = Google::Cloud::ClientBase::Stream->new(low_level_stream => $mock_low_level);
    
    $stream->write("hello");
    is($written, 'hello', 'Write delegated');
    
    $stream->close_write();
    is($closed, 1, 'Close write delegated');
    
    my $meta = $stream->get_metadata('headers');
    is($metadata_requested, 'headers', 'Get metadata delegated');
    is($meta->{key}, 'val', 'Correct metadata returned');
};

subtest 'Missing Low Level Stream Errors' => sub {
    my $stream = Google::Cloud::ClientBase::Stream->new();
    
    throws_ok { $stream->write('hello') } qr/Write not supported/, 'Write fails without low level stream';
    throws_ok { $stream->close_write() } qr/Close write not supported/, 'Close write fails without low level stream';
    throws_ok { $stream->get_metadata('headers') } qr/Get metadata not supported/, 'Get metadata fails without low level stream';
};

done_testing();

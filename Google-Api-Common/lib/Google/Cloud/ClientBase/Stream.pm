package Google::Cloud::ClientBase::Stream;

use strict;
use warnings;
use Moo;
use Future;
use Carp qw(croak);

our $VERSION = '0.01';

has low_level_stream => (
    is       => 'rw',
    required => 0,
);

# Internal queues and state
has _pending_reads => ( is => 'ro', default => sub { [] } );
has _chunk_queue   => ( is => 'ro', default => sub { [] } );
has _eof           => ( is => 'rw', default => 0 );
has _error         => ( is => 'rw' );

sub _handle_data {
    my ($self, $chunk) = @_;
    
    if (my $future = shift @{$self->_pending_reads}) {
        $future->done($chunk);
    } else {
        push @{$self->_chunk_queue}, $chunk;
    }
}

sub _handle_eof {
    my ($self) = @_;
    $self->_eof(1);
    
    # Resolve all pending reads with undef (EOF)
    while (my $future = shift @{$self->_pending_reads}) {
        $future->done(undef);
    }
}

sub _handle_error {
    my ($self, $error) = @_;
    $self->_error($error);
    
    # Fail all pending reads
    while (my $future = shift @{$self->_pending_reads}) {
        $future->fail($error, 'Stream');
    }
}

=head2 read

Returns a Future resolving to the next chunk (raw bytes) or undef on EOF.

=cut

sub read {
    my ($self) = @_;
    
    if ($self->_error) {
        return Future->fail($self->_error, 'Stream');
    }
    
    if (my $chunk = shift @{$self->_chunk_queue}) {
        return Future->done($chunk);
    }
    
    if ($self->_eof) {
        return Future->done(undef);
    }
    
    my $future = Future->new;
    push @{$self->_pending_reads}, $future;
    return $future;
}

=head2 write

Send data on the stream. Delegates to low-level stream.

=cut

sub write {
    my ($self, $data) = @_;
    if ($self->low_level_stream) {
        return $self->low_level_stream->write($data);
    }
    croak 'Write not supported by this stream (missing low_level_stream)';
}

=head2 close_write

Close the stream for writing. Delegates to low-level stream.

=cut

sub close_write {
    my ($self) = @_;
    if ($self->low_level_stream) {
        return $self->low_level_stream->close_write();
    }
    croak 'Close write not supported by this stream (missing low_level_stream)';
}

=head2 get_metadata

Get stream metadata. Delegates to low-level stream.

=cut

sub get_metadata {
    my ($self, $type) = @_;
    if ($self->low_level_stream) {
        return $self->low_level_stream->get_metadata($type);
    }
    croak 'Get metadata not supported by this stream (missing low_level_stream)';
}

1;

__END__

=head1 NAME

Google::Cloud::ClientBase::Stream - High-level ergonomic Stream wrapper

=head1 DESCRIPTION

This class wraps a low-level callback-based transport stream and provides
a high-level, ergonomic API using Futures for sequential reading.

=cut

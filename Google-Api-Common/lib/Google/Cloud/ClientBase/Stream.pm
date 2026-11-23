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

sub write {
    my ($self, $data) = @_;
    if ($self->low_level_stream) {
        return $self->low_level_stream->write($data);
    }
    croak 'Write not supported by this stream (missing low_level_stream)';
}

sub close_write {
    my ($self) = @_;
    if ($self->low_level_stream) {
        return $self->low_level_stream->close_write();
    }
    croak 'Close write not supported by this stream (missing low_level_stream)';
}

sub get_metadata {
    my ($self, $type) = @_;
    if ($self->low_level_stream) {
        return $self->low_level_stream->get_metadata($type);
    }
    croak 'Get metadata not supported by this stream (missing low_level_stream)';
}

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Cloud::ClientBase::Stream - Future-based ergonomic stream wrapper for Google Cloud transports

=head1 SYNOPSIS

    # Usually returned by $client->start_stream(...)
    my $stream = $client->start_stream(
        method => 'GET',
        url    => 'https://storage.googleapis.com/storage/v1/b/my-bucket/o/file?alt=media',
    );

    # Read chunks sequentially via Future
    while (defined(my $chunk = $stream->read()->get())) {
        print $chunk;
    }

    # For bidirectional / upload streams:
    $stream->write($payload_chunk);
    $stream->close_write();

    # Inspect response headers / trailers
    my $headers = $stream->get_metadata('headers');

=head1 DESCRIPTION

C<Google::Cloud::ClientBase::Stream> bridges low-level callback-driven
transport streams (L<Google::Cloud::Transport::Role::Stream>) into an ergonomic
L<Future>-based pull API. Incoming chunks are buffered in FIFO order when
producers run ahead of readers, and pending C<read()> Futures resolve as soon
as data arrives, C<undef> on EOF, or fail on stream error.

=head1 ATTRIBUTES

=head2 low_level_stream

Optional underlying transport stream object (implementing
L<Google::Cloud::Transport::Role::Stream>) used to delegate C<write()>,
C<close_write()>, and C<get_metadata()>.

=head1 METHODS

=head2 read()

    my $future = $stream->read();
    my $chunk  = $future->get(); # raw bytes, or undef on EOF

Returns a L<Future> resolving to the next raw byte chunk, or C<undef> once the
stream reaches EOF. Fails with category C<'Stream'> if the transport reported
an error.

=head2 write( $data )

Writes C<$data> to the underlying C<low_level_stream>. Croaks if no
C<low_level_stream> is attached.

=head2 close_write()

Signals end-of-input on the write side of the underlying C<low_level_stream>.
Croaks if no C<low_level_stream> is attached.

=head2 get_metadata( $type )

Retrieves stream metadata (such as C<'headers'> or C<'trailers'>) from the
underlying C<low_level_stream>. Croaks if no C<low_level_stream> is attached.

=head1 SEE ALSO

L<Google::Cloud::ClientBase>, L<Google::Api::Common>,
L<Google::Cloud::Transport::Role::Stream>, L<Future>

=head1 AUTHOR

C.J. Collier E<lt>cjac@google.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2026 Google LLC and contributors.

Licensed under the Apache License, Version 2.0.

=cut

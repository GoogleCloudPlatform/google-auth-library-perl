package Google::Cloud::Transport::Role::Stream;

use strict;
use warnings;
use Moo::Role;

our $VERSION = '0.13';

# Send data on the stream
# @param $data: Raw bytes to send
# @returns: A Future resolving when write is complete (handles backpressure/flow control)
requires 'write';

# Close the stream for writing
requires 'close_write';

# Get stream metadata (Headers/Trailers)
# @param $type: 'headers' or 'trailers'
# @returns: HashRef of metadata
requires 'get_metadata';

1;

=head1 NAME

Google::Cloud::Transport::Role::Stream - Role for Pluggable Transport Streams

=head1 SYNOPSIS

    package Google::Cloud::Transport::Stream::MyStream;
    use Moo;
    with 'Google::Cloud::Transport::Role::Stream';

    sub write {
        my ($self, $data) = @_;
        # ... implement non-blocking write ...
    }

    sub close_write {
        my ($self) = @_;
        # ... close stream for writing ...
    }

    sub read {
        my ($self) = @_;
        # ... implement non-blocking read returning Future ...
    }

    sub get_metadata {
        my ($self, $type) = @_;
        # ... return headers or trailers ...
    }

=head1 DESCRIPTION

This role defines the interface for streaming handles in the Google Cloud SDK.
Streams must implement non-blocking read and write operations returning Futures.

=head1 AUTHOR

C.J. Collier E<lt>cjac@google.comE<gt>

=head1 LICENSE

Apache License 2.0

=cut

package Google::Cloud::Transport::Role::Adapter;

use strict;
use warnings;
use Moo::Role;

our $VERSION = '0.13';

# Unified request method
# @param %args:
#   method: HTTP method (GET, POST, etc.) or gRPC method
#   url/path: Target URL or path
#   headers: HashRef of headers
#   body: Raw bytes payload (String or ScalarRef)
#   timeout: Timeout in seconds
# @returns: A Future resolving to the response body (raw bytes) and headers
requires 'request';

# Initiates a stream handle
# @param %args:
#   method: HTTP method (GET, POST, etc.) or gRPC method
#   url/path: Target URL or path
#   headers: HashRef of headers
#   body: Raw bytes payload (String or ScalarRef)
#   timeout: Timeout in seconds
#   on_data: CodeRef invoked with data chunk (raw bytes)
#   on_eof: CodeRef invoked on EOF
#   on_error: CodeRef invoked on error
# @returns: A Stream object implementing Google::Cloud::Transport::Role::Stream
requires 'start_stream';

1;

=head1 NAME

Google::Cloud::Transport::Role::Adapter - Role for Pluggable Transport Adapters

=head1 SYNOPSIS

    package Google::Cloud::Transport::Adapter::MyAdapter;
    use Moo;
    with 'Google::Cloud::Transport::Role::Adapter';

    sub request {
        my ($self, %args) = @_;
        # ... implement non-blocking request returning Future ...
    }

    sub start_stream {
        my ($self, %args) = @_;
        # ... implement streaming ...
    }

=head1 DESCRIPTION

This role defines the interface for transport adapters in the Google Cloud SDK.
Adapters must implement both unary requests and streaming initiation, returning
appropriate async primitives (Futures).

=head1 AUTHOR

C.J. Collier E<lt>cjac@google.comE<gt>

=head1 LICENSE

Apache License 2.0

=cut

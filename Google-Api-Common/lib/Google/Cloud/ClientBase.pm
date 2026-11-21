package Google::Cloud::ClientBase;

use strict;
use warnings;
use Moo;
use JSON::MaybeXS qw(encode_json decode_json);
use Carp qw(croak);

our $VERSION = '0.01';

has transport => (
    is      => 'rw',
    lazy    => 1,
    builder => '_build_transport',
);

sub _build_transport {
    my ($self) = @_;
    require Google::Cloud::Transport::Adapter::LWP;
    return Google::Cloud::Transport::Adapter::LWP->new();
}

sub encode_payload {
    my ($self, $payload, $format) = @_;
    $format //= 'json';

    if ($format eq 'json') {
        my $hash;
        if (ref($payload) && eval { $payload->can('to_hash') }) {
            $hash = $payload->to_hash();
        } elsif (ref($payload) eq 'HASH') {
            $hash = $payload;
        }

        if ($hash && keys %$hash) {
            return encode_json($hash);
        }
        return; # Return undef if empty or not a hash/object
    } elsif ($format eq 'protobuf') {
        if (ref($payload) && eval { $payload->can('serialize') }) {
            return $payload->serialize();
        } else {
            croak 'Cannot serialize payload to protobuf: not a valid object';
        }
    } else {
        croak 'Unsupported format: ' . $format;
    }
}

sub decode_payload {
    my ($self, $body, $format, $response_class) = @_;
    $format //= 'json';

    return unless defined $body && length $body;

    if ($format eq 'json') {
        my $decoded_json = eval { decode_json($body) };
        if ($@) {
            croak 'Error decoding JSON response: ' . $@;
        }

        if ($response_class) {
            if (eval { $response_class->can('from_hash') }) {
                return $response_class->from_hash($decoded_json);
            } elsif (eval { $response_class->can('new') }) {
                return $response_class->new(ref($decoded_json) eq 'HASH' ? %$decoded_json : ());
            }
        }
        return $decoded_json;
    } elsif ($format eq 'protobuf') {
        if ($response_class && eval { $response_class->can('parse') }) {
            return $response_class->parse($body);
        } else {
            croak 'Cannot parse protobuf response: missing response_class or parse method';
        }
    } else {
        croak 'Unsupported format: ' . $format;
    }
}

=head2 start_stream

Initiates a stream and returns a high-level Google::Cloud::ClientBase::Stream object.

=cut

sub start_stream {
    my ($self, %args) = @_;
    
    require Google::Cloud::ClientBase::Stream;
    my $stream_wrapper = Google::Cloud::ClientBase::Stream->new();
    
    my $low_level_stream = $self->transport->start_stream(
        %args,
        on_data  => sub { $stream_wrapper->_handle_data(@_) },
        on_eof   => sub { $stream_wrapper->_handle_eof(@_) },
        on_error => sub { $stream_wrapper->_handle_error(@_) },
    );
    
    $stream_wrapper->low_level_stream($low_level_stream) if $low_level_stream;
    
    return $stream_wrapper;
}


1;

=head1 NAME

Google::Cloud::ClientBase - Base class for Google Cloud API clients

=head1 DESCRIPTION

This module provides common functionality for Google Cloud API clients,
including serialization/deserialization and transport management.

=cut

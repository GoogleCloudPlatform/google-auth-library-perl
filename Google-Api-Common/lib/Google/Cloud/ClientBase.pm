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

__END__

=encoding UTF-8

=head1 NAME

Google::Cloud::ClientBase - Reference base class for Google Cloud API clients (serialization and pluggable transport)

=head1 SYNOPSIS

    package My::Google::Cloud::Client;
    use Moo;
    extends 'Google::Cloud::ClientBase';

    sub get_resource {
        my ($self, $url) = @_;
        my $future = $self->transport->request(
            method => 'GET',
            url    => $url,
        );
        my ($body, $headers) = $future->get();
        return $self->decode_payload($body, 'json');
    }

    # Streaming downloads / uploads
    my $stream = $client->start_stream(
        method => 'GET',
        url    => 'https://storage.googleapis.com/storage/v1/b/my-bucket/o/file?alt=media',
    );
    while (defined(my $chunk = $stream->read()->get())) {
        ...
    }

=head1 DESCRIPTION

C<Google::Cloud::ClientBase> is the reference base class for Google Cloud Perl
client libraries (such as L<Google::Cloud::REST::Client>). It keeps the
transport layer strictly bytes-only by centralizing JSON and Protocol Buffers
serialization/deserialization in the calling layer, and wraps low-level
transport streams into L<Google::Cloud::ClientBase::Stream> handles.

=head1 ATTRIBUTES

=head2 transport

An object implementing L<Google::Cloud::Transport::Role::Adapter>. Defaults to
a lazily constructed L<Google::Cloud::Transport::Adapter::LWP> instance, and
may be swapped for L<Google::Cloud::Transport::Adapter::NetCurl> or
L<Google::Cloud::Transport::Adapter::Nghttp2>.

=head1 METHODS

=head2 encode_payload( $payload, $format )

    my $json_bytes  = $client->encode_payload({ key => 'value' }, 'json');
    my $proto_bytes = $client->encode_payload($proto_msg, 'protobuf');

Serializes C<$payload> according to C<$format> (C<'json'>, the default, or
C<'protobuf'>). For C<'json'>, accepts a HashRef or an object implementing
C<to_hash()>. For C<'protobuf'>, requires an object implementing C<serialize()>.

=head2 decode_payload( $body, $format, $response_class )

    my $hash = $client->decode_payload($json_bytes, 'json');
    my $obj  = $client->decode_payload($proto_bytes, 'protobuf', 'My::Response');

Deserializes raw response bytes according to C<$format> (C<'json'> or
C<'protobuf'>). When C<$response_class> is supplied, constructs an instance via
C<from_hash()>, C<new()>, or C<parse()> (for Protobuf).

=head2 start_stream( %args )

    my $stream = $client->start_stream(
        method  => 'GET',
        url     => $url,
        headers => \%headers,
    );

Initiates a streaming request on C<< $self->transport >> and returns a
high-level L<Google::Cloud::ClientBase::Stream> object whose C<read()> method
returns a L<Future> for each incoming chunk (or C<undef> on EOF).

=head1 SEE ALSO

L<Google::Api::Common>, L<Google::Cloud::REST::Client>,
L<Google::Cloud::ClientBase::Stream>,
L<Google::Cloud::Transport::Role::Adapter>,
L<Google::Cloud::Transport::Adapter::LWP>,
L<Google::Cloud::Transport::Adapter::NetCurl>,
L<Google::Cloud::Transport::Adapter::Nghttp2>

=head1 AUTHOR

C.J. Collier E<lt>cjac@google.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2026 Google LLC and contributors.

Licensed under the Apache License, Version 2.0.

=cut

package Google::Cloud::PubSub::V1::PublisherClient;

use strict;
use warnings;
use Moo;
use Google::gRPC::Client;
use Google::Cloud::REST::Client;
use Google::Auth;
use Carp qw(croak);

use Protobuf;
use Google::Api::Common;
use Google::Pubsub::V1::Pubsub;
use Google::Pubsub::V1::Schema;

our $VERSION = '0.03';

has credentials => ( is => 'ro', required => 0 );
has transport   => ( is => 'rw' );

sub BUILD {
    my ($self) = @_;

    # Resolve credentials: use passed credentials object if it implements get_token, or default to ADC
    my $auth = $self->credentials;
    if (!$auth || !eval { $auth->can('get_token') }) {
        $auth = Google::Auth->default();
    }
    my $token = $auth->get_token();

    my $target = 'localhost:50051';
    my $t = $self->transport || 'grpc';

    if (ref($t) && eval { $t->can('call') }) {
        # Already a transport object
    } elsif (lc($t) eq 'rest') {
        my $client = Google::Cloud::REST::Client->new(
            target     => $target,
            auth_token => $token,
        );
        $self->transport($client);
    } else {
        # Default high-performance HTTP/2 gRPC client
        my $client = Google::gRPC::Client->new(
            target     => $target,
            auth_token => $token,
        );
        $self->transport($client);
    }
}

sub create_topic {
    my ($self, %params) = @_;

    my $request_class = 'Google::Pubsub::V1::Pubsub::Topic';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Pubsub::V1::Pubsub::Topic';
    my $response = $self->transport->call({
        service        => 'google.pubsub.v1.Publisher',
        method         => 'CreateTopic',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_schema {
    my ($self, %params) = @_;

    my $request_class = 'Google::Pubsub::V1::Schema::CreateSchemaRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Pubsub::V1::Schema::Schema';
    my $response = $self->transport->call({
        service        => 'google.pubsub.v1.SchemaService',
        method         => 'CreateSchema',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub validate_schema {
    my ($self, %params) = @_;

    my $request_class = 'Google::Pubsub::V1::Schema::ValidateSchemaRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Pubsub::V1::Schema::ValidateSchemaResponse';
    my $response = $self->transport->call({
        service        => 'google.pubsub.v1.SchemaService',
        method         => 'ValidateSchema',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub validate_message {
    my ($self, %params) = @_;

    my $request_class = 'Google::Pubsub::V1::Schema::ValidateMessageRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Pubsub::V1::Schema::ValidateMessageResponse';
    my $response = $self->transport->call({
        service        => 'google.pubsub.v1.SchemaService',
        method         => 'ValidateMessage',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}
1; # End of Google::Cloud::PubSub::V1::PublisherClient

__END__

=head1 NAME

Google::Cloud::PubSub::V1::PublisherClient - Auto-generated client library for Google Cloud Services

=head1 SYNOPSIS

    use Google::Cloud::PubSub::V1::PublisherClient;
    use Google::Auth;

    # Initialize Application Default Credentials (ADC) or explicit Google Auth
    my $auth = Google::Auth->default();
    my $client = Google::Cloud::PubSub::V1::PublisherClient->new( credentials => $auth );

    # Execute service methods
    my $res = $client->some_method( %params );

=head1 DESCRIPTION

This is an auto-generated Protocol Buffers client library for Google Cloud Services, built on top of high-performance gRPC and Protocol Buffers!

It provides seamless integration with Google Cloud Application Default Credentials (ADC), support for both HTTP/2 gRPC and REST transports, and fully typed RPC method dispatching.

=head1 CONSTRUCTOR

=head2 new

    my $client = Google::Cloud::PubSub::V1::PublisherClient->new(
        credentials => $auth,       # Optional: Google::Auth object (defaults to ADC)
        transport   => 'grpc',     # Optional: 'grpc' (default) or 'rest'
    );

=head1 ATTRIBUTES

=head2 credentials

Returns or accepts the L<Google::Auth> credentials object.

=head2 transport

Returns or accepts the transport instance (L<Google::gRPC::Client> or L<Google::Cloud::REST::Client>).

=head1 METHODS

=head2 METHODS

The following RPC methods are available in this client:

=over 4

=item * B<create_topic>

Calls the RPC method C<CreateTopic> on the service. Takes a hash of parameters representing the request.

=item * B<create_schema>

Calls the RPC method C<CreateSchema> on the service. Takes a hash of parameters representing the request.

=item * B<validate_schema>

Calls the RPC method C<ValidateSchema> on the service. Takes a hash of parameters representing the request.

=item * B<validate_message>

Calls the RPC method C<ValidateMessage> on the service. Takes a hash of parameters representing the request.

=back



=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

package Google::Cloud::PrivateCA::V1::CertificateAuthorityServiceClient;

use strict;
use warnings;
use Moo;
use Google::gRPC::Client;
use Google::Cloud::REST::Client;
use Google::Auth;
use Carp qw(croak);

use Protobuf;
use Google::Api::Common;
use Google::Cloud::Security::Privateca::V1::Resources;
use Google::Cloud::Security::Privateca::V1::Service;

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

sub create_certificate {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Security::Privateca::V1::Service::CreateCertificateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Security::Privateca::V1::Service::Certificate';
    my $response = $self->transport->call({
        service        => 'google.cloud.security.privateca.v1.CertificateAuthorityService',
        method         => 'CreateCertificate',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}
1; # End of Google::Cloud::PrivateCA::V1::CertificateAuthorityServiceClient

__END__

=head1 NAME

Google::Cloud::PrivateCA::V1::CertificateAuthorityServiceClient - Auto-generated client library for Google Cloud Services

=head1 SYNOPSIS

    use Google::Cloud::PrivateCA::V1::CertificateAuthorityServiceClient;
    use Google::Auth;

    # Initialize Application Default Credentials (ADC) or explicit Google Auth
    my $auth = Google::Auth->default();
    my $client = Google::Cloud::PrivateCA::V1::CertificateAuthorityServiceClient->new( credentials => $auth );

    # Execute service methods
    my $res = $client->some_method( %params );

=head1 DESCRIPTION

This is an auto-generated Protocol Buffers client library for Google Cloud Services, built on top of high-performance gRPC and Protocol Buffers!

It provides seamless integration with Google Cloud Application Default Credentials (ADC), support for both HTTP/2 gRPC and REST transports, and fully typed RPC method dispatching.

=head1 CONSTRUCTOR

=head2 new

    my $client = Google::Cloud::PrivateCA::V1::CertificateAuthorityServiceClient->new(
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

=item * B<create_certificate>

Calls the RPC method C<CreateCertificate> on the service. Takes a hash of parameters representing the request.

=back



=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

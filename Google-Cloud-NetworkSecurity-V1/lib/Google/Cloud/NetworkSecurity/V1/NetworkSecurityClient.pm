package Google::Cloud::NetworkSecurity::V1::NetworkSecurityClient;

use strict;
use warnings;
use Moo;
use Google::gRPC::Client;
use Google::Cloud::REST::Client;
use Google::Auth;
use Carp qw(croak);

use Protobuf;
use Google::Api::Common;
use Google::Cloud::Networksecurity::V1::TlsInspectionPolicy;
use Google::Cloud::Networksecurity::V1::ClientTlsPolicy;
use Google::Cloud::Networksecurity::V1::GatewaySecurityPolicyRule;
use Google::Cloud::Networksecurity::V1::SseRealm;
use Google::Cloud::Networksecurity::V1::DnsThreatDetector;
use Google::Cloud::Networksecurity::V1::AuthorizationPolicy;
use Google::Cloud::Networksecurity::V1::Intercept;
use Google::Cloud::Networksecurity::V1::UrlList;
use Google::Cloud::Networksecurity::V1::Tls;
use Google::Cloud::Networksecurity::V1::SecurityProfileGroupUrlfiltering;
use Google::Cloud::Networksecurity::V1::GatewaySecurityPolicy;
use Google::Cloud::Networksecurity::V1::AddressGroup;
use Google::Cloud::Networksecurity::V1::NetworkSecurity;
use Google::Cloud::Networksecurity::V1::BackendAuthenticationConfig;
use Google::Cloud::Networksecurity::V1::AuthzPolicy;
use Google::Cloud::Networksecurity::V1::SecurityProfileGroupThreatprevention;
use Google::Cloud::Networksecurity::V1::Common;
use Google::Cloud::Networksecurity::V1::SecurityProfileGroupIntercept;
use Google::Cloud::Networksecurity::V1::Mirroring;
use Google::Cloud::Networksecurity::V1::SecurityProfileGroup;
use Google::Cloud::Networksecurity::V1::SecurityProfileGroupService;
use Google::Cloud::Networksecurity::V1::ServerTlsPolicy;
use Google::Cloud::Networksecurity::V1::SecurityProfileGroupMirroring;
use Google::Cloud::Networksecurity::V1::FirewallActivation;

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

sub list_sacrealms {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Networksecurity::V1::SseRealm::ListSACRealmsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Networksecurity::V1::SseRealm::ListSACRealmsResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.networksecurity.v1.SSERealmService',
        method         => 'ListSACRealms',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_dns_threat_detectors {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Networksecurity::V1::DnsThreatDetector::ListDnsThreatDetectorsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Networksecurity::V1::DnsThreatDetector::ListDnsThreatDetectorsResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.networksecurity.v1.DnsThreatDetectorService',
        method         => 'ListDnsThreatDetectors',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_intercept_endpoint_groups {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Networksecurity::V1::Intercept::ListInterceptEndpointGroupsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Networksecurity::V1::Intercept::ListInterceptEndpointGroupsResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.networksecurity.v1.Intercept',
        method         => 'ListInterceptEndpointGroups',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_address_groups {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Networksecurity::V1::AddressGroup::ListAddressGroupsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Networksecurity::V1::AddressGroup::ListAddressGroupsResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.networksecurity.v1.AddressGroupService',
        method         => 'ListAddressGroups',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_authorization_policies {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Networksecurity::V1::NetworkSecurity::ListAuthorizationPoliciesRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Networksecurity::V1::NetworkSecurity::ListAuthorizationPoliciesResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.networksecurity.v1.NetworkSecurity',
        method         => 'ListAuthorizationPolicies',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_mirroring_endpoint_groups {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Networksecurity::V1::Mirroring::ListMirroringEndpointGroupsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Networksecurity::V1::Mirroring::ListMirroringEndpointGroupsResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.networksecurity.v1.Mirroring',
        method         => 'ListMirroringEndpointGroups',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_security_profile_groups {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Networksecurity::V1::SecurityProfileGroupService::ListSecurityProfileGroupsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Networksecurity::V1::SecurityProfileGroupService::ListSecurityProfileGroupsResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.networksecurity.v1.SecurityProfileGroupService',
        method         => 'ListSecurityProfileGroups',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_firewall_endpoints {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Networksecurity::V1::FirewallActivation::ListFirewallEndpointsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Networksecurity::V1::FirewallActivation::ListFirewallEndpointsResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.networksecurity.v1.FirewallActivation',
        method         => 'ListFirewallEndpoints',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}
1; # End of Google::Cloud::NetworkSecurity::V1::NetworkSecurityClient

__END__

=head1 NAME

Google::Cloud::NetworkSecurity::V1::NetworkSecurityClient - Auto-generated client library for Google Cloud Services

=head1 SYNOPSIS

    use Google::Cloud::NetworkSecurity::V1::NetworkSecurityClient;
    use Google::Auth;

    # Initialize Application Default Credentials (ADC) or explicit Google Auth
    my $auth = Google::Auth->default();
    my $client = Google::Cloud::NetworkSecurity::V1::NetworkSecurityClient->new( credentials => $auth );

    # Execute service methods
    my $res = $client->some_method( %params );

=head1 DESCRIPTION

This is an auto-generated Protocol Buffers client library for Google Cloud Services, built on top of high-performance gRPC and Protocol Buffers!

It provides seamless integration with Google Cloud Application Default Credentials (ADC), support for both HTTP/2 gRPC and REST transports, and fully typed RPC method dispatching.

=head1 CONSTRUCTOR

=head2 new

    my $client = Google::Cloud::NetworkSecurity::V1::NetworkSecurityClient->new(
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

=item * B<list_sacrealms>

Calls the RPC method C<ListSACRealms> on the service. Takes a hash of parameters representing the request.

=item * B<list_dns_threat_detectors>

Calls the RPC method C<ListDnsThreatDetectors> on the service. Takes a hash of parameters representing the request.

=item * B<list_intercept_endpoint_groups>

Calls the RPC method C<ListInterceptEndpointGroups> on the service. Takes a hash of parameters representing the request.

=item * B<list_address_groups>

Calls the RPC method C<ListAddressGroups> on the service. Takes a hash of parameters representing the request.

=item * B<list_authorization_policies>

Calls the RPC method C<ListAuthorizationPolicies> on the service. Takes a hash of parameters representing the request.

=item * B<list_mirroring_endpoint_groups>

Calls the RPC method C<ListMirroringEndpointGroups> on the service. Takes a hash of parameters representing the request.

=item * B<list_security_profile_groups>

Calls the RPC method C<ListSecurityProfileGroups> on the service. Takes a hash of parameters representing the request.

=item * B<list_firewall_endpoints>

Calls the RPC method C<ListFirewallEndpoints> on the service. Takes a hash of parameters representing the request.

=back



=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

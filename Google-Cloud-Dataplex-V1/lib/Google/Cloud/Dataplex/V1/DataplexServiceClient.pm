package Google::Cloud::Dataplex::V1::DataplexServiceClient;

use strict;
use warnings;
use Moo;
use Google::gRPC::Client;
use Google::Cloud::REST::Client;
use Google::Auth;
use Carp qw(croak);

use Protobuf;
use Google::Api::Common;
use Google::Cloud::Dataplex::V1::DataQuality;
use Google::Cloud::Dataplex::V1::Resources;
use Google::Cloud::Dataplex::V1::DatascansCommon;
use Google::Cloud::Dataplex::V1::Service;
use Google::Cloud::Dataplex::V1::Datascans;
use Google::Cloud::Dataplex::V1::DataProfile;
use Google::Cloud::Dataplex::V1::Cmek;
use Google::Cloud::Dataplex::V1::BusinessGlossary;
use Google::Cloud::Dataplex::V1::Metadata;
use Google::Cloud::Dataplex::V1::Logs;
use Google::Cloud::Dataplex::V1::DataTaxonomy;
use Google::Cloud::Dataplex::V1::Security;
use Google::Cloud::Dataplex::V1::Catalog;
use Google::Cloud::Dataplex::V1::ApprovalWorkflow;
use Google::Cloud::Dataplex::V1::DataQualityRuleTemplate;
use Google::Cloud::Dataplex::V1::DataDocumentation;
use Google::Cloud::Dataplex::V1::Processing;
use Google::Cloud::Dataplex::V1::DataDiscovery;
use Google::Cloud::Dataplex::V1::Content;
use Google::Cloud::Dataplex::V1::DataProducts;
use Google::Cloud::Dataplex::V1::Tasks;
use Google::Cloud::Dataplex::V1::Analyze;

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

sub create_lake {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Dataplex::V1::Service::CreateLakeRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Longrunning::Operation::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.dataplex.v1.DataplexService',
        method         => 'CreateLake',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_data_scan {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Dataplex::V1::Datascans::CreateDataScanRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Longrunning::Operation::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.dataplex.v1.DataScanService',
        method         => 'CreateDataScan',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_encryption_config {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Dataplex::V1::Cmek::CreateEncryptionConfigRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Longrunning::Operation::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.dataplex.v1.CmekService',
        method         => 'CreateEncryptionConfig',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_glossary {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Dataplex::V1::BusinessGlossary::CreateGlossaryRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Longrunning::Operation::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.dataplex.v1.BusinessGlossaryService',
        method         => 'CreateGlossary',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_entity {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Dataplex::V1::Metadata::CreateEntityRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Dataplex::V1::Metadata::Entity';
    my $response = $self->transport->call({
        service        => 'google.cloud.dataplex.v1.MetadataService',
        method         => 'CreateEntity',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_data_taxonomy {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Dataplex::V1::DataTaxonomy::CreateDataTaxonomyRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Longrunning::Operation::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.dataplex.v1.DataTaxonomyService',
        method         => 'CreateDataTaxonomy',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_entry_type {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Dataplex::V1::Catalog::CreateEntryTypeRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Longrunning::Operation::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.dataplex.v1.CatalogService',
        method         => 'CreateEntryType',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_data_product {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Dataplex::V1::DataProducts::CreateDataProductRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Longrunning::Operation::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.dataplex.v1.DataProductService',
        method         => 'CreateDataProduct',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}
1; # End of Google::Cloud::Dataplex::V1::DataplexServiceClient

__END__

=head1 NAME

Google::Cloud::Dataplex::V1::DataplexServiceClient - Auto-generated client library for Google Cloud Services

=head1 SYNOPSIS

    use Google::Cloud::Dataplex::V1::DataplexServiceClient;
    use Google::Auth;

    # Initialize Application Default Credentials (ADC) or explicit Google Auth
    my $auth = Google::Auth->default();
    my $client = Google::Cloud::Dataplex::V1::DataplexServiceClient->new( credentials => $auth );

    # Execute service methods
    my $res = $client->some_method( %params );

=head1 DESCRIPTION

This is an auto-generated Protocol Buffers client library for Google Cloud Services, built on top of high-performance gRPC and Protocol Buffers!

It provides seamless integration with Google Cloud Application Default Credentials (ADC), support for both HTTP/2 gRPC and REST transports, and fully typed RPC method dispatching.

=head1 CONSTRUCTOR

=head2 new

    my $client = Google::Cloud::Dataplex::V1::DataplexServiceClient->new(
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

=item * B<create_lake>

Calls the RPC method C<CreateLake> on the service. Takes a hash of parameters representing the request.

=item * B<create_data_scan>

Calls the RPC method C<CreateDataScan> on the service. Takes a hash of parameters representing the request.

=item * B<create_encryption_config>

Calls the RPC method C<CreateEncryptionConfig> on the service. Takes a hash of parameters representing the request.

=item * B<create_glossary>

Calls the RPC method C<CreateGlossary> on the service. Takes a hash of parameters representing the request.

=item * B<create_entity>

Calls the RPC method C<CreateEntity> on the service. Takes a hash of parameters representing the request.

=item * B<create_data_taxonomy>

Calls the RPC method C<CreateDataTaxonomy> on the service. Takes a hash of parameters representing the request.

=item * B<create_entry_type>

Calls the RPC method C<CreateEntryType> on the service. Takes a hash of parameters representing the request.

=item * B<create_data_product>

Calls the RPC method C<CreateDataProduct> on the service. Takes a hash of parameters representing the request.

=back



=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

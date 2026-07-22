package Google::Cloud::SQL::V1::SqlInstancesServiceClient;

use strict;
use warnings;
use Moo;
use Google::gRPC::Client;
use Google::Cloud::REST::Client;
use Google::Auth;
use Carp qw(croak);

use Protobuf;
use Google::Api::Common;
use Google::Cloud::Sql::V1::CloudSqlResources;
use Google::Cloud::Sql::V1::CloudSqlOperations;
use Google::Cloud::Sql::V1::CloudSqlTiers;
use Google::Cloud::Sql::V1::CloudSqlEvents;
use Google::Cloud::Sql::V1::CloudSqlUsers;
use Google::Cloud::Sql::V1::CloudSqlIamPolicies;
use Google::Cloud::Sql::V1::CloudSqlAvailableDatabaseVersions;
use Google::Cloud::Sql::V1::CloudSqlSslCerts;
use Google::Cloud::Sql::V1::CloudSqlInstanceNames;
use Google::Cloud::Sql::V1::CloudSqlInstances;
use Google::Cloud::Sql::V1::CloudSqlBackupRuns;
use Google::Cloud::Sql::V1::CloudSqlRegions;
use Google::Cloud::Sql::V1::CloudSqlConnect;
use Google::Cloud::Sql::V1::CloudSqlFlags;
use Google::Cloud::Sql::V1::CloudSqlFeatureEligibility;
use Google::Cloud::Sql::V1::CloudSqlDatabases;
use Google::Cloud::Sql::V1::CloudSqlBackups;

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

sub get {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsGetRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlOperations::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlOperationsService',
        method         => 'Get',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsListRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlOperations::OperationsListResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlOperationsService',
        method         => 'List',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub cancel {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsCancelRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Protobuf::Empty::Empty';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlOperationsService',
        method         => 'Cancel',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlTiers::SqlTiersListRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlTiers::TiersListResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlTiersService',
        method         => 'List',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub delete {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersDeleteRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlUsers::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlUsersService',
        method         => 'Delete',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersGetRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlUsers::User';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlUsersService',
        method         => 'Get',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub insert {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersInsertRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlUsers::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlUsersService',
        method         => 'Insert',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersListRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlUsers::UsersListResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlUsersService',
        method         => 'List',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub update {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersUpdateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlUsers::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlUsersService',
        method         => 'Update',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub delete {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlSslCerts::SqlSslCertsDeleteRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlSslCerts::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlSslCertsService',
        method         => 'Delete',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlSslCerts::SqlSslCertsGetRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlSslCerts::SslCert';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlSslCertsService',
        method         => 'Get',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub insert {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlSslCerts::SqlSslCertsInsertRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlSslCerts::SslCertsInsertResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlSslCertsService',
        method         => 'Insert',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlSslCerts::SqlSslCertsListRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlSslCerts::SslCertsListResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlSslCertsService',
        method         => 'List',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub add_server_ca {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesAddServerCaRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'AddServerCa',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub add_server_certificate {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesAddServerCertificateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'AddServerCertificate',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub add_entra_id_certificate {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesAddEntraIdCertificateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'AddEntraIdCertificate',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub clone {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesCloneRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Clone',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub delete {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesDeleteRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Delete',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub demote_master {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesDemoteMasterRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'DemoteMaster',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub demote {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesDemoteRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Demote',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub export {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesExportRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Export',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub failover {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesFailoverRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Failover',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub reencrypt {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesReencryptRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Reencrypt',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesGetRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::DatabaseInstance';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Get',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub import {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesImportRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Import',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub insert {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesInsertRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Insert',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesListRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::InstancesListResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'List',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_server_cas {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesListServerCasRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::InstancesListServerCasResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'ListServerCas',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_server_certificates {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesListServerCertificatesRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::InstancesListServerCertificatesResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'ListServerCertificates',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_entra_id_certificates {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesListEntraIdCertificatesRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::InstancesListEntraIdCertificatesResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'ListEntraIdCertificates',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub patch {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesPatchRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Patch',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub promote_replica {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesPromoteReplicaRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'PromoteReplica',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub switchover {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesSwitchoverRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Switchover',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub reset_ssl_config {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesResetSslConfigRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'ResetSslConfig',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub restart {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesRestartRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Restart',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub restore_backup {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesRestoreBackupRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'RestoreBackup',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub rotate_server_ca {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesRotateServerCaRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'RotateServerCa',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub rotate_server_certificate {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesRotateServerCertificateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'RotateServerCertificate',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub rotate_entra_id_certificate {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesRotateEntraIdCertificateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'RotateEntraIdCertificate',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub start_replica {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesStartReplicaRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'StartReplica',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub stop_replica {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesStopReplicaRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'StopReplica',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub truncate_log {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesTruncateLogRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'TruncateLog',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub update {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesUpdateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'Update',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_ephemeral {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesCreateEphemeralCertRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SslCert';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'CreateEphemeral',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub reschedule_maintenance {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesRescheduleMaintenanceRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'RescheduleMaintenance',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub verify_external_sync_settings {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesVerifyExternalSyncSettingsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesVerifyExternalSyncSettingsResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'VerifyExternalSyncSettings',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub start_external_sync {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesStartExternalSyncRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'StartExternalSync',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub perform_disk_shrink {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesPerformDiskShrinkRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'PerformDiskShrink',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get_disk_shrink_config {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesGetDiskShrinkConfigRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesGetDiskShrinkConfigResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'GetDiskShrinkConfig',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub reset_replica_size {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesResetReplicaSizeRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'ResetReplicaSize',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get_latest_recovery_time {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesGetLatestRecoveryTimeRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesGetLatestRecoveryTimeResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'GetLatestRecoveryTime',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub execute_sql {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesExecuteSqlRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesExecuteSqlResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'ExecuteSql',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub acquire_ssrs_lease {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesAcquireSsrsLeaseRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesAcquireSsrsLeaseResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'AcquireSsrsLease',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub release_ssrs_lease {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesReleaseSsrsLeaseRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesReleaseSsrsLeaseResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'ReleaseSsrsLease',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub pre_check_major_version_upgrade {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesPreCheckMajorVersionUpgradeRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'PreCheckMajorVersionUpgrade',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub point_in_time_restore {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::SqlInstancesPointInTimeRestoreRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlInstances::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlInstancesService',
        method         => 'PointInTimeRestore',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub delete {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlBackupRuns::SqlBackupRunsDeleteRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlBackupRuns::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlBackupRunsService',
        method         => 'Delete',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlBackupRuns::SqlBackupRunsGetRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlBackupRuns::BackupRun';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlBackupRunsService',
        method         => 'Get',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub insert {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlBackupRuns::SqlBackupRunsInsertRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlBackupRuns::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlBackupRunsService',
        method         => 'Insert',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlBackupRuns::SqlBackupRunsListRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlBackupRuns::BackupRunsListResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlBackupRunsService',
        method         => 'List',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get_connect_settings {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlConnect::GetConnectSettingsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlConnect::ConnectSettings';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlConnectService',
        method         => 'GetConnectSettings',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub generate_ephemeral_cert {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlConnect::GenerateEphemeralCertRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlConnect::GenerateEphemeralCertResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlConnectService',
        method         => 'GenerateEphemeralCert',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlFlags::SqlFlagsListRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlFlags::FlagsListResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlFlagsService',
        method         => 'List',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub delete {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::SqlDatabasesDeleteRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlDatabasesService',
        method         => 'Delete',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::SqlDatabasesGetRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::Database';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlDatabasesService',
        method         => 'Get',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub insert {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::SqlDatabasesInsertRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlDatabasesService',
        method         => 'Insert',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::SqlDatabasesListRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::DatabasesListResponse';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlDatabasesService',
        method         => 'List',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub patch {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::SqlDatabasesUpdateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlDatabasesService',
        method         => 'Patch',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub update {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::SqlDatabasesUpdateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlDatabases::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlDatabasesService',
        method         => 'Update',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_backup {
    my ($self, %params) = @_;

    my $request_class = 'Google::Cloud::Sql::V1::CloudSqlBackups::CreateBackupRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Cloud::Sql::V1::CloudSqlBackups::Operation';
    my $response = $self->transport->call({
        service        => 'google.cloud.sql.v1.SqlBackupsService',
        method         => 'CreateBackup',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}
1; # End of Google::Cloud::SQL::V1::SqlInstancesServiceClient

__END__

=head1 NAME

Google::Cloud::SQL::V1::SqlInstancesServiceClient - Auto-generated client library for Google Cloud Services

=head1 SYNOPSIS

    use Google::Cloud::SQL::V1::SqlInstancesServiceClient;
    use Google::Auth;

    # Initialize Application Default Credentials (ADC) or explicit Google Auth
    my $auth = Google::Auth->default();
    my $client = Google::Cloud::SQL::V1::SqlInstancesServiceClient->new( credentials => $auth );

    # Execute service methods
    my $res = $client->some_method( %params );

=head1 DESCRIPTION

This is an auto-generated Protocol Buffers client library for Google Cloud Services, built on top of high-performance gRPC and Protocol Buffers!

It provides seamless integration with Google Cloud Application Default Credentials (ADC), support for both HTTP/2 gRPC and REST transports, and fully typed RPC method dispatching.

=head1 CONSTRUCTOR

=head2 new

    my $client = Google::Cloud::SQL::V1::SqlInstancesServiceClient->new(
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

=item * B<get>

Calls the RPC method C<Get> on the service. Takes a hash of parameters representing the request.

=item * B<list>

Calls the RPC method C<List> on the service. Takes a hash of parameters representing the request.

=item * B<cancel>

Calls the RPC method C<Cancel> on the service. Takes a hash of parameters representing the request.

=item * B<list>

Calls the RPC method C<List> on the service. Takes a hash of parameters representing the request.

=item * B<delete>

Calls the RPC method C<Delete> on the service. Takes a hash of parameters representing the request.

=item * B<get>

Calls the RPC method C<Get> on the service. Takes a hash of parameters representing the request.

=item * B<insert>

Calls the RPC method C<Insert> on the service. Takes a hash of parameters representing the request.

=item * B<list>

Calls the RPC method C<List> on the service. Takes a hash of parameters representing the request.

=item * B<update>

Calls the RPC method C<Update> on the service. Takes a hash of parameters representing the request.

=item * B<delete>

Calls the RPC method C<Delete> on the service. Takes a hash of parameters representing the request.

=item * B<get>

Calls the RPC method C<Get> on the service. Takes a hash of parameters representing the request.

=item * B<insert>

Calls the RPC method C<Insert> on the service. Takes a hash of parameters representing the request.

=item * B<list>

Calls the RPC method C<List> on the service. Takes a hash of parameters representing the request.

=item * B<add_server_ca>

Calls the RPC method C<AddServerCa> on the service. Takes a hash of parameters representing the request.

=item * B<add_server_certificate>

Calls the RPC method C<AddServerCertificate> on the service. Takes a hash of parameters representing the request.

=item * B<add_entra_id_certificate>

Calls the RPC method C<AddEntraIdCertificate> on the service. Takes a hash of parameters representing the request.

=item * B<clone>

Calls the RPC method C<Clone> on the service. Takes a hash of parameters representing the request.

=item * B<delete>

Calls the RPC method C<Delete> on the service. Takes a hash of parameters representing the request.

=item * B<demote_master>

Calls the RPC method C<DemoteMaster> on the service. Takes a hash of parameters representing the request.

=item * B<demote>

Calls the RPC method C<Demote> on the service. Takes a hash of parameters representing the request.

=item * B<export>

Calls the RPC method C<Export> on the service. Takes a hash of parameters representing the request.

=item * B<failover>

Calls the RPC method C<Failover> on the service. Takes a hash of parameters representing the request.

=item * B<reencrypt>

Calls the RPC method C<Reencrypt> on the service. Takes a hash of parameters representing the request.

=item * B<get>

Calls the RPC method C<Get> on the service. Takes a hash of parameters representing the request.

=item * B<import>

Calls the RPC method C<Import> on the service. Takes a hash of parameters representing the request.

=item * B<insert>

Calls the RPC method C<Insert> on the service. Takes a hash of parameters representing the request.

=item * B<list>

Calls the RPC method C<List> on the service. Takes a hash of parameters representing the request.

=item * B<list_server_cas>

Calls the RPC method C<ListServerCas> on the service. Takes a hash of parameters representing the request.

=item * B<list_server_certificates>

Calls the RPC method C<ListServerCertificates> on the service. Takes a hash of parameters representing the request.

=item * B<list_entra_id_certificates>

Calls the RPC method C<ListEntraIdCertificates> on the service. Takes a hash of parameters representing the request.

=item * B<patch>

Calls the RPC method C<Patch> on the service. Takes a hash of parameters representing the request.

=item * B<promote_replica>

Calls the RPC method C<PromoteReplica> on the service. Takes a hash of parameters representing the request.

=item * B<switchover>

Calls the RPC method C<Switchover> on the service. Takes a hash of parameters representing the request.

=item * B<reset_ssl_config>

Calls the RPC method C<ResetSslConfig> on the service. Takes a hash of parameters representing the request.

=item * B<restart>

Calls the RPC method C<Restart> on the service. Takes a hash of parameters representing the request.

=item * B<restore_backup>

Calls the RPC method C<RestoreBackup> on the service. Takes a hash of parameters representing the request.

=item * B<rotate_server_ca>

Calls the RPC method C<RotateServerCa> on the service. Takes a hash of parameters representing the request.

=item * B<rotate_server_certificate>

Calls the RPC method C<RotateServerCertificate> on the service. Takes a hash of parameters representing the request.

=item * B<rotate_entra_id_certificate>

Calls the RPC method C<RotateEntraIdCertificate> on the service. Takes a hash of parameters representing the request.

=item * B<start_replica>

Calls the RPC method C<StartReplica> on the service. Takes a hash of parameters representing the request.

=item * B<stop_replica>

Calls the RPC method C<StopReplica> on the service. Takes a hash of parameters representing the request.

=item * B<truncate_log>

Calls the RPC method C<TruncateLog> on the service. Takes a hash of parameters representing the request.

=item * B<update>

Calls the RPC method C<Update> on the service. Takes a hash of parameters representing the request.

=item * B<create_ephemeral>

Calls the RPC method C<CreateEphemeral> on the service. Takes a hash of parameters representing the request.

=item * B<reschedule_maintenance>

Calls the RPC method C<RescheduleMaintenance> on the service. Takes a hash of parameters representing the request.

=item * B<verify_external_sync_settings>

Calls the RPC method C<VerifyExternalSyncSettings> on the service. Takes a hash of parameters representing the request.

=item * B<start_external_sync>

Calls the RPC method C<StartExternalSync> on the service. Takes a hash of parameters representing the request.

=item * B<perform_disk_shrink>

Calls the RPC method C<PerformDiskShrink> on the service. Takes a hash of parameters representing the request.

=item * B<get_disk_shrink_config>

Calls the RPC method C<GetDiskShrinkConfig> on the service. Takes a hash of parameters representing the request.

=item * B<reset_replica_size>

Calls the RPC method C<ResetReplicaSize> on the service. Takes a hash of parameters representing the request.

=item * B<get_latest_recovery_time>

Calls the RPC method C<GetLatestRecoveryTime> on the service. Takes a hash of parameters representing the request.

=item * B<execute_sql>

Calls the RPC method C<ExecuteSql> on the service. Takes a hash of parameters representing the request.

=item * B<acquire_ssrs_lease>

Calls the RPC method C<AcquireSsrsLease> on the service. Takes a hash of parameters representing the request.

=item * B<release_ssrs_lease>

Calls the RPC method C<ReleaseSsrsLease> on the service. Takes a hash of parameters representing the request.

=item * B<pre_check_major_version_upgrade>

Calls the RPC method C<PreCheckMajorVersionUpgrade> on the service. Takes a hash of parameters representing the request.

=item * B<point_in_time_restore>

Calls the RPC method C<PointInTimeRestore> on the service. Takes a hash of parameters representing the request.

=item * B<delete>

Calls the RPC method C<Delete> on the service. Takes a hash of parameters representing the request.

=item * B<get>

Calls the RPC method C<Get> on the service. Takes a hash of parameters representing the request.

=item * B<insert>

Calls the RPC method C<Insert> on the service. Takes a hash of parameters representing the request.

=item * B<list>

Calls the RPC method C<List> on the service. Takes a hash of parameters representing the request.

=item * B<get_connect_settings>

Calls the RPC method C<GetConnectSettings> on the service. Takes a hash of parameters representing the request.

=item * B<generate_ephemeral_cert>

Calls the RPC method C<GenerateEphemeralCert> on the service. Takes a hash of parameters representing the request.

=item * B<list>

Calls the RPC method C<List> on the service. Takes a hash of parameters representing the request.

=item * B<delete>

Calls the RPC method C<Delete> on the service. Takes a hash of parameters representing the request.

=item * B<get>

Calls the RPC method C<Get> on the service. Takes a hash of parameters representing the request.

=item * B<insert>

Calls the RPC method C<Insert> on the service. Takes a hash of parameters representing the request.

=item * B<list>

Calls the RPC method C<List> on the service. Takes a hash of parameters representing the request.

=item * B<patch>

Calls the RPC method C<Patch> on the service. Takes a hash of parameters representing the request.

=item * B<update>

Calls the RPC method C<Update> on the service. Takes a hash of parameters representing the request.

=item * B<create_backup>

Calls the RPC method C<CreateBackup> on the service. Takes a hash of parameters representing the request.

=back



=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

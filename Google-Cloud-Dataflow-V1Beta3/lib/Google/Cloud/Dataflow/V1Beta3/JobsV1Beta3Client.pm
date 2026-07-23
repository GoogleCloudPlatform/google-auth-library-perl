package Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client;

use strict;
use warnings;
use Moo;
use Google::gRPC::Client;
use Google::Cloud::REST::Client;
use Google::Auth;
use Carp qw(croak);

use Protobuf;
use Google::Api::Common;
use Google::Dataflow::V1BETA3::Templates;
use Google::Dataflow::V1BETA3::Messages;
use Google::Dataflow::V1BETA3::Environment;
use Google::Dataflow::V1BETA3::Metrics;
use Google::Dataflow::V1BETA3::Jobs;
use Google::Dataflow::V1BETA3::Snapshots;
use Google::Dataflow::V1BETA3::Streaming;

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

sub create_job_from_template {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Templates::CreateJobFromTemplateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Jobs::Job';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.TemplatesService',
        method         => 'CreateJobFromTemplate',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub launch_template {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Templates::LaunchTemplateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Templates::LaunchTemplateResponse';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.TemplatesService',
        method         => 'LaunchTemplate',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get_template {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Templates::GetTemplateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Templates::GetTemplateResponse';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.TemplatesService',
        method         => 'GetTemplate',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub launch_flex_template {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Templates::LaunchFlexTemplateRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Templates::LaunchFlexTemplateResponse';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.FlexTemplatesService',
        method         => 'LaunchFlexTemplate',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_job_messages {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Messages::ListJobMessagesRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Messages::ListJobMessagesResponse';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.MessagesV1Beta3',
        method         => 'ListJobMessages',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get_job_metrics {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Metrics::GetJobMetricsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Metrics::JobMetrics';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.MetricsV1Beta3',
        method         => 'GetJobMetrics',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get_job_execution_details {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Metrics::GetJobExecutionDetailsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Metrics::JobExecutionDetails';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.MetricsV1Beta3',
        method         => 'GetJobExecutionDetails',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get_stage_execution_details {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Metrics::GetStageExecutionDetailsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Metrics::StageExecutionDetails';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.MetricsV1Beta3',
        method         => 'GetStageExecutionDetails',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_job {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Jobs::CreateJobRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Jobs::Job';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.JobsV1Beta3',
        method         => 'CreateJob',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get_job {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Jobs::GetJobRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Jobs::Job';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.JobsV1Beta3',
        method         => 'GetJob',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub update_job {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Jobs::UpdateJobRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Jobs::Job';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.JobsV1Beta3',
        method         => 'UpdateJob',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_jobs {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Jobs::ListJobsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Jobs::ListJobsResponse';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.JobsV1Beta3',
        method         => 'ListJobs',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub aggregated_list_jobs {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Jobs::ListJobsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Jobs::ListJobsResponse';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.JobsV1Beta3',
        method         => 'AggregatedListJobs',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub check_active_jobs {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Jobs::CheckActiveJobsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Jobs::CheckActiveJobsResponse';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.JobsV1Beta3',
        method         => 'CheckActiveJobs',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub snapshot_job {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Jobs::SnapshotJobRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Snapshots::Snapshot';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.JobsV1Beta3',
        method         => 'SnapshotJob',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get_snapshot {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Snapshots::GetSnapshotRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Snapshots::Snapshot';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.SnapshotsV1Beta3',
        method         => 'GetSnapshot',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub delete_snapshot {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Snapshots::DeleteSnapshotRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Snapshots::DeleteSnapshotResponse';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.SnapshotsV1Beta3',
        method         => 'DeleteSnapshot',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_snapshots {
    my ($self, %params) = @_;

    my $request_class = 'Google::Dataflow::V1BETA3::Snapshots::ListSnapshotsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Dataflow::V1BETA3::Snapshots::ListSnapshotsResponse';
    my $response = $self->transport->call({
        service        => 'google.dataflow.v1beta3.SnapshotsV1Beta3',
        method         => 'ListSnapshots',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}
1; # End of Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client

__END__

=head1 NAME

Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client - Client library for Google Cloud Services

=head1 SYNOPSIS

    use Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client;
    use Google::Auth;

    my $auth = Google::Auth->default();

    # 1. High-performance gRPC Transport (Default)
    my $grpc_client = Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client->new(
        credentials => $auth,
        transport   => 'grpc', # Optional: 'grpc' is default
    );

    # 2. HTTP/REST Transport
    my $rest_client = Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client->new(
        credentials => $auth,
        transport   => 'rest',
    );

    # Execute service methods
    my $res = $grpc_client->some_method( %params );

=head1 DESCRIPTION

C<Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client> is an auto-generated client library for Google Cloud Services.

It provides a unified client interface supporting both high-performance HTTP/2 gRPC and HTTP/REST transports, with automatic Google Cloud Application Default Credentials (ADC) resolution and typed Protocol Buffers message handling.

=head1 SOURCE

Generated from the following Protocol Buffers schemas:

=over 4

=item * C<googleapis/google/dataflow/v1beta3/templates.proto>

=item * C<googleapis/google/dataflow/v1beta3/messages.proto>

=item * C<googleapis/google/dataflow/v1beta3/environment.proto>

=item * C<googleapis/google/dataflow/v1beta3/metrics.proto>

=item * C<googleapis/google/dataflow/v1beta3/jobs.proto>

=item * C<googleapis/google/dataflow/v1beta3/snapshots.proto>

=item * C<googleapis/google/dataflow/v1beta3/streaming.proto>



=back

=head1 CONSTRUCTOR

=head2 new

    my $client = Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client->new(
        credentials => $auth,   # Optional: Google::Auth object (defaults to ADC)
        transport   => 'grpc', # Optional: 'grpc' (default) or 'rest'
    );

=head1 ATTRIBUTES

=head2 credentials

Returns or accepts the L<Google::Auth> credentials object.

=head2 transport

Returns or accepts the active transport object (L<Google::gRPC::Client> or L<Google::Cloud::REST::Client>).

=head1 METHODS

=head2 METHODS

The following RPC methods are available in this client:

=over 4

=item * B<create_job_from_template>

Calls the RPC method C<CreateJobFromTemplate> on the service. Takes a hash of parameters representing the request.

=item * B<launch_template>

Calls the RPC method C<LaunchTemplate> on the service. Takes a hash of parameters representing the request.

=item * B<get_template>

Calls the RPC method C<GetTemplate> on the service. Takes a hash of parameters representing the request.

=item * B<launch_flex_template>

Calls the RPC method C<LaunchFlexTemplate> on the service. Takes a hash of parameters representing the request.

=item * B<list_job_messages>

Calls the RPC method C<ListJobMessages> on the service. Takes a hash of parameters representing the request.

=item * B<get_job_metrics>

Calls the RPC method C<GetJobMetrics> on the service. Takes a hash of parameters representing the request.

=item * B<get_job_execution_details>

Calls the RPC method C<GetJobExecutionDetails> on the service. Takes a hash of parameters representing the request.

=item * B<get_stage_execution_details>

Calls the RPC method C<GetStageExecutionDetails> on the service. Takes a hash of parameters representing the request.

=item * B<create_job>

Calls the RPC method C<CreateJob> on the service. Takes a hash of parameters representing the request.

=item * B<get_job>

Calls the RPC method C<GetJob> on the service. Takes a hash of parameters representing the request.

=item * B<update_job>

Calls the RPC method C<UpdateJob> on the service. Takes a hash of parameters representing the request.

=item * B<list_jobs>

Calls the RPC method C<ListJobs> on the service. Takes a hash of parameters representing the request.

=item * B<aggregated_list_jobs>

Calls the RPC method C<AggregatedListJobs> on the service. Takes a hash of parameters representing the request.

=item * B<check_active_jobs>

Calls the RPC method C<CheckActiveJobs> on the service. Takes a hash of parameters representing the request.

=item * B<snapshot_job>

Calls the RPC method C<SnapshotJob> on the service. Takes a hash of parameters representing the request.

=item * B<get_snapshot>

Calls the RPC method C<GetSnapshot> on the service. Takes a hash of parameters representing the request.

=item * B<delete_snapshot>

Calls the RPC method C<DeleteSnapshot> on the service. Takes a hash of parameters representing the request.

=item * B<list_snapshots>

Calls the RPC method C<ListSnapshots> on the service. Takes a hash of parameters representing the request.

=back



=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

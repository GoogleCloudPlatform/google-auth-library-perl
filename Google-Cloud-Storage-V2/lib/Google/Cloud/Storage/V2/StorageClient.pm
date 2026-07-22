package Google::Cloud::Storage::V2::StorageClient;

use strict;
use warnings;
use Moo;
use Google::gRPC::Client;
use Google::Cloud::REST::Client;
use Google::Auth;
use Carp qw(croak);

use Protobuf;
use Google::Api::Common;
use Google::Storage::V2::Storage;

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

sub delete_bucket {
    my ($self, %params) = @_;

    my $request_class = 'Google::Storage::V2::Storage::DeleteBucketRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Protobuf::Empty::Empty';
    my $response = $self->transport->call({
        service        => 'google.storage.v2.Storage',
        method         => 'DeleteBucket',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get_bucket {
    my ($self, %params) = @_;

    my $request_class = 'Google::Storage::V2::Storage::GetBucketRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Storage::V2::Storage::Bucket';
    my $response = $self->transport->call({
        service        => 'google.storage.v2.Storage',
        method         => 'GetBucket',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub create_bucket {
    my ($self, %params) = @_;

    my $request_class = 'Google::Storage::V2::Storage::CreateBucketRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Storage::V2::Storage::Bucket';
    my $response = $self->transport->call({
        service        => 'google.storage.v2.Storage',
        method         => 'CreateBucket',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub list_buckets {
    my ($self, %params) = @_;

    my $request_class = 'Google::Storage::V2::Storage::ListBucketsRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Storage::V2::Storage::ListBucketsResponse';
    my $response = $self->transport->call({
        service        => 'google.storage.v2.Storage',
        method         => 'ListBuckets',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub lock_bucket_retention_policy {
    my ($self, %params) = @_;

    my $request_class = 'Google::Storage::V2::Storage::LockBucketRetentionPolicyRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Storage::V2::Storage::Bucket';
    my $response = $self->transport->call({
        service        => 'google.storage.v2.Storage',
        method         => 'LockBucketRetentionPolicy',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub get_iam_policy {
    my ($self, %params) = @_;

    my $request_class = 'Google::Iam::V1::GetIamPolicyRequest::GetIamPolicyRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Iam::V1::Policy::Policy';
    my $response = $self->transport->call({
        service        => 'google.storage.v2.Storage',
        method         => 'GetIamPolicy',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}

sub move_object {
    my ($self, %params) = @_;

    my $request_class = 'Google::Storage::V2::Storage::MoveObjectRequest';
    my $request = eval { $request_class->new(\%params) } || eval { $request_class->new(%params) } || ($request_class->can('encode') ? $request_class->encode(\%params) : \%params);

    my $response_class = 'Google::Storage::V2::Storage::Object';
    my $response = $self->transport->call({
        service        => 'google.storage.v2.Storage',
        method         => 'MoveObject',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}
1; # End of Google::Cloud::Storage::V2::StorageClient

__END__

=head1 NAME

Google::Cloud::Storage::V2::StorageClient - Auto-generated client library for Google Cloud Services

=head1 SYNOPSIS

    use Google::Cloud::Storage::V2::StorageClient;
    use Google::Auth;

    # Initialize Application Default Credentials (ADC) or explicit Google Auth
    my $auth = Google::Auth->default();
    my $client = Google::Cloud::Storage::V2::StorageClient->new( credentials => $auth );

    # Execute service methods
    my $res = $client->some_method( %params );

=head1 DESCRIPTION

This is an auto-generated Protocol Buffers client library for Google Cloud Services, built on top of high-performance gRPC and Protocol Buffers!

It provides seamless integration with Google Cloud Application Default Credentials (ADC), support for both HTTP/2 gRPC and REST transports, and fully typed RPC method dispatching.

=head1 CONSTRUCTOR

=head2 new

    my $client = Google::Cloud::Storage::V2::StorageClient->new(
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

=item * B<delete_bucket>

Calls the RPC method C<DeleteBucket> on the service. Takes a hash of parameters representing the request.

=item * B<get_bucket>

Calls the RPC method C<GetBucket> on the service. Takes a hash of parameters representing the request.

=item * B<create_bucket>

Calls the RPC method C<CreateBucket> on the service. Takes a hash of parameters representing the request.

=item * B<list_buckets>

Calls the RPC method C<ListBuckets> on the service. Takes a hash of parameters representing the request.

=item * B<lock_bucket_retention_policy>

Calls the RPC method C<LockBucketRetentionPolicy> on the service. Takes a hash of parameters representing the request.

=item * B<get_iam_policy>

Calls the RPC method C<GetIamPolicy> on the service. Takes a hash of parameters representing the request.

=item * B<move_object>

Calls the RPC method C<MoveObject> on the service. Takes a hash of parameters representing the request.

=back



=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

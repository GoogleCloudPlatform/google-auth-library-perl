package Google::Cloud::Sql::V1::CloudSqlOperations;

use strict;
use warnings;

our $VERSION = '0.10';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    eval { require Google::Api::Annotations };
    eval { require Google::Api::Client };
    eval { require Google::Api::FieldBehavior };
    eval { require Google::Cloud::Sql::V1::CloudSqlResources };
    eval { require Google::Protobuf::Empty };
    my $descriptor_b64 = <<'EOF';
Ci5nb29nbGUvY2xvdWQvc3FsL3YxL2Nsb3VkX3NxbF9vcGVyYXRpb25zLnByb3RvEhNnb29n
bGUuY2xvdWQuc3FsLnYxGhxnb29nbGUvYXBpL2Fubm90YXRpb25zLnByb3RvGhdnb29nbGUv
YXBpL2NsaWVudC5wcm90bxofZ29vZ2xlL2FwaS9maWVsZF9iZWhhdmlvci5wcm90bxotZ29v
Z2xlL2Nsb3VkL3NxbC92MS9jbG91ZF9zcWxfcmVzb3VyY2VzLnByb3RvGhtnb29nbGUvcHJv
dG9idWYvZW1wdHkucHJvdG8iWwoXU3FsT3BlcmF0aW9uc0dldFJlcXVlc3QSIQoJb3BlcmF0
aW9uGAEgASgJQgPgQQJSCW9wZXJhdGlvbhIdCgdwcm9qZWN0GAIgASgJQgPgQQJSB3Byb2pl
Y3QikAEKGFNxbE9wZXJhdGlvbnNMaXN0UmVxdWVzdBIaCghpbnN0YW5jZRgBIAEoCVIIaW5z
dGFuY2USHwoLbWF4X3Jlc3VsdHMYAiABKA1SCm1heFJlc3VsdHMSHQoKcGFnZV90b2tlbhgD
IAEoCVIJcGFnZVRva2VuEhgKB3Byb2plY3QYBCABKAlSB3Byb2plY3QiigEKFk9wZXJhdGlv
bnNMaXN0UmVzcG9uc2USEgoEa2luZBgBIAEoCVIEa2luZBI0CgVpdGVtcxgCIAMoCzIeLmdv
b2dsZS5jbG91ZC5zcWwudjEuT3BlcmF0aW9uUgVpdGVtcxImCg9uZXh0X3BhZ2VfdG9rZW4Y
AyABKAlSDW5leHRQYWdlVG9rZW4iVAoaU3FsT3BlcmF0aW9uc0NhbmNlbFJlcXVlc3QSHAoJ
b3BlcmF0aW9uGAEgASgJUglvcGVyYXRpb24SGAoHcHJvamVjdBgCIAEoCVIHcHJvamVjdDLD
BAoUU3FsT3BlcmF0aW9uc1NlcnZpY2USigEKA0dldBIsLmdvb2dsZS5jbG91ZC5zcWwudjEu
U3FsT3BlcmF0aW9uc0dldFJlcXVlc3QaHi5nb29nbGUuY2xvdWQuc3FsLnYxLk9wZXJhdGlv
biI1gtPkkwIvEi0vdjEvcHJvamVjdHMve3Byb2plY3R9L29wZXJhdGlvbnMve29wZXJhdGlv
bn0SjQEKBExpc3QSLS5nb29nbGUuY2xvdWQuc3FsLnYxLlNxbE9wZXJhdGlvbnNMaXN0UmVx
dWVzdBorLmdvb2dsZS5jbG91ZC5zcWwudjEuT3BlcmF0aW9uc0xpc3RSZXNwb25zZSIpgtPk
kwIjEiEvdjEvcHJvamVjdHMve3Byb2plY3R9L29wZXJhdGlvbnMSjwEKBkNhbmNlbBIvLmdv
b2dsZS5jbG91ZC5zcWwudjEuU3FsT3BlcmF0aW9uc0NhbmNlbFJlcXVlc3QaFi5nb29nbGUu
cHJvdG9idWYuRW1wdHkiPILT5JMCNiI0L3YxL3Byb2plY3RzL3twcm9qZWN0fS9vcGVyYXRp
b25zL3tvcGVyYXRpb259L2NhbmNlbBp8ykEXc3FsYWRtaW4uZ29vZ2xlYXBpcy5jb23SQV9o
dHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9hdXRoL2Nsb3VkLXBsYXRmb3JtLGh0dHBzOi8v
d3d3Lmdvb2dsZWFwaXMuY29tL2F1dGgvc3Fsc2VydmljZS5hZG1pbkJfChdjb20uZ29vZ2xl
LmNsb3VkLnNxbC52MUIXQ2xvdWRTcWxPcGVyYXRpb25zUHJvdG9QAVopY2xvdWQuZ29vZ2xl
LmNvbS9nby9zcWwvYXBpdjEvc3FscGI7c3FscGJKrBcKBhIEDgBoAQq8BAoBDBIDDgASMrEE
IENvcHlyaWdodCAyMDI2IEdvb2dsZSBMTEMKCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hl
IExpY2Vuc2UsIFZlcnNpb24gMi4wICh0aGUgIkxpY2Vuc2UiKTsKIHlvdSBtYXkgbm90IHVz
ZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS4KIFlv
dSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUgTGljZW5zZSBhdAoKICAgICBodHRwOi8vd3d3
LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAKCiBVbmxlc3MgcmVxdWlyZWQgYnkg
YXBwbGljYWJsZSBsYXcgb3IgYWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlCiBkaXN0
cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiAiQVMgSVMi
IEJBU0lTLAogV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQs
IGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuCiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBz
cGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kCiBsaW1pdGF0aW9u
cyB1bmRlciB0aGUgTGljZW5zZS4KCggKAQISAxAAHAoJCgIDABIDEgAmCgkKAgMBEgMTACEK
CQoCAwISAxQAKQoJCgIDAxIDFQA3CgkKAgMEEgMWACUKCAoBCBIDGABACgkKAggLEgMYAEAK
CAoBCBIDGQAiCgkKAggKEgMZACIKCAoBCBIDGgA4CgkKAggIEgMaADgKCAoBCBIDGwAwCgkK
AggBEgMbADAKQQoCBgASBB4AOQEaNSBTZXJ2aWNlIHRvIGZldGNoIG9wZXJhdGlvbnMgZm9y
IGRhdGFiYXNlIGluc3RhbmNlcy4KCgoKAwYAARIDHggcCgoKAwYAAxIDHwI/CgwKBQYAA5kI
EgMfAj8KCwoDBgADEgQgAiI5Cg0KBQYAA5oIEgQgAiI5ClcKBAYAAgASBCUCKQMaSSBSZXRy
aWV2ZXMgYW4gaW5zdGFuY2Ugb3BlcmF0aW9uIHRoYXQgaGFzIGJlZW4gcGVyZm9ybWVkIG9u
IGFuIGluc3RhbmNlLgoKDAoFBgACAAESAyUGCQoMCgUGAAIAAhIDJQohCgwKBQYAAgADEgMl
LDUKDQoFBgACAAQSBCYEKAYKEQoJBgACAASwyrwiEgQmBCgGCp4BCgQGAAIBEgQtAjEDGo8B
IExpc3RzIGFsbCBpbnN0YW5jZSBvcGVyYXRpb25zIHRoYXQgaGF2ZSBiZWVuIHBlcmZvcm1l
ZCBvbiB0aGUgZ2l2ZW4gQ2xvdWQKIFNRTCBpbnN0YW5jZSBpbiB0aGUgcmV2ZXJzZSBjaHJv
bm9sb2dpY2FsIG9yZGVyIG9mIHRoZSBzdGFydCB0aW1lLgoKDAoFBgACAQESAy0GCgoMCgUG
AAIBAhIDLQsjCgwKBQYAAgEDEgMtLkQKDQoFBgACAQQSBC4EMAYKEQoJBgACAQSwyrwiEgQu
BDAGClUKBAYAAgISBDQCOAMaRyBDYW5jZWxzIGFuIGluc3RhbmNlIG9wZXJhdGlvbiB0aGF0
IGhhcyBiZWVuIHBlcmZvcm1lZCBvbiBhbiBpbnN0YW5jZS4KCgwKBQYAAgIBEgM0BgwKDAoF
BgACAgISAzQNJwoMCgUGAAICAxIDNDJHCg0KBQYAAgIEEgQ1BDcGChEKCQYAAgIEsMq8IhIE
NQQ3BgolCgIEABIEPABCARoZIE9wZXJhdGlvbnMgZ2V0IHJlcXVlc3QuCgoKCgMEAAESAzwI
HwovCgQEAAIAEgM+AkAaIiBSZXF1aXJlZC4gSW5zdGFuY2Ugb3BlcmF0aW9uIElELgoKDAoF
BAACAAUSAz4CCAoMCgUEAAIAARIDPgkSCgwKBQQAAgADEgM+FRYKDAoFBAACAAgSAz4XPwoP
CggEAAIACJwIABIDPhg+Ck4KBAQAAgESA0ECPhpBIFJlcXVpcmVkLiBQcm9qZWN0IElEIG9m
IHRoZSBwcm9qZWN0IHRoYXQgY29udGFpbnMgdGhlIGluc3RhbmNlLgoKDAoFBAACAQUSA0EC
CAoMCgUEAAIBARIDQQkQCgwKBQQAAgEDEgNBExQKDAoFBAACAQgSA0EVPQoPCggEAAIBCJwI
ABIDQRY8CiYKAgQBEgRFAFIBGhogT3BlcmF0aW9ucyBsaXN0IHJlcXVlc3QuCgoKCgMEAQES
A0UIIApLCgQEAQIAEgNHAhYaPiBDbG91ZCBTUUwgaW5zdGFuY2UgSUQuIFRoaXMgZG9lcyBu
b3QgaW5jbHVkZSB0aGUgcHJvamVjdCBJRC4KCgwKBQQBAgAFEgNHAggKDAoFBAECAAESA0cJ
EQoMCgUEAQIAAxIDRxQVCjkKBAQBAgESA0oCGRosIE1heGltdW0gbnVtYmVyIG9mIG9wZXJh
dGlvbnMgcGVyIHJlc3BvbnNlLgoKDAoFBAECAQUSA0oCCAoMCgUEAQIBARIDSgkUCgwKBQQB
AgEDEgNKFxgKaAoEBAECAhIDTgIYGlsgQSBwcmV2aW91c2x5LXJldHVybmVkIHBhZ2UgdG9r
ZW4gcmVwcmVzZW50aW5nIHBhcnQgb2YgdGhlIGxhcmdlciBzZXQgb2YKIHJlc3VsdHMgdG8g
dmlldy4KCgwKBQQBAgIFEgNOAggKDAoFBAECAgESA04JEwoMCgUEAQICAxIDThYXCkQKBAQB
AgMSA1ECFRo3IFByb2plY3QgSUQgb2YgdGhlIHByb2plY3QgdGhhdCBjb250YWlucyB0aGUg
aW5zdGFuY2UuCgoMCgUEAQIDBRIDUQIICgwKBQQBAgMBEgNRCRAKDAoFBAECAwMSA1ETFAon
CgIEAhIEVQBfARobIE9wZXJhdGlvbnMgbGlzdCByZXNwb25zZS4KCgoKAwQCARIDVQgeCjMK
BAQCAgASA1cCEhomIFRoaXMgaXMgYWx3YXlzIGBzcWwjb3BlcmF0aW9uc0xpc3RgLgoKDAoF
BAICAAUSA1cCCAoMCgUEAgIAARIDVwkNCgwKBQQCAgADEgNXEBEKKwoEBAICARIDWgIfGh4g
TGlzdCBvZiBvcGVyYXRpb24gcmVzb3VyY2VzLgoKDAoFBAICAQQSA1oCCgoMCgUEAgIBBhID
WgsUCgwKBQQCAgEBEgNaFRoKDAoFBAICAQMSA1odHgqfAQoEBAICAhIDXgIdGpEBIFRoZSBj
b250aW51YXRpb24gdG9rZW4sIHVzZWQgdG8gcGFnZSB0aHJvdWdoIGxhcmdlIHJlc3VsdCBz
ZXRzLiBQcm92aWRlCiB0aGlzIHZhbHVlIGluIGEgc3Vic2VxdWVudCByZXF1ZXN0IHRvIHJl
dHVybiB0aGUgbmV4dCBwYWdlIG9mIHJlc3VsdHMuCgoMCgUEAgICBRIDXgIICgwKBQQCAgIB
EgNeCRgKDAoFBAICAgMSA14bHAooCgIEAxIEYgBoARocIE9wZXJhdGlvbnMgY2FuY2VsIHJl
cXVlc3QuCgoKCgMEAwESA2IIIgolCgQEAwIAEgNkAhcaGCBJbnN0YW5jZSBvcGVyYXRpb24g
SUQuCgoMCgUEAwIABRIDZAIICgwKBQQDAgABEgNkCRIKDAoFBAMCAAMSA2QVFgpECgQEAwIB
EgNnAhUaNyBQcm9qZWN0IElEIG9mIHRoZSBwcm9qZWN0IHRoYXQgY29udGFpbnMgdGhlIGlu
c3RhbmNlLgoKDAoFBAMCAQUSA2cCCAoMCgUEAwIBARIDZwkQCgwKBQQDAgEDEgNnExRiBnBy
b3RvMw==
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsGetRequest ===
    # Fields for SqlOperationsGetRequest
    # Field: operation Type: 9 ()
    # Field: project Type: 9 ()

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsGetRequest - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlOperations;

    my $msg = Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsGetRequest->new(
        operation => $value,
    );

=head1 FIELDS

=over 4

=item * B<operation>

Type: String

=item * B<project>

Type: String

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsListRequest ===
    # Fields for SqlOperationsListRequest
    # Field: instance Type: 9 ()
    # Field: max_results Type: 13 ()
    # Field: page_token Type: 9 ()
    # Field: project Type: 9 ()

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsListRequest - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlOperations;

    my $msg = Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsListRequest->new(
        instance => $value,
    );

=head1 FIELDS

=over 4

=item * B<instance>

Type: String

=item * B<max_results>

Type: UInt32

=item * B<page_token>

Type: String

=item * B<project>

Type: String

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlOperations::OperationsListResponse ===
    # Fields for OperationsListResponse
    # Field: kind Type: 9 ()
    # Field: items Type: 11 (.google.cloud.sql.v1.Operation)
    # Field: next_page_token Type: 9 ()

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlOperations::OperationsListResponse - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlOperations;

    my $msg = Google::Cloud::Sql::V1::CloudSqlOperations::OperationsListResponse->new(
        kind => $value,
    );

=head1 FIELDS

=over 4

=item * B<kind>

Type: String

=item * B<items>

Type: Message (.google.cloud.sql.v1.Operation)

=item * B<next_page_token>

Type: String

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsCancelRequest ===
    # Fields for SqlOperationsCancelRequest
    # Field: operation Type: 9 ()
    # Field: project Type: 9 ()

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsCancelRequest - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlOperations;

    my $msg = Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsCancelRequest->new(
        operation => $value,
    );

=head1 FIELDS

=over 4

=item * B<operation>

Type: String

=item * B<project>

Type: String

=back

=cut

# === Service Client: Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsServiceClient ===
package Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsServiceClient;

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsServiceClient - Client stub representing the remote SqlOperationsService service

=head1 DESCRIPTION

This class acts as a local client stub for the remote gRPC service.
It delegates call dispatching to an underlying L<Google::gRPC::Client>
instance, ensuring type-safe request parsing and response mapping.

=head1 CONFIGURATION AND ENVIRONMENT

=head2 target

The endpoint target address. Defaults to C<sql.googleapis.com:443>.

=head2 credentials

The authentication credentials provider. Defaults to application default credentials via L<Google::Auth>.

=cut

use Moo;
use Google::Auth;
use Google::gRPC::Client;

has credentials => ( is => 'ro', default => sub { Google::Auth->default() } );
has target      => ( is => 'ro', default => 'sql.googleapis.com:443' );

has _grpc_client => (
    is => 'ro',
    lazy => 1,
    builder => sub {
        my $self = shift;
        return Google::gRPC::Client->new(
            target     => $self->target,
            auth_token => $self->credentials->get_token(),
        );
    }
);

sub get {
    my ($self, $args) = @_;
    my $req = ref($args) eq 'HASH'
        ? Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsGetRequest->new($args)
        : $args;
    return $self->_grpc_client->call({
        service        => 'google.cloud.sql.v1.SqlOperationsService',
        method         => 'Get',
        request        => $req,
        response_class => 'Google::Cloud::Sql::V1::CloudSqlResources::Operation',
    });
}

sub list {
    my ($self, $args) = @_;
    my $req = ref($args) eq 'HASH'
        ? Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsListRequest->new($args)
        : $args;
    return $self->_grpc_client->call({
        service        => 'google.cloud.sql.v1.SqlOperationsService',
        method         => 'List',
        request        => $req,
        response_class => 'Google::Cloud::Sql::V1::CloudSqlOperations::OperationsListResponse',
    });
}

sub cancel {
    my ($self, $args) = @_;
    my $req = ref($args) eq 'HASH'
        ? Google::Cloud::Sql::V1::CloudSqlOperations::SqlOperationsCancelRequest->new($args)
        : $args;
    return $self->_grpc_client->call({
        service        => 'google.cloud.sql.v1.SqlOperationsService',
        method         => 'Cancel',
        request        => $req,
        response_class => 'Google::Protobuf::Empty::Empty',
    });
}

1;

__END__

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlOperations - Protocol Buffers schema definition

=head1 DESCRIPTION

Auto-generated Protocol Buffers schema definition class.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

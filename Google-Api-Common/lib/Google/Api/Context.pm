package Google::Api::Context;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Chhnb29nbGUvYXBpL2NvbnRleHQucHJvdG8SCmdvb2dsZS5hcGkiOAoHQ29udGV4dBItCgVy
dWxlcxgBIAMoCzIXLmdvb2dsZS5hcGkuQ29udGV4dFJ1bGVSBXJ1bGVzIuEBCgtDb250ZXh0
UnVsZRIaCghzZWxlY3RvchgBIAEoCVIIc2VsZWN0b3ISHAoJcmVxdWVzdGVkGAIgAygJUgly
ZXF1ZXN0ZWQSGgoIcHJvdmlkZWQYAyADKAlSCHByb3ZpZGVkEjwKGmFsbG93ZWRfcmVxdWVz
dF9leHRlbnNpb25zGAQgAygJUhhhbGxvd2VkUmVxdWVzdEV4dGVuc2lvbnMSPgobYWxsb3dl
ZF9yZXNwb25zZV9leHRlbnNpb25zGAUgAygJUhlhbGxvd2VkUmVzcG9uc2VFeHRlbnNpb25z
Qm4KDmNvbS5nb29nbGUuYXBpQgxDb250ZXh0UHJvdG9QAVpFZ29vZ2xlLmdvbGFuZy5vcmcv
Z2VucHJvdG8vZ29vZ2xlYXBpcy9hcGkvc2VydmljZWNvbmZpZztzZXJ2aWNlY29uZmlnogIE
R0FQSUqpGAoGEgQOAFsBCrwECgEMEgMOABIysQQgQ29weXJpZ2h0IDIwMjYgR29vZ2xlIExM
QwoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRo
ZSAiTGljZW5zZSIpOwogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29t
cGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLgogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRo
ZSBMaWNlbnNlIGF0CgogICAgIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNF
TlNFLTIuMAoKIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQg
dG8gaW4gd3JpdGluZywgc29mdHdhcmUKIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNl
IGlzIGRpc3RyaWJ1dGVkIG9uIGFuICJBUyBJUyIgQkFTSVMsCiBXSVRIT1VUIFdBUlJBTlRJ
RVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGll
ZC4KIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmlu
ZyBwZXJtaXNzaW9ucyBhbmQKIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLgoKCAoB
AhIDEAATCggKAQgSAxIAXAoJCgIICxIDEgBcCggKAQgSAxMAIgoJCgIIChIDEwAiCggKAQgS
AxQALQoJCgIICBIDFAAtCggKAQgSAxUAJwoJCgIIARIDFQAnCggKAQgSAxYAIgoJCgIIJBID
FgAiCt8ICgIEABIEPABBARrSCCBgQ29udGV4dGAgZGVmaW5lcyB3aGljaCBjb250ZXh0cyBh
biBBUEkgcmVxdWVzdHMuCgogRXhhbXBsZToKCiAgICAgY29udGV4dDoKICAgICAgIHJ1bGVz
OgogICAgICAgLSBzZWxlY3RvcjogIioiCiAgICAgICAgIHJlcXVlc3RlZDoKICAgICAgICAg
LSBnb29nbGUucnBjLmNvbnRleHQuUHJvamVjdENvbnRleHQKICAgICAgICAgLSBnb29nbGUu
cnBjLmNvbnRleHQuT3JpZ2luQ29udGV4dAoKIFRoZSBhYm92ZSBzcGVjaWZpZXMgdGhhdCBh
bGwgbWV0aG9kcyBpbiB0aGUgQVBJIHJlcXVlc3QKIGBnb29nbGUucnBjLmNvbnRleHQuUHJv
amVjdENvbnRleHRgIGFuZAogYGdvb2dsZS5ycGMuY29udGV4dC5PcmlnaW5Db250ZXh0YC4K
CiBBdmFpbGFibGUgY29udGV4dCB0eXBlcyBhcmUgZGVmaW5lZCBpbiBwYWNrYWdlCiBgZ29v
Z2xlLnJwYy5jb250ZXh0YC4KCiBUaGlzIGFsc28gcHJvdmlkZXMgbWVjaGFuaXNtIHRvIGFs
bG93bGlzdCBhbnkgcHJvdG9idWYgbWVzc2FnZSBleHRlbnNpb24gdGhhdAogY2FuIGJlIHNl
bnQgaW4gZ3JwYyBtZXRhZGF0YSB1c2luZyDigJx4LWdvb2ctZXh0LTxleHRlbnNpb25faWQ+
LWJpbuKAnSBhbmQKIOKAnHgtZ29vZy1leHQtPGV4dGVuc2lvbl9pZD4tanNwYuKAnSBmb3Jt
YXQuIEZvciBleGFtcGxlLCBsaXN0IGFueSBzZXJ2aWNlCiBzcGVjaWZpYyBwcm90b2J1ZiB0
eXBlcyB0aGF0IGNhbiBhcHBlYXIgaW4gZ3JwYyBtZXRhZGF0YSBhcyBmb2xsb3dzIGluIHlv
dXIKIHlhbWwgZmlsZToKCiBFeGFtcGxlOgoKICAgICBjb250ZXh0OgogICAgICAgcnVsZXM6
CiAgICAgICAgLSBzZWxlY3RvcjogImdvb2dsZS5leGFtcGxlLmxpYnJhcnkudjEuTGlicmFy
eVNlcnZpY2UuQ3JlYXRlQm9vayIKICAgICAgICAgIGFsbG93ZWRfcmVxdWVzdF9leHRlbnNp
b25zOgogICAgICAgICAgLSBnb29nbGUuZm9vLnYxLk5ld0V4dGVuc2lvbgogICAgICAgICAg
YWxsb3dlZF9yZXNwb25zZV9leHRlbnNpb25zOgogICAgICAgICAgLSBnb29nbGUuZm9vLnYx
Lk5ld0V4dGVuc2lvbgoKIFlvdSBjYW4gYWxzbyBzcGVjaWZ5IGV4dGVuc2lvbiBJRCBpbnN0
ZWFkIG9mIGZ1bGx5IHF1YWxpZmllZCBleHRlbnNpb24gbmFtZQogaGVyZS4KCgoKAwQAARID
PAgPCpsBCgQEAAIAEgNAAiEajQEgQSBsaXN0IG9mIFJQQyBjb250ZXh0IHJ1bGVzIHRoYXQg
YXBwbHkgdG8gaW5kaXZpZHVhbCBBUEkgbWV0aG9kcy4KCiAqKk5PVEU6KiogQWxsIHNlcnZp
Y2UgY29uZmlndXJhdGlvbiBydWxlcyBmb2xsb3cgImxhc3Qgb25lIHdpbnMiIG9yZGVyLgoK
DAoFBAACAAQSA0ACCgoMCgUEAAIABhIDQAsWCgwKBQQAAgABEgNAFxwKDAoFBAACAAMSA0Af
IApjCgIEARIERQBbARpXIEEgY29udGV4dCBydWxlIHByb3ZpZGVzIGluZm9ybWF0aW9uIGFi
b3V0IHRoZSBjb250ZXh0IGZvciBhbiBpbmRpdmlkdWFsIEFQSQogZWxlbWVudC4KCgoKAwQB
ARIDRQgTCpEBCgQEAQIAEgNKAhYagwEgU2VsZWN0cyB0aGUgbWV0aG9kcyB0byB3aGljaCB0
aGlzIHJ1bGUgYXBwbGllcy4KCiBSZWZlciB0byBbc2VsZWN0b3JdW2dvb2dsZS5hcGkuRG9j
dW1lbnRhdGlvblJ1bGUuc2VsZWN0b3JdIGZvciBzeW50YXgKIGRldGFpbHMuCgoMCgUEAQIA
BRIDSgIICgwKBQQBAgABEgNKCREKDAoFBAECAAMSA0oUFQqCAQoEBAECARIDTgIgGnUgQSBs
aXN0IG9mIGZ1bGwgdHlwZSBuYW1lcyBvZiByZXF1ZXN0ZWQgY29udGV4dHMsIG9ubHkgdGhl
IHJlcXVlc3RlZCBjb250ZXh0CiB3aWxsIGJlIG1hZGUgYXZhaWxhYmxlIHRvIHRoZSBiYWNr
ZW5kLgoKDAoFBAECAQQSA04CCgoMCgUEAQIBBRIDTgsRCgwKBQQBAgEBEgNOEhsKDAoFBAEC
AQMSA04eHwqWAQoEBAECAhIDUgIfGogBIEEgbGlzdCBvZiBmdWxsIHR5cGUgbmFtZXMgb2Yg
cHJvdmlkZWQgY29udGV4dHMuIEl0IGlzIHVzZWQgdG8gc3VwcG9ydAogcHJvcGFnYXRpbmcg
SFRUUCBoZWFkZXJzIGFuZCBFVGFncyBmcm9tIHRoZSByZXNwb25zZSBleHRlbnNpb24uCgoM
CgUEAQICBBIDUgIKCgwKBQQBAgIFEgNSCxEKDAoFBAECAgESA1ISGgoMCgUEAQICAxIDUh0e
Cn0KBAQBAgMSA1YCMRpwIEEgbGlzdCBvZiBmdWxsIHR5cGUgbmFtZXMgb3IgZXh0ZW5zaW9u
IElEcyBvZiBleHRlbnNpb25zIGFsbG93ZWQgaW4gZ3JwYwogc2lkZSBjaGFubmVsIGZyb20g
Y2xpZW50IHRvIGJhY2tlbmQuCgoMCgUEAQIDBBIDVgIKCgwKBQQBAgMFEgNWCxEKDAoFBAEC
AwESA1YSLAoMCgUEAQIDAxIDVi8wCn0KBAQBAgQSA1oCMhpwIEEgbGlzdCBvZiBmdWxsIHR5
cGUgbmFtZXMgb3IgZXh0ZW5zaW9uIElEcyBvZiBleHRlbnNpb25zIGFsbG93ZWQgaW4gZ3Jw
Ywogc2lkZSBjaGFubmVsIGZyb20gYmFja2VuZCB0byBjbGllbnQuCgoMCgUEAQIEBBIDWgIK
CgwKBQQBAgQFEgNaCxEKDAoFBAECBAESA1oSLQoMCgUEAQIEAxIDWjAxYgZwcm90bzM=
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Context::Context ===
    # Fields for Context
    # Field: rules Type: 11 (.google.api.ContextRule)

# === Message: Google::Api::Context::ContextRule ===
    # Fields for ContextRule
    # Field: selector Type: 9 ()
    # Field: requested Type: 9 ()
    # Field: provided Type: 9 ()
    # Field: allowed_request_extensions Type: 9 ()
    # Field: allowed_response_extensions Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Context - Compiled Protocol Buffers messages for google/api/context.proto

=head1 SYNOPSIS

    use Google::Api::Context;

    my $msg = Google::Api::Context::Context->new({
        rules => $rules,
    });

    # Read or update a field
    my $val = $msg->rules();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Context::Context->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/context.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Context::Context

`Context` defines which contexts an API requests.

Example:

    context:
      rules:
      - selector: "*"
        requested:
        - google.rpc.context.ProjectContext
        - google.rpc.context.OriginContext

The above specifies that all methods in the API request
`google.rpc.context.ProjectContext` and
`google.rpc.context.OriginContext`.

Available context types are defined in package
`google.rpc.context`.

This also provides mechanism to allowlist any protobuf message extension that
can be sent in grpc metadata using “x-goog-ext-<extension_id>-bin” and
“x-goog-ext-<extension_id>-jspb” format. For example, list any service
specific protobuf types that can appear in grpc metadata as follows in your
yaml file:

Example:

    context:
      rules:
       - selector: "google.example.library.v1.LibraryService.CreateBook"
         allowed_request_extensions:
         - google.foo.v1.NewExtension
         allowed_response_extensions:
         - google.foo.v1.NewExtension

You can also specify extension ID instead of fully qualified extension name
here.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->rules() >> / C<< $msg->rules($value) >>

Type: C<Message> (L<Google::Api::Context::ContextRule>)

A list of RPC context rules that apply to individual API methods.

B<NOTE:> All service configuration rules follow "last one wins" order.

=back

=head2 Google::Api::Context::ContextRule

A context rule provides information about the context for an individual API
element.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->selector() >> / C<< $msg->selector($value) >>

Type: C<String>

Selects the methods to which this rule applies.

Refer to [selector][google.api.DocumentationRule.selector] for syntax
details.

=item * C<< $msg->requested() >> / C<< $msg->requested($value) >>

Type: C<String>

A list of full type names of requested contexts, only the requested context
will be made available to the backend.

=item * C<< $msg->provided() >> / C<< $msg->provided($value) >>

Type: C<String>

A list of full type names of provided contexts. It is used to support
propagating HTTP headers and ETags from the response extension.

=item * C<< $msg->allowed_request_extensions() >> / C<< $msg->allowed_request_extensions($value) >>

Type: C<String>

A list of full type names or extension IDs of extensions allowed in grpc
side channel from client to backend.

=item * C<< $msg->allowed_response_extensions() >> / C<< $msg->allowed_response_extensions($value) >>

Type: C<String>

A list of full type names or extension IDs of extensions allowed in grpc
side channel from backend to client.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Context::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

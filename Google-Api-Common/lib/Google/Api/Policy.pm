package Google::Api::Policy;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    eval { require Google::Protobuf::Descriptor };
    my $descriptor_b64 = <<'EOF';
Chdnb29nbGUvYXBpL3BvbGljeS5wcm90bxIKZ29vZ2xlLmFwaRogZ29vZ2xlL3Byb3RvYnVm
L2Rlc2NyaXB0b3IucHJvdG8ifwoLRmllbGRQb2xpY3kSGgoIc2VsZWN0b3IYASABKAlSCHNl
bGVjdG9yEi8KE3Jlc291cmNlX3Blcm1pc3Npb24YAiABKAlSEnJlc291cmNlUGVybWlzc2lv
bhIjCg1yZXNvdXJjZV90eXBlGAMgASgJUgxyZXNvdXJjZVR5cGUibgoMTWV0aG9kUG9saWN5
EhoKCHNlbGVjdG9yGAkgASgJUghzZWxlY3RvchJCChByZXF1ZXN0X3BvbGljaWVzGAIgAygL
MhcuZ29vZ2xlLmFwaS5GaWVsZFBvbGljeVIPcmVxdWVzdFBvbGljaWVzOlwKDGZpZWxkX3Bv
bGljeRIdLmdvb2dsZS5wcm90b2J1Zi5GaWVsZE9wdGlvbnMY6M7BSyABKAsyFy5nb29nbGUu
YXBpLkZpZWxkUG9saWN5UgtmaWVsZFBvbGljeTpgCg1tZXRob2RfcG9saWN5Eh4uZ29vZ2xl
LnByb3RvYnVmLk1ldGhvZE9wdGlvbnMYtZeZTSABKAsyGC5nb29nbGUuYXBpLk1ldGhvZFBv
bGljeVIMbWV0aG9kUG9saWN5Qm0KDmNvbS5nb29nbGUuYXBpQgtQb2xpY3lQcm90b1ABWkVn
b29nbGUuZ29sYW5nLm9yZy9nZW5wcm90by9nb29nbGVhcGlzL2FwaS9zZXJ2aWNlY29uZmln
O3NlcnZpY2Vjb25maWeiAgRHQVBJSsUWCgYSBA4AUQEKvAQKAQwSAw4AEjKxBCBDb3B5cmln
aHQgMjAyNiBHb29nbGUgTExDCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNl
LCBWZXJzaW9uIDIuMCAodGhlICJMaWNlbnNlIik7CiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBm
aWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuCiBZb3UgbWF5IG9i
dGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2UgYXQKCiAgICAgaHR0cDovL3d3dy5hcGFjaGUu
b3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wCgogVW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2Fi
bGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZQogZGlzdHJpYnV0ZWQg
dW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywK
IFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIg
ZXhwcmVzcyBvciBpbXBsaWVkLgogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMg
bGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZAogbGltaXRhdGlvbnMgdW5kZXIg
dGhlIExpY2Vuc2UuCgoICgECEgMQABMKCQoCAwASAxIAKgoICgEIEgMUAFwKCQoCCAsSAxQA
XAoICgEIEgMVACIKCQoCCAoSAxUAIgoICgEIEgMWACwKCQoCCAgSAxYALAoICgEIEgMXACcK
CQoCCAESAxcAJwoICgEIEgMYACIKCQoCCCQSAxgAIgoJCgEHEgQaAB0BCiEKAgcAEgMcAjIa
FiBTZWUgW0ZpZWxkUG9saWN5XVtdLgoKCgoDBwACEgMaByMKCgoDBwAGEgMcAhgKCgoDBwAB
EgMcGSUKCgoDBwADEgMcKDEKCQoBBxIEHwAiAQoiCgIHARIDIQI0GhcgU2VlIFtNZXRob2RQ
b2xpY3ldW10uCgoKCgMHAQISAx8HJAoKCgMHAQYSAyECGQoKCgMHAQESAyEaJwoKCgMHAQMS
AyEqMwrKAwoCBAASBCwAQQEavQMgR29vZ2xlIEFQSSBQb2xpY3kgQW5ub3RhdGlvbgoKIFRo
aXMgbWVzc2FnZSBkZWZpbmVzIGEgc2ltcGxlIEFQSSBwb2xpY3kgYW5ub3RhdGlvbiB0aGF0
IGNhbiBiZSB1c2VkIHRvCiBhbm5vdGF0ZSBBUEkgcmVxdWVzdCBhbmQgcmVzcG9uc2UgbWVz
c2FnZSBmaWVsZHMgd2l0aCBhcHBsaWNhYmxlIHBvbGljaWVzLgogT25lIGZpZWxkIG1heSBo
YXZlIG11bHRpcGxlIGFwcGxpY2FibGUgcG9saWNpZXMgdGhhdCBtdXN0IGFsbCBiZSBzYXRp
c2ZpZWQKIGJlZm9yZSBhIHJlcXVlc3QgY2FuIGJlIHByb2Nlc3NlZC4gVGhpcyBwb2xpY3kg
YW5ub3RhdGlvbiBpcyB1c2VkIHRvCiBnZW5lcmF0ZSB0aGUgb3ZlcmFsbCBwb2xpY3kgdGhh
dCB3aWxsIGJlIHVzZWQgZm9yIGF1dG9tYXRpYyBydW50aW1lCiBwb2xpY3kgZW5mb3JjZW1l
bnQgYW5kIGRvY3VtZW50YXRpb24gZ2VuZXJhdGlvbi4KCgoKAwQAARIDLAgTCrwDCgQEAAIA
EgM3AhYargMgU2VsZWN0cyBvbmUgb3IgbW9yZSByZXF1ZXN0IG9yIHJlc3BvbnNlIG1lc3Nh
Z2UgZmllbGRzIHRvIGFwcGx5IHRoaXMKIGBGaWVsZFBvbGljeWAuCgogV2hlbiBhIGBGaWVs
ZFBvbGljeWAgaXMgdXNlZCBpbiBwcm90byBhbm5vdGF0aW9uLCB0aGUgc2VsZWN0b3IgbXVz
dAogYmUgbGVmdCBhcyBlbXB0eS4gVGhlIHNlcnZpY2UgY29uZmlnIGdlbmVyYXRvciB3aWxs
IGF1dG9tYXRpY2FsbHkgZmlsbAogdGhlIGNvcnJlY3QgdmFsdWUuCgogV2hlbiBhIGBGaWVs
ZFBvbGljeWAgaXMgdXNlZCBpbiBzZXJ2aWNlIGNvbmZpZywgdGhlIHNlbGVjdG9yIG11c3Qg
YmUgYQogY29tbWEtc2VwYXJhdGVkIHN0cmluZyB3aXRoIHZhbGlkIHJlcXVlc3Qgb3IgcmVz
cG9uc2UgZmllbGQgcGF0aHMsCiBzdWNoIGFzICJmb28uYmFyIiBvciAiZm9vLmJhcixmb28u
YmF6Ii4KCgwKBQQAAgAFEgM3AggKDAoFBAACAAESAzcJEQoMCgUEAAIAAxIDNxQVCoYCCgQE
AAIBEgM9AiEa+AEgU3BlY2lmaWVzIHRoZSByZXF1aXJlZCBwZXJtaXNzaW9uKHMpIGZvciB0
aGUgcmVzb3VyY2UgcmVmZXJyZWQgdG8gYnkgdGhlCiBmaWVsZC4gSXQgcmVxdWlyZXMgdGhl
IGZpZWxkIGNvbnRhaW5zIGEgdmFsaWQgcmVzb3VyY2UgcmVmZXJlbmNlLCBhbmQKIHRoZSBy
ZXF1ZXN0IG11c3QgcGFzcyB0aGUgcGVybWlzc2lvbiBjaGVja3MgdG8gcHJvY2VlZC4gRm9y
IGV4YW1wbGUsCiAicmVzb3VyY2VtYW5hZ2VyLnByb2plY3RzLmdldCIuCgoMCgUEAAIBBRID
PQIICgwKBQQAAgEBEgM9CRwKDAoFBAACAQMSAz0fIApVCgQEAAICEgNAAhsaSCBTcGVjaWZp
ZXMgdGhlIHJlc291cmNlIHR5cGUgZm9yIHRoZSByZXNvdXJjZSByZWZlcnJlZCB0byBieSB0
aGUgZmllbGQuCgoMCgUEAAICBRIDQAIICgwKBQQAAgIBEgNACRYKDAoFBAACAgMSA0AZGgo5
CgIEARIERABRARotIERlZmluZXMgcG9saWNpZXMgYXBwbHlpbmcgdG8gYW4gUlBDIG1ldGhv
ZC4KCgoKAwQBARIDRAgUCtwCCgQEAQIAEgNNAhYazgIgU2VsZWN0cyBhIG1ldGhvZCB0byB3
aGljaCB0aGVzZSBwb2xpY2llcyBzaG91bGQgYmUgZW5mb3JjZWQsIGZvciBleGFtcGxlLAog
Imdvb2dsZS5wdWJzdWIudjEuU3Vic2NyaWJlci5DcmVhdGVTdWJzY3JpcHRpb24iLgoKIFJl
ZmVyIHRvIFtzZWxlY3Rvcl1bZ29vZ2xlLmFwaS5Eb2N1bWVudGF0aW9uUnVsZS5zZWxlY3Rv
cl0gZm9yIHN5bnRheAogZGV0YWlscy4KCiBOT1RFOiBUaGlzIGZpZWxkIG11c3Qgbm90IGJl
IHNldCBpbiB0aGUgcHJvdG8gYW5ub3RhdGlvbi4gSXQgd2lsbCBiZQogYXV0b21hdGljYWxs
eSBmaWxsZWQgYnkgdGhlIHNlcnZpY2UgY29uZmlnIGNvbXBpbGVyIC4KCgwKBQQBAgAFEgNN
AggKDAoFBAECAAESA00JEQoMCgUEAQIAAxIDTRQVCkMKBAQBAgESA1ACLBo2IFBvbGljaWVz
IHRoYXQgYXJlIGFwcGxpY2FibGUgdG8gdGhlIHJlcXVlc3QgbWVzc2FnZS4KCgwKBQQBAgEE
EgNQAgoKDAoFBAECAQYSA1ALFgoMCgUEAQIBARIDUBcnCgwKBQQBAgEDEgNQKitiBnByb3Rv
Mw==
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Policy::FieldPolicy ===
    # Fields for FieldPolicy
    # Field: selector Type: 9 ()
    # Field: resource_permission Type: 9 ()
    # Field: resource_type Type: 9 ()

# === Message: Google::Api::Policy::MethodPolicy ===
    # Fields for MethodPolicy
    # Field: selector Type: 9 ()
    # Field: request_policies Type: 11 (.google.api.FieldPolicy)

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Policy - Compiled Protocol Buffers messages for google/api/policy.proto

=head1 SYNOPSIS

    use Google::Api::Policy;

    my $msg = Google::Api::Policy::FieldPolicy->new({
        selector => $selector,
        resource_permission => $resource_permission,
        resource_type => $resource_type,
    });

    # Read or update a field
    my $val = $msg->selector();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Policy::FieldPolicy->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/policy.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Policy::FieldPolicy

Google API Policy Annotation

This message defines a simple API policy annotation that can be used to
annotate API request and response message fields with applicable policies.
One field may have multiple applicable policies that must all be satisfied
before a request can be processed. This policy annotation is used to
generate the overall policy that will be used for automatic runtime
policy enforcement and documentation generation.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->selector() >> / C<< $msg->selector($value) >>

Type: C<String>

Selects one or more request or response message fields to apply this
`FieldPolicy`.

When a `FieldPolicy` is used in proto annotation, the selector must
be left as empty. The service config generator will automatically fill
the correct value.

When a `FieldPolicy` is used in service config, the selector must be a
comma-separated string with valid request or response field paths,
such as "foo.bar" or "foo.bar,foo.baz".

=item * C<< $msg->resource_permission() >> / C<< $msg->resource_permission($value) >>

Type: C<String>

Specifies the required permission(s) for the resource referred to by the
field. It requires the field contains a valid resource reference, and
the request must pass the permission checks to proceed. For example,
"resourcemanager.projects.get".

=item * C<< $msg->resource_type() >> / C<< $msg->resource_type($value) >>

Type: C<String>

Specifies the resource type for the resource referred to by the field.

=back

=head2 Google::Api::Policy::MethodPolicy

Defines policies applying to an RPC method.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->selector() >> / C<< $msg->selector($value) >>

Type: C<String>

Selects a method to which these policies should be enforced, for example,
"google.pubsub.v1.Subscriber.CreateSubscription".

Refer to [selector][google.api.DocumentationRule.selector] for syntax
details.

NOTE: This field must not be set in the proto annotation. It will be
automatically filled by the service config compiler .

=item * C<< $msg->request_policies() >> / C<< $msg->request_policies($value) >>

Type: C<Message> (L<Google::Api::Policy::FieldPolicy>)

Policies that are applicable to the request message.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Policy::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

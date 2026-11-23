package Google::Api::SystemParameter;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
CiFnb29nbGUvYXBpL3N5c3RlbV9wYXJhbWV0ZXIucHJvdG8SCmdvb2dsZS5hcGkiSQoQU3lz
dGVtUGFyYW1ldGVycxI1CgVydWxlcxgBIAMoCzIfLmdvb2dsZS5hcGkuU3lzdGVtUGFyYW1l
dGVyUnVsZVIFcnVsZXMibgoTU3lzdGVtUGFyYW1ldGVyUnVsZRIaCghzZWxlY3RvchgBIAEo
CVIIc2VsZWN0b3ISOwoKcGFyYW1ldGVycxgCIAMoCzIbLmdvb2dsZS5hcGkuU3lzdGVtUGFy
YW1ldGVyUgpwYXJhbWV0ZXJzInYKD1N5c3RlbVBhcmFtZXRlchISCgRuYW1lGAEgASgJUgRu
YW1lEh8KC2h0dHBfaGVhZGVyGAIgASgJUgpodHRwSGVhZGVyEi4KE3VybF9xdWVyeV9wYXJh
bWV0ZXIYAyABKAlSEXVybFF1ZXJ5UGFyYW1ldGVyQnYKDmNvbS5nb29nbGUuYXBpQhRTeXN0
ZW1QYXJhbWV0ZXJQcm90b1ABWkVnb29nbGUuZ29sYW5nLm9yZy9nZW5wcm90by9nb29nbGVh
cGlzL2FwaS9zZXJ2aWNlY29uZmlnO3NlcnZpY2Vjb25maWeiAgRHQVBJSsEZCgYSBA4AXwEK
vAQKAQwSAw4AEjKxBCBDb3B5cmlnaHQgMjAyNiBHb29nbGUgTExDCgogTGljZW5zZWQgdW5k
ZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlICJMaWNlbnNlIik7CiB5
b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhl
IExpY2Vuc2UuCiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2UgYXQKCiAg
ICAgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wCgogVW5sZXNz
IHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBz
b2Z0d2FyZQogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQg
b24gYW4gIkFTIElTIiBCQVNJUywKIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05T
IE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLgogU2VlIHRoZSBMaWNl
bnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFu
ZAogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuCgoICgECEgMQABMKCAoBCBIDEgBc
CgkKAggLEgMSAFwKCAoBCBIDEwAiCgkKAggKEgMTACIKCAoBCBIDFAA1CgkKAggIEgMUADUK
CAoBCBIDFQAnCgkKAggBEgMVACcKCAoBCBIDFgAiCgkKAggkEgMWACIKugIKAgQAEgQeAD0B
Gq0CICMjIyBTeXN0ZW0gcGFyYW1ldGVyIGNvbmZpZ3VyYXRpb24KCiBBIHN5c3RlbSBwYXJh
bWV0ZXIgaXMgYSBzcGVjaWFsIGtpbmQgb2YgcGFyYW1ldGVyIGRlZmluZWQgYnkgdGhlIEFQ
SQogc3lzdGVtLCBub3QgYnkgYW4gaW5kaXZpZHVhbCBBUEkuIEl0IGlzIHR5cGljYWxseSBt
YXBwZWQgdG8gYW4gSFRUUCBoZWFkZXIKIGFuZC9vciBhIFVSTCBxdWVyeSBwYXJhbWV0ZXIu
IFRoaXMgY29uZmlndXJhdGlvbiBzcGVjaWZpZXMgd2hpY2ggbWV0aG9kcwogY2hhbmdlIHRo
ZSBuYW1lcyBvZiB0aGUgc3lzdGVtIHBhcmFtZXRlcnMuCgoKCgMEAAESAx4IGArXBgoEBAAC
ABIDPAIpGskGIERlZmluZSBzeXN0ZW0gcGFyYW1ldGVycy4KCiBUaGUgcGFyYW1ldGVycyBk
ZWZpbmVkIGhlcmUgd2lsbCBvdmVycmlkZSB0aGUgZGVmYXVsdCBwYXJhbWV0ZXJzCiBpbXBs
ZW1lbnRlZCBieSB0aGUgc3lzdGVtLiBJZiB0aGlzIGZpZWxkIGlzIG1pc3NpbmcgZnJvbSB0
aGUgc2VydmljZQogY29uZmlnLCBkZWZhdWx0IHN5c3RlbSBwYXJhbWV0ZXJzIHdpbGwgYmUg
dXNlZC4gRGVmYXVsdCBzeXN0ZW0gcGFyYW1ldGVycwogYW5kIG5hbWVzIGlzIGltcGxlbWVu
dGF0aW9uLWRlcGVuZGVudC4KCiBFeGFtcGxlOiBkZWZpbmUgYXBpIGtleSBmb3IgYWxsIG1l
dGhvZHMKCiAgICAgc3lzdGVtX3BhcmFtZXRlcnMKICAgICAgIHJ1bGVzOgogICAgICAgICAt
IHNlbGVjdG9yOiAiKiIKICAgICAgICAgICBwYXJhbWV0ZXJzOgogICAgICAgICAgICAgLSBu
YW1lOiBhcGlfa2V5CiAgICAgICAgICAgICAgIHVybF9xdWVyeV9wYXJhbWV0ZXI6IGFwaV9r
ZXkKCgogRXhhbXBsZTogZGVmaW5lIDIgYXBpIGtleSBuYW1lcyBmb3IgYSBzcGVjaWZpYyBt
ZXRob2QuCgogICAgIHN5c3RlbV9wYXJhbWV0ZXJzCiAgICAgICBydWxlczoKICAgICAgICAg
LSBzZWxlY3RvcjogIi9MaXN0U2hlbHZlcyIKICAgICAgICAgICBwYXJhbWV0ZXJzOgogICAg
ICAgICAgICAgLSBuYW1lOiBhcGlfa2V5CiAgICAgICAgICAgICAgIGh0dHBfaGVhZGVyOiBB
cGktS2V5MQogICAgICAgICAgICAgLSBuYW1lOiBhcGlfa2V5CiAgICAgICAgICAgICAgIGh0
dHBfaGVhZGVyOiBBcGktS2V5MgoKICoqTk9URToqKiBBbGwgc2VydmljZSBjb25maWd1cmF0
aW9uIHJ1bGVzIGZvbGxvdyAibGFzdCBvbmUgd2lucyIgb3JkZXIuCgoMCgUEAAIABBIDPAIK
CgwKBQQAAgAGEgM8Cx4KDAoFBAACAAESAzwfJAoMCgUEAAIAAxIDPCcoCl4KAgQBEgRBAE8B
GlIgRGVmaW5lIGEgc3lzdGVtIHBhcmFtZXRlciBydWxlIG1hcHBpbmcgc3lzdGVtIHBhcmFt
ZXRlciBkZWZpbml0aW9ucyB0bwogbWV0aG9kcy4KCgoKAwQBARIDQQgbCr8BCgQEAQIAEgNH
AhYasQEgU2VsZWN0cyB0aGUgbWV0aG9kcyB0byB3aGljaCB0aGlzIHJ1bGUgYXBwbGllcy4g
VXNlICcqJyB0byBpbmRpY2F0ZSBhbGwKIG1ldGhvZHMgaW4gYWxsIEFQSXMuCgogUmVmZXIg
dG8gW3NlbGVjdG9yXVtnb29nbGUuYXBpLkRvY3VtZW50YXRpb25SdWxlLnNlbGVjdG9yXSBm
b3Igc3ludGF4CiBkZXRhaWxzLgoKDAoFBAECAAUSA0cCCAoMCgUEAQIAARIDRwkRCgwKBQQB
AgADEgNHFBUKpAIKBAQBAgESA04CKhqWAiBEZWZpbmUgcGFyYW1ldGVycy4gTXVsdGlwbGUg
bmFtZXMgbWF5IGJlIGRlZmluZWQgZm9yIGEgcGFyYW1ldGVyLgogRm9yIGEgZ2l2ZW4gbWV0
aG9kIGNhbGwsIG9ubHkgb25lIG9mIHRoZW0gc2hvdWxkIGJlIHVzZWQuIElmIG11bHRpcGxl
CiBuYW1lcyBhcmUgdXNlZCB0aGUgYmVoYXZpb3IgaXMgaW1wbGVtZW50YXRpb24tZGVwZW5k
ZW50LgogSWYgbm9uZSBvZiB0aGUgc3BlY2lmaWVkIG5hbWVzIGFyZSBwcmVzZW50IHRoZSBi
ZWhhdmlvciBpcwogcGFyYW1ldGVyLWRlcGVuZGVudC4KCgwKBQQBAgEEEgNOAgoKDAoFBAEC
AQYSA04LGgoMCgUEAQIBARIDThslCgwKBQQBAgEDEgNOKCkKyAEKAgQCEgRUAF8BGrsBIERl
ZmluZSBhIHBhcmFtZXRlcidzIG5hbWUgYW5kIGxvY2F0aW9uLiBUaGUgcGFyYW1ldGVyIG1h
eSBiZSBwYXNzZWQgYXMgZWl0aGVyCiBhbiBIVFRQIGhlYWRlciBvciBhIFVSTCBxdWVyeSBw
YXJhbWV0ZXIsIGFuZCBpZiBib3RoIGFyZSBwYXNzZWQgdGhlIGJlaGF2aW9yCiBpcyBpbXBs
ZW1lbnRhdGlvbi1kZXBlbmRlbnQuCgoKCgMEAgESA1QIFwpaCgQEAgIAEgNWAhIaTSBEZWZp
bmUgdGhlIG5hbWUgb2YgdGhlIHBhcmFtZXRlciwgc3VjaCBhcyAiYXBpX2tleSIgLiBJdCBp
cyBjYXNlIHNlbnNpdGl2ZS4KCgwKBQQCAgAFEgNWAggKDAoFBAICAAESA1YJDQoMCgUEAgIA
AxIDVhARCl0KBAQCAgESA1oCGRpQIERlZmluZSB0aGUgSFRUUCBoZWFkZXIgbmFtZSB0byB1
c2UgZm9yIHRoZSBwYXJhbWV0ZXIuIEl0IGlzIGNhc2UKIGluc2Vuc2l0aXZlLgoKDAoFBAIC
AQUSA1oCCAoMCgUEAgIBARIDWgkUCgwKBQQCAgEDEgNaFxgKYwoEBAICAhIDXgIhGlYgRGVm
aW5lIHRoZSBVUkwgcXVlcnkgcGFyYW1ldGVyIG5hbWUgdG8gdXNlIGZvciB0aGUgcGFyYW1l
dGVyLiBJdCBpcyBjYXNlCiBzZW5zaXRpdmUuCgoMCgUEAgICBRIDXgIICgwKBQQCAgIBEgNe
CRwKDAoFBAICAgMSA14fIGIGcHJvdG8z
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::SystemParameter::SystemParameters ===
    # Fields for SystemParameters
    # Field: rules Type: 11 (.google.api.SystemParameterRule)

# === Message: Google::Api::SystemParameter::SystemParameterRule ===
    # Fields for SystemParameterRule
    # Field: selector Type: 9 ()
    # Field: parameters Type: 11 (.google.api.SystemParameter)

# === Message: Google::Api::SystemParameter::SystemParameter ===
    # Fields for SystemParameter
    # Field: name Type: 9 ()
    # Field: http_header Type: 9 ()
    # Field: url_query_parameter Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::SystemParameter - Compiled Protocol Buffers messages for google/api/system_parameter.proto

=head1 SYNOPSIS

    use Google::Api::SystemParameter;

    my $msg = Google::Api::SystemParameter::SystemParameters->new({
        rules => $rules,
    });

    # Read or update a field
    my $val = $msg->rules();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::SystemParameter::SystemParameters->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/system_parameter.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::SystemParameter::SystemParameters

### System parameter configuration

A system parameter is a special kind of parameter defined by the API
system, not by an individual API. It is typically mapped to an HTTP header
and/or a URL query parameter. This configuration specifies which methods
change the names of the system parameters.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->rules() >> / C<< $msg->rules($value) >>

Type: C<Message> (L<Google::Api::SystemParameter::SystemParameterRule>)

Define system parameters.

The parameters defined here will override the default parameters
implemented by the system. If this field is missing from the service
config, default system parameters will be used. Default system parameters
and names is implementation-dependent.

Example: define api key for all methods

    system_parameters
      rules:
        - selector: "*"
          parameters:
            - name: api_key
              url_query_parameter: api_key


Example: define 2 api key names for a specific method.

    system_parameters
      rules:
        - selector: "/ListShelves"
          parameters:
            - name: api_key
              http_header: Api-Key1
            - name: api_key
              http_header: Api-Key2

B<NOTE:> All service configuration rules follow "last one wins" order.

=back

=head2 Google::Api::SystemParameter::SystemParameterRule

Define a system parameter rule mapping system parameter definitions to
methods.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->selector() >> / C<< $msg->selector($value) >>

Type: C<String>

Selects the methods to which this rule applies. Use '*' to indicate all
methods in all APIs.

Refer to [selector][google.api.DocumentationRule.selector] for syntax
details.

=item * C<< $msg->parameters() >> / C<< $msg->parameters($value) >>

Type: C<Message> (L<Google::Api::SystemParameter::SystemParameter>)

Define parameters. Multiple names may be defined for a parameter.
For a given method call, only one of them should be used. If multiple
names are used the behavior is implementation-dependent.
If none of the specified names are present the behavior is
parameter-dependent.

=back

=head2 Google::Api::SystemParameter::SystemParameter

Define a parameter's name and location. The parameter may be passed as either
an HTTP header or a URL query parameter, and if both are passed the behavior
is implementation-dependent.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->name() >> / C<< $msg->name($value) >>

Type: C<String>

Define the name of the parameter, such as "api_key" . It is case sensitive.

=item * C<< $msg->http_header() >> / C<< $msg->http_header($value) >>

Type: C<String>

Define the HTTP header name to use for the parameter. It is case
insensitive.

=item * C<< $msg->url_query_parameter() >> / C<< $msg->url_query_parameter($value) >>

Type: C<String>

Define the URL query parameter name to use for the parameter. It is case
sensitive.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::SystemParameter::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

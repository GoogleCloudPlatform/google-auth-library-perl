package Google::Api::ConfigChange;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Ch5nb29nbGUvYXBpL2NvbmZpZ19jaGFuZ2UucHJvdG8SCmdvb2dsZS5hcGkiyQEKDENvbmZp
Z0NoYW5nZRIYCgdlbGVtZW50GAEgASgJUgdlbGVtZW50EhsKCW9sZF92YWx1ZRgCIAEoCVII
b2xkVmFsdWUSGwoJbmV3X3ZhbHVlGAMgASgJUghuZXdWYWx1ZRI3CgtjaGFuZ2VfdHlwZRgE
IAEoDjIWLmdvb2dsZS5hcGkuQ2hhbmdlVHlwZVIKY2hhbmdlVHlwZRIsCgdhZHZpY2VzGAUg
AygLMhIuZ29vZ2xlLmFwaS5BZHZpY2VSB2FkdmljZXMiKgoGQWR2aWNlEiAKC2Rlc2NyaXB0
aW9uGAIgASgJUgtkZXNjcmlwdGlvbipPCgpDaGFuZ2VUeXBlEhsKF0NIQU5HRV9UWVBFX1VO
U1BFQ0lGSUVEEAASCQoFQURERUQQARILCgdSRU1PVkVEEAISDAoITU9ESUZJRUQQA0JxCg5j
b20uZ29vZ2xlLmFwaUIRQ29uZmlnQ2hhbmdlUHJvdG9QAVpDZ29vZ2xlLmdvbGFuZy5vcmcv
Z2VucHJvdG8vZ29vZ2xlYXBpcy9hcGkvY29uZmlnY2hhbmdlO2NvbmZpZ2NoYW5nZaICBEdB
UElK5RgKBhIEDgBTAQq8BAoBDBIDDgASMrEEIENvcHlyaWdodCAyMDI2IEdvb2dsZSBMTEMK
CiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0aGUg
IkxpY2Vuc2UiKTsKIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBs
aWFuY2Ugd2l0aCB0aGUgTGljZW5zZS4KIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUg
TGljZW5zZSBhdAoKICAgICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5T
RS0yLjAKCiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVkIHRv
IGluIHdyaXRpbmcsIHNvZnR3YXJlCiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBp
cyBkaXN0cmlidXRlZCBvbiBhbiAiQVMgSVMiIEJBU0lTLAogV0lUSE9VVCBXQVJSQU5USUVT
IE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQu
CiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcg
cGVybWlzc2lvbnMgYW5kCiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS4KCggKAQIS
AxAAEwoICgEIEgMSAFoKCQoCCAsSAxIAWgoICgEIEgMTACIKCQoCCAoSAxMAIgoICgEIEgMU
ADIKCQoCCAgSAxQAMgoICgEIEgMVACcKCQoCCAESAxUAJwoICgEIEgMWACIKCQoCCCQSAxYA
IgqOAgoCBAASBB4AOAEagQIgT3V0cHV0IGdlbmVyYXRlZCBmcm9tIHNlbWFudGljYWxseSBj
b21wYXJpbmcgdHdvIHZlcnNpb25zIG9mIGEgc2VydmljZQogY29uZmlndXJhdGlvbi4KCiBJ
bmNsdWRlcyBkZXRhaWxlZCBpbmZvcm1hdGlvbiBhYm91dCBhIGZpZWxkIHRoYXQgaGF2ZSBj
aGFuZ2VkIHdpdGgKIGFwcGxpY2FibGUgYWR2aWNlIGFib3V0IHBvdGVudGlhbCBjb25zZXF1
ZW5jZXMgZm9yIHRoZSBjaGFuZ2UsIHN1Y2ggYXMKIGJhY2t3YXJkcy1pbmNvbXBhdGliaWxp
dHkuCgoKCgMEAAESAx4IFAr/AwoEBAACABIDKAIVGvEDIE9iamVjdCBoaWVyYXJjaHkgcGF0
aCB0byB0aGUgY2hhbmdlLCB3aXRoIGxldmVscyBzZXBhcmF0ZWQgYnkgYSAnLicKIGNoYXJh
Y3Rlci4gRm9yIHJlcGVhdGVkIGZpZWxkcywgYW4gYXBwbGljYWJsZSB1bmlxdWUgaWRlbnRp
ZmllciBmaWVsZCBpcwogdXNlZCBmb3IgdGhlIGluZGV4ICh1c3VhbGx5IHNlbGVjdG9yLCBu
YW1lLCBvciBpZCkuIEZvciBtYXBzLCB0aGUgdGVybQogJ2tleScgaXMgdXNlZC4gSWYgdGhl
IGZpZWxkIGhhcyBubyB1bmlxdWUgaWRlbnRpZmllciwgdGhlIG51bWVyaWMgaW5kZXgKIGlz
IHVzZWQuCiBFeGFtcGxlczoKIC0gdmlzaWJpbGl0eS5ydWxlc1tzZWxlY3Rvcj09Imdvb2ds
ZS5MaWJyYXJ5U2VydmljZS5MaXN0Qm9va3MiXS5yZXN0cmljdGlvbgogLSBxdW90YS5tZXRy
aWNfcnVsZXNbc2VsZWN0b3I9PSJnb29nbGUiXS5tZXRyaWNfY29zdHNba2V5PT0icmVhZHMi
XS52YWx1ZQogLSBsb2dnaW5nLnByb2R1Y2VyX2Rlc3RpbmF0aW9uc1swXQoKDAoFBAACAAUS
AygCCAoMCgUEAAIAARIDKAkQCgwKBQQAAgADEgMoExQKlwEKBAQAAgESAywCFxqJASBWYWx1
ZSBvZiB0aGUgY2hhbmdlZCBvYmplY3QgaW4gdGhlIG9sZCBTZXJ2aWNlIGNvbmZpZ3VyYXRp
b24sCiBpbiBKU09OIGZvcm1hdC4gVGhpcyBmaWVsZCB3aWxsIG5vdCBiZSBwb3B1bGF0ZWQg
aWYgQ2hhbmdlVHlwZSA9PSBBRERFRC4KCgwKBQQAAgEFEgMsAggKDAoFBAACAQESAywJEgoM
CgUEAAIBAxIDLBUWCpkBCgQEAAICEgMwAhcaiwEgVmFsdWUgb2YgdGhlIGNoYW5nZWQgb2Jq
ZWN0IGluIHRoZSBuZXcgU2VydmljZSBjb25maWd1cmF0aW9uLAogaW4gSlNPTiBmb3JtYXQu
IFRoaXMgZmllbGQgd2lsbCBub3QgYmUgcG9wdWxhdGVkIGlmIENoYW5nZVR5cGUgPT0gUkVN
T1ZFRC4KCgwKBQQAAgIFEgMwAggKDAoFBAACAgESAzAJEgoMCgUEAAICAxIDMBUWCkwKBAQA
AgMSAzMCHRo/IFRoZSB0eXBlIGZvciB0aGlzIGNoYW5nZSwgZWl0aGVyIEFEREVELCBSRU1P
VkVELCBvciBNT0RJRklFRC4KCgwKBQQAAgMGEgMzAgwKDAoFBAACAwESAzMNGAoMCgUEAAID
AxIDMxscCnkKBAQAAgQSAzcCHhpsIENvbGxlY3Rpb24gb2YgYWR2aWNlIHByb3ZpZGVkIGZv
ciB0aGlzIGNoYW5nZSwgdXNlZnVsIGZvciBkZXRlcm1pbmluZyB0aGUKIHBvc3NpYmxlIGlt
cGFjdCBvZiB0aGlzIGNoYW5nZS4KCgwKBQQAAgQEEgM3AgoKDAoFBAACBAYSAzcLEQoMCgUE
AAIEARIDNxIZCgwKBQQAAgQDEgM3HB0KiwEKAgQBEgQ8AEABGn8gR2VuZXJhdGVkIGFkdmlj
ZSBhYm91dCB0aGlzIGNoYW5nZSwgdXNlZCBmb3IgcHJvdmlkaW5nIG1vcmUKIGluZm9ybWF0
aW9uIGFib3V0IGhvdyBhIGNoYW5nZSB3aWxsIGFmZmVjdCB0aGUgZXhpc3Rpbmcgc2Vydmlj
ZS4KCgoKAwQBARIDPAgOCoIBCgQEAQIAEgM/AhkadSBVc2VmdWwgZGVzY3JpcHRpb24gZm9y
IHdoeSB0aGlzIGFkdmljZSB3YXMgYXBwbGllZCBhbmQgd2hhdCBhY3Rpb25zIHNob3VsZAog
YmUgdGFrZW4gdG8gbWl0aWdhdGUgYW55IGltcGxpZWQgcmlza3MuCgoMCgUEAQIABRIDPwII
CgwKBQQBAgABEgM/CRQKDAoFBAECAAMSAz8XGApiCgIFABIERABTARpWIENsYXNzaWZpZXMg
c2V0IG9mIHBvc3NpYmxlIG1vZGlmaWNhdGlvbnMgdG8gYW4gb2JqZWN0IGluIHRoZSBzZXJ2
aWNlCiBjb25maWd1cmF0aW9uLgoKCgoDBQABEgNEBQ8KJQoEBQACABIDRgIeGhggTm8gdmFs
dWUgd2FzIHByb3ZpZGVkLgoKDAoFBQACAAESA0YCGQoMCgUFAAIAAhIDRhwdCnkKBAUAAgES
A0oCDBpsIFRoZSBjaGFuZ2VkIG9iamVjdCBleGlzdHMgaW4gdGhlICduZXcnIHNlcnZpY2Ug
Y29uZmlndXJhdGlvbiwgYnV0IG5vdAogaW4gdGhlICdvbGQnIHNlcnZpY2UgY29uZmlndXJh
dGlvbi4KCgwKBQUAAgEBEgNKAgcKDAoFBQACAQISA0oKCwp5CgQFAAICEgNOAg4abCBUaGUg
Y2hhbmdlZCBvYmplY3QgZXhpc3RzIGluIHRoZSAnb2xkJyBzZXJ2aWNlIGNvbmZpZ3VyYXRp
b24sIGJ1dCBub3QKIGluIHRoZSAnbmV3JyBzZXJ2aWNlIGNvbmZpZ3VyYXRpb24uCgoMCgUF
AAICARIDTgIJCgwKBQUAAgICEgNODA0KZQoEBQACAxIDUgIPGlggVGhlIGNoYW5nZWQgb2Jq
ZWN0IGV4aXN0cyBpbiBib3RoIHNlcnZpY2UgY29uZmlndXJhdGlvbnMsIGJ1dCBpdHMgdmFs
dWUKIGlzIGRpZmZlcmVudC4KCgwKBQUAAgMBEgNSAgoKDAoFBQACAwISA1INDmIGcHJvdG8z

EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::ConfigChange::ConfigChange ===
    # Fields for ConfigChange
    # Field: element Type: 9 ()
    # Field: old_value Type: 9 ()
    # Field: new_value Type: 9 ()
    # Field: change_type Type: 14 (.google.api.ChangeType)
    # Field: advices Type: 11 (.google.api.Advice)

# === Message: Google::Api::ConfigChange::Advice ===
    # Fields for Advice
    # Field: description Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::ConfigChange - Compiled Protocol Buffers messages for google/api/config_change.proto

=head1 SYNOPSIS

    use Google::Api::ConfigChange;

    my $msg = Google::Api::ConfigChange::ConfigChange->new({
        element => $element,
        old_value => $old_value,
        new_value => $new_value,
        change_type => $change_type,
    });

    # Read or update a field
    my $val = $msg->element();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::ConfigChange::ConfigChange->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/config_change.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::ConfigChange::ConfigChange

Output generated from semantically comparing two versions of a service
configuration.

Includes detailed information about a field that have changed with
applicable advice about potential consequences for the change, such as
backwards-incompatibility.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->element() >> / C<< $msg->element($value) >>

Type: C<String>

Object hierarchy path to the change, with levels separated by a '.'
character. For repeated fields, an applicable unique identifier field is
used for the index (usually selector, name, or id). For maps, the term
'key' is used. If the field has no unique identifier, the numeric index
is used.
Examples:
- visibility.rules[selector=="google.LibraryService.ListBooks"].restriction
- quota.metric_rules[selector=="google"].metric_costs[key=="reads"].value
- logging.producer_destinations[0]

=item * C<< $msg->old_value() >> / C<< $msg->old_value($value) >>

Type: C<String>

Value of the changed object in the old Service configuration,
in JSON format. This field will not be populated if ChangeType == ADDED.

=item * C<< $msg->new_value() >> / C<< $msg->new_value($value) >>

Type: C<String>

Value of the changed object in the new Service configuration,
in JSON format. This field will not be populated if ChangeType == REMOVED.

=item * C<< $msg->change_type() >> / C<< $msg->change_type($value) >>

Type: C<Enum> (L<Google::Api::ChangeType>)

The type for this change, either ADDED, REMOVED, or MODIFIED.

=item * C<< $msg->advices() >> / C<< $msg->advices($value) >>

Type: C<Message> (L<Google::Api::ConfigChange::Advice>)

Collection of advice provided for this change, useful for determining the
possible impact of this change.

=back

=head2 Google::Api::ConfigChange::Advice

Generated advice about this change, used for providing more
information about how a change will affect the existing service.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->description() >> / C<< $msg->description($value) >>

Type: C<String>

Useful description for why this advice was applied and what actions should
be taken to mitigate any implied risks.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::ConfigChange::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

package Google::Api::Visibility;

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
Chtnb29nbGUvYXBpL3Zpc2liaWxpdHkucHJvdG8SCmdvb2dsZS5hcGkaIGdvb2dsZS9wcm90
b2J1Zi9kZXNjcmlwdG9yLnByb3RvIj4KClZpc2liaWxpdHkSMAoFcnVsZXMYASADKAsyGi5n
b29nbGUuYXBpLlZpc2liaWxpdHlSdWxlUgVydWxlcyJOCg5WaXNpYmlsaXR5UnVsZRIaCghz
ZWxlY3RvchgBIAEoCVIIc2VsZWN0b3ISIAoLcmVzdHJpY3Rpb24YAiABKAlSC3Jlc3RyaWN0
aW9uOmQKD2VudW1fdmlzaWJpbGl0eRIcLmdvb2dsZS5wcm90b2J1Zi5FbnVtT3B0aW9ucxiv
yrwiIAEoCzIaLmdvb2dsZS5hcGkuVmlzaWJpbGl0eVJ1bGVSDmVudW1WaXNpYmlsaXR5OmsK
EHZhbHVlX3Zpc2liaWxpdHkSIS5nb29nbGUucHJvdG9idWYuRW51bVZhbHVlT3B0aW9ucxiv
yrwiIAEoCzIaLmdvb2dsZS5hcGkuVmlzaWJpbGl0eVJ1bGVSD3ZhbHVlVmlzaWJpbGl0eTpn
ChBmaWVsZF92aXNpYmlsaXR5Eh0uZ29vZ2xlLnByb3RvYnVmLkZpZWxkT3B0aW9ucxivyrwi
IAEoCzIaLmdvb2dsZS5hcGkuVmlzaWJpbGl0eVJ1bGVSD2ZpZWxkVmlzaWJpbGl0eTptChJt
ZXNzYWdlX3Zpc2liaWxpdHkSHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMYr8q8
IiABKAsyGi5nb29nbGUuYXBpLlZpc2liaWxpdHlSdWxlUhFtZXNzYWdlVmlzaWJpbGl0eTpq
ChFtZXRob2RfdmlzaWJpbGl0eRIeLmdvb2dsZS5wcm90b2J1Zi5NZXRob2RPcHRpb25zGK/K
vCIgASgLMhouZ29vZ2xlLmFwaS5WaXNpYmlsaXR5UnVsZVIQbWV0aG9kVmlzaWJpbGl0eTpl
Cg5hcGlfdmlzaWJpbGl0eRIfLmdvb2dsZS5wcm90b2J1Zi5TZXJ2aWNlT3B0aW9ucxivyrwi
IAEoCzIaLmdvb2dsZS5hcGkuVmlzaWJpbGl0eVJ1bGVSDWFwaVZpc2liaWxpdHlCawoOY29t
Lmdvb2dsZS5hcGlCD1Zpc2liaWxpdHlQcm90b1ABWj9nb29nbGUuZ29sYW5nLm9yZy9nZW5w
cm90by9nb29nbGVhcGlzL2FwaS92aXNpYmlsaXR5O3Zpc2liaWxpdHmiAgRHQVBJSokaCgYS
BA4AbwEKvAQKAQwSAw4AEjKxBCBDb3B5cmlnaHQgMjAyNiBHb29nbGUgTExDCgogTGljZW5z
ZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlICJMaWNlbnNl
Iik7CiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdp
dGggdGhlIExpY2Vuc2UuCiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2Ug
YXQKCiAgICAgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wCgog
VW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0
aW5nLCBzb2Z0d2FyZQogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJp
YnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05E
SVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLgogU2VlIHRo
ZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Np
b25zIGFuZAogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuCgoICgECEgMQABMKCQoC
AwASAxIAKgoICgEIEgMUAFYKCQoCCAsSAxQAVgoICgEIEgMVACIKCQoCCAoSAxUAIgoICgEI
EgMWADAKCQoCCAgSAxYAMAoICgEIEgMXACcKCQoCCAESAxcAJwoICgEIEgMYACIKCQoCCCQS
AxgAIgoJCgEHEgQaAB0BCiIKAgcAEgMcAjcaFyBTZWUgYFZpc2liaWxpdHlSdWxlYC4KCgoK
AwcAAhIDGgciCgoKAwcABhIDHAIbCgoKAwcAARIDHBwrCgoKAwcAAxIDHC42CgkKAQcSBB8A
IgEKIgoCBwESAyECOBoXIFNlZSBgVmlzaWJpbGl0eVJ1bGVgLgoKCgoDBwECEgMfBycKCgoD
BwEGEgMhAhsKCgoDBwEBEgMhHCwKCgoDBwEDEgMhLzcKCQoBBxIEJAAnAQoiCgIHAhIDJgI4
GhcgU2VlIGBWaXNpYmlsaXR5UnVsZWAuCgoKCgMHAgISAyQHIwoKCgMHAgYSAyYCGwoKCgMH
AgESAyYcLAoKCgMHAgMSAyYvNwoJCgEHEgQpACwBCiIKAgcDEgMrAjoaFyBTZWUgYFZpc2li
aWxpdHlSdWxlYC4KCgoKAwcDAhIDKQclCgoKAwcDBhIDKwIbCgoKAwcDARIDKxwuCgoKAwcD
AxIDKzE5CgkKAQcSBC4AMQEKIgoCBwQSAzACORoXIFNlZSBgVmlzaWJpbGl0eVJ1bGVgLgoK
CgoDBwQCEgMuByQKCgoDBwQGEgMwAhsKCgoDBwQBEgMwHC0KCgoDBwQDEgMwMDgKCQoBBxIE
MwA2AQoiCgIHBRIDNQI2GhcgU2VlIGBWaXNpYmlsaXR5UnVsZWAuCgoKCgMHBQISAzMHJQoK
CgMHBQYSAzUCGwoKCgMHBQESAzUcKgoKCgMHBQMSAzUtNQqjBwoCBAASBE8AVAEalgcgYFZp
c2liaWxpdHlgIHJlc3RyaWN0cyBzZXJ2aWNlIGNvbnN1bWVyJ3MgYWNjZXNzIHRvIHNlcnZp
Y2UgZWxlbWVudHMsCiBzdWNoIGFzIHdoZXRoZXIgYW4gYXBwbGljYXRpb24gY2FuIGNhbGwg
YSB2aXNpYmlsaXR5LXJlc3RyaWN0ZWQgbWV0aG9kLgogVGhlIHJlc3RyaWN0aW9uIGlzIGV4
cHJlc3NlZCBieSBhcHBseWluZyB2aXNpYmlsaXR5IGxhYmVscyBvbiBzZXJ2aWNlCiBlbGVt
ZW50cy4gVGhlIHZpc2liaWxpdHkgbGFiZWxzIGFyZSBlbHNld2hlcmUgbGlua2VkIHRvIHNl
cnZpY2UgY29uc3VtZXJzLgoKIEEgc2VydmljZSBjYW4gZGVmaW5lIG11bHRpcGxlIHZpc2li
aWxpdHkgbGFiZWxzLCBidXQgYSBzZXJ2aWNlIGNvbnN1bWVyCiBzaG91bGQgYmUgZ3JhbnRl
ZCBhdCBtb3N0IG9uZSB2aXNpYmlsaXR5IGxhYmVsLiBNdWx0aXBsZSB2aXNpYmlsaXR5CiBs
YWJlbHMgZm9yIGEgc2luZ2xlIHNlcnZpY2UgY29uc3VtZXIgYXJlIG5vdCBzdXBwb3J0ZWQu
CgogSWYgYW4gZWxlbWVudCBhbmQgYWxsIGl0cyBwYXJlbnRzIGhhdmUgbm8gdmlzaWJpbGl0
eSBsYWJlbCwgaXRzIHZpc2liaWxpdHkKIGlzIHVuY29uZGl0aW9uYWxseSBncmFudGVkLgoK
IEV4YW1wbGU6CgogICAgIHZpc2liaWxpdHk6CiAgICAgICBydWxlczoKICAgICAgIC0gc2Vs
ZWN0b3I6IGdvb2dsZS5jYWxlbmRhci5DYWxlbmRhci5FbmhhbmNlZFNlYXJjaAogICAgICAg
ICByZXN0cmljdGlvbjogUFJFVklFVwogICAgICAgLSBzZWxlY3RvcjogZ29vZ2xlLmNhbGVu
ZGFyLkNhbGVuZGFyLkRlbGVnYXRlCiAgICAgICAgIHJlc3RyaWN0aW9uOiBJTlRFUk5BTAoK
IEhlcmUsIGFsbCBtZXRob2RzIGFyZSBwdWJsaWNseSB2aXNpYmxlIGV4Y2VwdCBmb3IgdGhl
IHJlc3RyaWN0ZWQgbWV0aG9kcwogRW5oYW5jZWRTZWFyY2ggYW5kIERlbGVnYXRlLgoKCgoD
BAABEgNPCBIKmwEKBAQAAgASA1MCJBqNASBBIGxpc3Qgb2YgdmlzaWJpbGl0eSBydWxlcyB0
aGF0IGFwcGx5IHRvIGluZGl2aWR1YWwgQVBJIGVsZW1lbnRzLgoKICoqTk9URToqKiBBbGwg
c2VydmljZSBjb25maWd1cmF0aW9uIHJ1bGVzIGZvbGxvdyAibGFzdCBvbmUgd2lucyIgb3Jk
ZXIuCgoMCgUEAAIABBIDUwIKCgwKBQQAAgAGEgNTCxkKDAoFBAACAAESA1MaHwoMCgUEAAIA
AxIDUyIjCmEKAgQBEgRYAG8BGlUgQSB2aXNpYmlsaXR5IHJ1bGUgcHJvdmlkZXMgdmlzaWJp
bGl0eSBjb25maWd1cmF0aW9uIGZvciBhbiBpbmRpdmlkdWFsIEFQSQogZWxlbWVudC4KCgoK
AwQBARIDWAgWCqwBCgQEAQIAEgNdAhYangEgU2VsZWN0cyBtZXRob2RzLCBtZXNzYWdlcywg
ZmllbGRzLCBlbnVtcywgZXRjLiB0byB3aGljaCB0aGlzIHJ1bGUgYXBwbGllcy4KCiBSZWZl
ciB0byBbc2VsZWN0b3JdW2dvb2dsZS5hcGkuRG9jdW1lbnRhdGlvblJ1bGUuc2VsZWN0b3Jd
IGZvciBzeW50YXgKIGRldGFpbHMuCgoMCgUEAQIABRIDXQIICgwKBQQBAgABEgNdCREKDAoF
BAECAAMSA10UFQqNBAoEBAECARIDbgIZGv8DIEEgY29tbWEtc2VwYXJhdGVkIGxpc3Qgb2Yg
dmlzaWJpbGl0eSBsYWJlbHMgdGhhdCBhcHBseSB0byB0aGUgYHNlbGVjdG9yYC4KIEFueSBv
ZiB0aGUgbGlzdGVkIGxhYmVscyBjYW4gYmUgdXNlZCB0byBncmFudCB0aGUgdmlzaWJpbGl0
eS4KCiBJZiBhIHJ1bGUgaGFzIG11bHRpcGxlIGxhYmVscywgcmVtb3Zpbmcgb25lIG9mIHRo
ZSBsYWJlbHMgYnV0IG5vdCBhbGwgb2YKIHRoZW0gY2FuIGJyZWFrIGNsaWVudHMuCgogRXhh
bXBsZToKCiAgICAgdmlzaWJpbGl0eToKICAgICAgIHJ1bGVzOgogICAgICAgLSBzZWxlY3Rv
cjogZ29vZ2xlLmNhbGVuZGFyLkNhbGVuZGFyLkVuaGFuY2VkU2VhcmNoCiAgICAgICAgIHJl
c3RyaWN0aW9uOiBJTlRFUk5BTCwgUFJFVklFVwoKIFJlbW92aW5nIElOVEVSTkFMIGZyb20g
dGhpcyByZXN0cmljdGlvbiB3aWxsIGJyZWFrIGNsaWVudHMgdGhhdCByZWx5IG9uCiB0aGlz
IG1ldGhvZCBhbmQgb25seSBoYWQgYWNjZXNzIHRvIGl0IHRocm91Z2ggSU5URVJOQUwuCgoM
CgUEAQIBBRIDbgIICgwKBQQBAgEBEgNuCRQKDAoFBAECAQMSA24XGGIGcHJvdG8z
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Visibility::Visibility ===
    # Fields for Visibility
    # Field: rules Type: 11 (.google.api.VisibilityRule)

# === Message: Google::Api::Visibility::VisibilityRule ===
    # Fields for VisibilityRule
    # Field: selector Type: 9 ()
    # Field: restriction Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Visibility - Compiled Protocol Buffers messages for google/api/visibility.proto

=head1 SYNOPSIS

    use Google::Api::Visibility;

    my $msg = Google::Api::Visibility::Visibility->new({
        rules => $rules,
    });

    # Read or update a field
    my $val = $msg->rules();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Visibility::Visibility->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/visibility.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Visibility::Visibility

`Visibility` restricts service consumer's access to service elements,
such as whether an application can call a visibility-restricted method.
The restriction is expressed by applying visibility labels on service
elements. The visibility labels are elsewhere linked to service consumers.

A service can define multiple visibility labels, but a service consumer
should be granted at most one visibility label. Multiple visibility
labels for a single service consumer are not supported.

If an element and all its parents have no visibility label, its visibility
is unconditionally granted.

Example:

    visibility:
      rules:
      - selector: google.calendar.Calendar.EnhancedSearch
        restriction: PREVIEW
      - selector: google.calendar.Calendar.Delegate
        restriction: INTERNAL

Here, all methods are publicly visible except for the restricted methods
EnhancedSearch and Delegate.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->rules() >> / C<< $msg->rules($value) >>

Type: C<Message> (L<Google::Api::Visibility::VisibilityRule>)

A list of visibility rules that apply to individual API elements.

B<NOTE:> All service configuration rules follow "last one wins" order.

=back

=head2 Google::Api::Visibility::VisibilityRule

A visibility rule provides visibility configuration for an individual API
element.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->selector() >> / C<< $msg->selector($value) >>

Type: C<String>

Selects methods, messages, fields, enums, etc. to which this rule applies.

Refer to [selector][google.api.DocumentationRule.selector] for syntax
details.

=item * C<< $msg->restriction() >> / C<< $msg->restriction($value) >>

Type: C<String>

A comma-separated list of visibility labels that apply to the `selector`.
Any of the listed labels can be used to grant the visibility.

If a rule has multiple labels, removing one of the labels but not all of
them can break clients.

Example:

    visibility:
      rules:
      - selector: google.calendar.Calendar.EnhancedSearch
        restriction: INTERNAL, PREVIEW

Removing INTERNAL from this restriction will break clients that rely on
this method and only had access to it through INTERNAL.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Visibility::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

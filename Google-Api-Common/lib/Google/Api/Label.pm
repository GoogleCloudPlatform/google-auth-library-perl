package Google::Api::Label;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
ChZnb29nbGUvYXBpL2xhYmVsLnByb3RvEgpnb29nbGUuYXBpIrkBCg9MYWJlbERlc2NyaXB0
b3ISEAoDa2V5GAEgASgJUgNrZXkSRAoKdmFsdWVfdHlwZRgCIAEoDjIlLmdvb2dsZS5hcGku
TGFiZWxEZXNjcmlwdG9yLlZhbHVlVHlwZVIJdmFsdWVUeXBlEiAKC2Rlc2NyaXB0aW9uGAMg
ASgJUgtkZXNjcmlwdGlvbiIsCglWYWx1ZVR5cGUSCgoGU1RSSU5HEAASCAoEQk9PTBABEgkK
BUlOVDY0EAJCXAoOY29tLmdvb2dsZS5hcGlCCkxhYmVsUHJvdG9QAVo1Z29vZ2xlLmdvbGFu
Zy5vcmcvZ2VucHJvdG8vZ29vZ2xlYXBpcy9hcGkvbGFiZWw7bGFiZWyiAgRHQVBJSs8KCgYS
BA4ALgEKvAQKAQwSAw4AEjKxBCBDb3B5cmlnaHQgMjAyNiBHb29nbGUgTExDCgogTGljZW5z
ZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlICJMaWNlbnNl
Iik7CiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdp
dGggdGhlIExpY2Vuc2UuCiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2Ug
YXQKCiAgICAgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wCgog
VW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0
aW5nLCBzb2Z0d2FyZQogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJp
YnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05E
SVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLgogU2VlIHRo
ZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Np
b25zIGFuZAogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuCgoICgECEgMQABMKCAoB
CBIDEgBMCgkKAggLEgMSAEwKCAoBCBIDEwAiCgkKAggKEgMTACIKCAoBCBIDFAArCgkKAggI
EgMUACsKCAoBCBIDFQAnCgkKAggBEgMVACcKCAoBCBIDFgAiCgkKAggkEgMWACIKJwoCBAAS
BBkALgEaGyBBIGRlc2NyaXB0aW9uIG9mIGEgbGFiZWwuCgoKCgMEAAESAxkIFwo9CgQEAAQA
EgQbAiQDGi8gVmFsdWUgdHlwZXMgdGhhdCBjYW4gYmUgdXNlZCBhcyBsYWJlbCB2YWx1ZXMu
CgoMCgUEAAQAARIDGwcQCj8KBgQABAACABIDHQQPGjAgQSB2YXJpYWJsZS1sZW5ndGggc3Ry
aW5nLiBUaGlzIGlzIHRoZSBkZWZhdWx0LgoKDgoHBAAEAAIAARIDHQQKCg4KBwQABAACAAIS
Ax0NDgooCgYEAAQAAgESAyAEDRoZIEJvb2xlYW47IHRydWUgb3IgZmFsc2UuCgoOCgcEAAQA
AgEBEgMgBAgKDgoHBAAEAAIBAhIDIAsMCikKBgQABAACAhIDIwQOGhogQSA2NC1iaXQgc2ln
bmVkIGludGVnZXIuCgoOCgcEAAQAAgIBEgMjBAkKDgoHBAAEAAICAhIDIwwNCh0KBAQAAgAS
AycCERoQIFRoZSBsYWJlbCBrZXkuCgoMCgUEAAIABRIDJwIICgwKBQQAAgABEgMnCQwKDAoF
BAACAAMSAycPEApCCgQEAAIBEgMqAhsaNSBUaGUgdHlwZSBvZiBkYXRhIHRoYXQgY2FuIGJl
IGFzc2lnbmVkIHRvIHRoZSBsYWJlbC4KCgwKBQQAAgEGEgMqAgsKDAoFBAACAQESAyoMFgoM
CgUEAAIBAxIDKhkaCjoKBAQAAgISAy0CGRotIEEgaHVtYW4tcmVhZGFibGUgZGVzY3JpcHRp
b24gZm9yIHRoZSBsYWJlbC4KCgwKBQQAAgIFEgMtAggKDAoFBAACAgESAy0JFAoMCgUEAAIC
AxIDLRcYYgZwcm90bzM=
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Label::LabelDescriptor ===
    # Fields for LabelDescriptor
    # Field: key Type: 9 ()
    # Field: value_type Type: 14 (.google.api.LabelDescriptor.ValueType)
    # Field: description Type: 9 ()

# Enum: LabelDescriptor::ValueType
our $LabelDescriptor_STRING = 0;
our $LabelDescriptor_BOOL = 1;
our $LabelDescriptor_INT64 = 2;

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Label - Compiled Protocol Buffers messages for google/api/label.proto

=head1 SYNOPSIS

    use Google::Api::Label;

    my $msg = Google::Api::Label::LabelDescriptor->new({
        key => $key,
        value_type => $value_type,
        description => $description,
    });

    # Read or update a field
    my $val = $msg->key();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Label::LabelDescriptor->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/label.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Label::LabelDescriptor

A description of a label.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->key() >> / C<< $msg->key($value) >>

Type: C<String>

The label key.

=item * C<< $msg->value_type() >> / C<< $msg->value_type($value) >>

Type: C<Enum> (L<Google::Api::LabelDescriptor::ValueType>)

The type of data that can be assigned to the label.

=item * C<< $msg->description() >> / C<< $msg->description($value) >>

Type: C<String>

A human-readable description for the label.

=back

=head3 Enum: LabelDescriptor::ValueType

=over 4

=item * C<STRING> => C<0>

=item * C<BOOL> => C<1>

=item * C<INT64> => C<2>

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Label::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

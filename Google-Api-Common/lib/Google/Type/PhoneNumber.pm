package Google::Type::PhoneNumber;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Ch5nb29nbGUvdHlwZS9waG9uZV9udW1iZXIucHJvdG8SC2dvb2dsZS50eXBlIuEBCgtQaG9u
ZU51bWJlchIhCgtlMTY0X251bWJlchgBIAEoCUgAUgplMTY0TnVtYmVyEkMKCnNob3J0X2Nv
ZGUYAiABKAsyIi5nb29nbGUudHlwZS5QaG9uZU51bWJlci5TaG9ydENvZGVIAFIJc2hvcnRD
b2RlEhwKCWV4dGVuc2lvbhgDIAEoCVIJZXh0ZW5zaW9uGkQKCVNob3J0Q29kZRIfCgtyZWdp
b25fY29kZRgBIAEoCVIKcmVnaW9uQ29kZRIWCgZudW1iZXIYAiABKAlSBm51bWJlckIGCgRr
aW5kQnEKD2NvbS5nb29nbGUudHlwZUIQUGhvbmVOdW1iZXJQcm90b1ABWkRnb29nbGUuZ29s
YW5nLm9yZy9nZW5wcm90by9nb29nbGVhcGlzL3R5cGUvcGhvbmVfbnVtYmVyO3Bob25lX251
bWJlcqICA0dUUEryIgoGEgQOAHUBCrwECgEMEgMOABIysQQgQ29weXJpZ2h0IDIwMjYgR29v
Z2xlIExMQwoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAy
LjAgKHRoZSAiTGljZW5zZSIpOwogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQg
aW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLgogWW91IG1heSBvYnRhaW4gYSBjb3B5
IG9mIHRoZSBMaWNlbnNlIGF0CgogICAgIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNl
cy9MSUNFTlNFLTIuMAoKIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBh
Z3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUKIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBM
aWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuICJBUyBJUyIgQkFTSVMsCiBXSVRIT1VUIFdB
UlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3Ig
aW1wbGllZC4KIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdv
dmVybmluZyBwZXJtaXNzaW9ucyBhbmQKIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNl
LgoKCAoBAhIDEAAUCggKAQgSAxIAWwoJCgIICxIDEgBbCggKAQgSAxMAIgoJCgIIChIDEwAi
CggKAQgSAxQAMQoJCgIICBIDFAAxCggKAQgSAxUAKAoJCgIIARIDFQAoCggKAQgSAxYAIQoJ
CgIIJBIDFgAhCv8HCgIEABIEMgB1ARryByBBbiBvYmplY3QgcmVwcmVzZW50aW5nIGEgcGhv
bmUgbnVtYmVyLCBzdWl0YWJsZSBhcyBhbiBBUEkgd2lyZSBmb3JtYXQuCgogVGhpcyByZXBy
ZXNlbnRhdGlvbjoKCiAgLSBzaG91bGQgbm90IGJlIHVzZWQgZm9yIGxvY2FsZS1zcGVjaWZp
YyBmb3JtYXR0aW5nIG9mIGEgcGhvbmUgbnVtYmVyLCBzdWNoCiAgICBhcyAiKzEgKDY1MCkg
MjUzLTAwMDAgZXh0LiAxMjMiCgogIC0gaXMgbm90IGRlc2lnbmVkIGZvciBlZmZpY2llbnQg
c3RvcmFnZQogIC0gbWF5IG5vdCBiZSBzdWl0YWJsZSBmb3IgZGlhbGluZyAtIHNwZWNpYWxp
emVkIGxpYnJhcmllcyAoc2VlIHJlZmVyZW5jZXMpCiAgICBzaG91bGQgYmUgdXNlZCB0byBw
YXJzZSB0aGUgbnVtYmVyIGZvciB0aGF0IHB1cnBvc2UKCiBUbyBkbyBzb21ldGhpbmcgbWVh
bmluZ2Z1bCB3aXRoIHRoaXMgbnVtYmVyLCBzdWNoIGFzIGZvcm1hdCBpdCBmb3IgdmFyaW91
cwogdXNlLWNhc2VzLCBjb252ZXJ0IGl0IHRvIGFuIGBpMThuLnBob25lbnVtYmVycy5QaG9u
ZU51bWJlcmAgb2JqZWN0IGZpcnN0LgoKIEZvciBpbnN0YW5jZSwgaW4gSmF2YSB0aGlzIHdv
dWxkIGJlOgoKICAgICBjb20uZ29vZ2xlLnR5cGUuUGhvbmVOdW1iZXIgd2lyZVByb3RvID0K
ICAgICAgICAgY29tLmdvb2dsZS50eXBlLlBob25lTnVtYmVyLm5ld0J1aWxkZXIoKS5idWls
ZCgpOwogICAgIGNvbS5nb29nbGUuaTE4bi5waG9uZW51bWJlcnMuUGhvbmVudW1iZXIuUGhv
bmVOdW1iZXIgcGhvbmVOdW1iZXIgPQogICAgICAgICBQaG9uZU51bWJlclV0aWwuZ2V0SW5z
dGFuY2UoKS5wYXJzZSh3aXJlUHJvdG8uZ2V0RTE2NE51bWJlcigpLCAiWloiKTsKICAgICBp
ZiAoIXdpcmVQcm90by5nZXRFeHRlbnNpb24oKS5pc0VtcHR5KCkpIHsKICAgICAgIHBob25l
TnVtYmVyLnNldEV4dGVuc2lvbih3aXJlUHJvdG8uZ2V0RXh0ZW5zaW9uKCkpOwogICAgIH0K
CiAgUmVmZXJlbmNlKHMpOgogICAtIGh0dHBzOi8vZ2l0aHViLmNvbS9nb29nbGUvbGlicGhv
bmVudW1iZXIKCgoKAwQAARIDMggTCsUECgQEAAMAEgQ9AkgDGrYEIEFuIG9iamVjdCByZXBy
ZXNlbnRpbmcgYSBzaG9ydCBjb2RlLCB3aGljaCBpcyBhIHBob25lIG51bWJlciB0aGF0IGlz
CiB0eXBpY2FsbHkgbXVjaCBzaG9ydGVyIHRoYW4gcmVndWxhciBwaG9uZSBudW1iZXJzIGFu
ZCBjYW4gYmUgdXNlZCB0bwogYWRkcmVzcyBtZXNzYWdlcyBpbiBNTVMgYW5kIFNNUyBzeXN0
ZW1zLCBhcyB3ZWxsIGFzIGZvciBhYmJyZXZpYXRlZCBkaWFsaW5nCiAoRm9yIGV4YW1wbGUg
IlRleHQgNjExIHRvIHNlZSBob3cgbWFueSBtaW51dGVzIHlvdSBoYXZlIHJlbWFpbmluZyBv
biB5b3VyCiBwbGFuLiIpLgoKIFNob3J0IGNvZGVzIGFyZSByZXN0cmljdGVkIHRvIGEgcmVn
aW9uIGFuZCBhcmUgbm90IGludGVybmF0aW9uYWxseQogZGlhbGFibGUsIHdoaWNoIG1lYW5z
IHRoZSBzYW1lIHNob3J0IGNvZGUgY2FuIGV4aXN0IGluIGRpZmZlcmVudCByZWdpb25zLAog
d2l0aCBkaWZmZXJlbnQgdXNhZ2UgYW5kIHByaWNpbmcsIGV2ZW4gaWYgdGhvc2UgcmVnaW9u
cyBzaGFyZSB0aGUgc2FtZQogY291bnRyeSBjYWxsaW5nIGNvZGUgKEZvciBleGFtcGxlOiBV
UyBhbmQgQ0EpLgoKDAoFBAADAAESAz0KEwrVAQoGBAADAAIAEgNDBBsaxQEgUmVxdWlyZWQu
IFRoZSBCQ1AtNDcgcmVnaW9uIGNvZGUgb2YgdGhlIGxvY2F0aW9uIHdoZXJlIGNhbGxzIHRv
IHRoaXMKIHNob3J0IGNvZGUgY2FuIGJlIG1hZGUsIHN1Y2ggYXMgIlVTIiBhbmQgIkJCIi4K
CiBSZWZlcmVuY2Uocyk6CiAgLSBodHRwOi8vd3d3LnVuaWNvZGUub3JnL3JlcG9ydHMvdHIz
NS8jdW5pY29kZV9yZWdpb25fc3VidGFnCgoOCgcEAAMAAgAFEgNDBAoKDgoHBAADAAIAARID
QwsWCg4KBwQAAwACAAMSA0MZGgp7CgYEAAMAAgESA0cEFhpsIFJlcXVpcmVkLiBUaGUgc2hv
cnQgY29kZSBkaWdpdHMsIHdpdGhvdXQgYSBsZWFkaW5nIHBsdXMgKCcrJykgb3IgY291bnRy
eQogY2FsbGluZyBjb2RlLiBGb3IgZXhhbXBsZSAiNjExIi4KCg4KBwQAAwACAQUSA0cECgoO
CgcEAAMAAgEBEgNHCxEKDgoHBAADAAIBAxIDRxQVCuIBCgQEAAgAEgRNAmkDGtMBIFJlcXVp
cmVkLiAgRWl0aGVyIGEgcmVndWxhciBudW1iZXIsIG9yIGEgc2hvcnQgY29kZS4gIE5ldyBm
aWVsZHMgbWF5IGJlCiBhZGRlZCB0byB0aGUgb25lb2YgYmVsb3cgaW4gdGhlIGZ1dHVyZSwg
c28gY2xpZW50cyBzaG91bGQgaWdub3JlIHBob25lCiBudW1iZXJzIGZvciB3aGljaCBub25l
IG9mIHRoZSBmaWVsZHMgdGhleSBjb2RlZCBhZ2FpbnN0IGFyZSBzZXQuCgoMCgUEAAgAARID
TQgMCrsFCgQEAAIAEgNiBBsarQUgVGhlIHBob25lIG51bWJlciwgcmVwcmVzZW50ZWQgYXMg
YSBsZWFkaW5nIHBsdXMgc2lnbiAoJysnKSwgZm9sbG93ZWQgYnkgYQogcGhvbmUgbnVtYmVy
IHRoYXQgdXNlcyBhIHJlbGF4ZWQgSVRVIEUuMTY0IGZvcm1hdCBjb25zaXN0aW5nIG9mIHRo
ZQogY291bnRyeSBjYWxsaW5nIGNvZGUgKDEgdG8gMyBkaWdpdHMpIGFuZCB0aGUgc3Vic2Ny
aWJlciBudW1iZXIsIHdpdGggbm8KIGFkZGl0aW9uYWwgc3BhY2VzIG9yIGZvcm1hdHRpbmcu
IEZvciBleGFtcGxlOgoKICAtIGNvcnJlY3Q6ICIrMTU1NTIyMjAxMjMiCgogIC0gaW5jb3Jy
ZWN0OiAiKzEgKDU1NSkgMjIyLTAxMjM0IHgxMjMiCgogVGhlIElUVSBFLjE2NCBmb3JtYXQg
bGltaXRzIHRoZSBsYXR0ZXIgdG8gMTIgZGlnaXRzLCBidXQgaW4gcHJhY3RpY2Ugbm90CiBh
bGwgY291bnRyaWVzIHJlc3BlY3QgdGhhdCwgc28gd2UgcmVsYXggdGhhdCByZXN0cmljdGlv
biBoZXJlLgogTmF0aW9uYWwtb25seSBudW1iZXJzIGFyZSBub3QgYWxsb3dlZC4KCiBSZWZl
cmVuY2VzOgoKICAtIGh0dHBzOi8vd3d3Lml0dS5pbnQvcmVjL1QtUkVDLUUuMTY0LTIwMTAx
MS1JCgogIC0gaHR0cHM6Ly9lbi53aWtpcGVkaWEub3JnL3dpa2kvRS4xNjQuCgogIC0gaHR0
cHM6Ly9lbi53aWtpcGVkaWEub3JnL3dpa2kvTGlzdF9vZl9jb3VudHJ5X2NhbGxpbmdfY29k
ZXMKCgwKBQQAAgAFEgNiBAoKDAoFBAACAAESA2ILFgoMCgUEAAIAAxIDYhkaClYKBAQAAgES
A2gEHRpJIEEgc2hvcnQgY29kZS4KCiBSZWZlcmVuY2Uocyk6CiAgLSBodHRwczovL3dpa2lw
ZWRpYS5vcmcvd2lraS9TaG9ydF9jb2RlCgoMCgUEAAIBBhIDaAQNCgwKBQQAAgEBEgNoDhgK
DAoFBAACAQMSA2gbHAqVBAoEBAACAhIDdAIXGocEIFRoZSBwaG9uZSBudW1iZXIncyBleHRl
bnNpb24uIFRoZSBleHRlbnNpb24gaXMgbm90IHN0YW5kYXJkaXplZCBpbiBJVFUKIHJlY29t
bWVuZGF0aW9ucywgZXhjZXB0IGZvciBiZWluZyBkZWZpbmVkIGFzIGEgc2VyaWVzIG9mIG51
bWJlcnMgd2l0aCBhCiBtYXhpbXVtIGxlbmd0aCBvZiA0MCBkaWdpdHMuIE90aGVyIHRoYW4g
ZGlnaXRzLCBzb21lIG90aGVyIGRpYWxpbmcKIGNoYXJhY3RlcnMgc3VjaCBhcyAnLCcgKGlu
ZGljYXRpbmcgYSB3YWl0KSBvciAnIycgbWF5IGJlIHN0b3JlZCBoZXJlLgoKIE5vdGUgdGhh
dCBubyByZWdpb25zIGN1cnJlbnRseSB1c2UgZXh0ZW5zaW9ucyB3aXRoIHNob3J0IGNvZGVz
LCBzbyB0aGlzCiBmaWVsZCBpcyBub3JtYWxseSBvbmx5IHNldCBpbiBjb25qdW5jdGlvbiB3
aXRoIGFuIEUuMTY0IG51bWJlci4gSXQgaXMgaGVsZAogc2VwYXJhdGVseSBmcm9tIHRoZSBF
LjE2NCBudW1iZXIgdG8gYWxsb3cgZm9yIHNob3J0IGNvZGUgZXh0ZW5zaW9ucyBpbiB0aGUK
IGZ1dHVyZS4KCgwKBQQAAgIFEgN0AggKDAoFBAACAgESA3QJEgoMCgUEAAICAxIDdBUWYgZw
cm90bzM=
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Type::PhoneNumber::PhoneNumber ===
    # Fields for PhoneNumber
    # Field: e164_number Type: 9 ()
    # Field: short_code Type: 11 (.google.type.PhoneNumber.ShortCode)
    # Field: extension Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Type::PhoneNumber - Compiled Protocol Buffers messages for google/type/phone_number.proto

=head1 SYNOPSIS

    use Google::Type::PhoneNumber;

    my $msg = Google::Type::PhoneNumber::PhoneNumber->new({
        e164_number => $e164_number,
        short_code => $short_code,
        extension => $extension,
    });

    # Read or update a field
    my $val = $msg->e164_number();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Type::PhoneNumber::PhoneNumber->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/type/phone_number.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Type::PhoneNumber::PhoneNumber

An object representing a phone number, suitable as an API wire format.

This representation:

 - should not be used for locale-specific formatting of a phone number, such
   as "+1 (650) 253-0000 ext. 123"

 - is not designed for efficient storage
 - may not be suitable for dialing - specialized libraries (see references)
   should be used to parse the number for that purpose

To do something meaningful with this number, such as format it for various
use-cases, convert it to an `i18n.phonenumbers.PhoneNumber` object first.

For instance, in Java this would be:

    com.google.type.PhoneNumber wireProto =
        com.google.type.PhoneNumber.newBuilder().build();
    com.google.i18n.phonenumbers.Phonenumber.PhoneNumber phoneNumber =
        PhoneNumberUtil.getInstance().parse(wireProto.getE164Number(), "ZZ");
    if (!wireProto.getExtension().isEmpty()) {
      phoneNumber.setExtension(wireProto.getExtension());
    }

 Reference(s):
  - https://github.com/google/libphonenumber

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->e164_number() >> / C<< $msg->e164_number($value) >>

Type: C<String>

The phone number, represented as a leading plus sign ('+'), followed by a
phone number that uses a relaxed ITU E.164 format consisting of the
country calling code (1 to 3 digits) and the subscriber number, with no
additional spaces or formatting. For example:

 - correct: "+15552220123"

 - incorrect: "+1 (555) 222-01234 x123"

The ITU E.164 format limits the latter to 12 digits, but in practice not
all countries respect that, so we relax that restriction here.
National-only numbers are not allowed.

References:

 - https://www.itu.int/rec/T-REC-E.164-201011-I

 - https://en.wikipedia.org/wiki/E.164.

 - https://en.wikipedia.org/wiki/List_of_country_calling_codes

=item * C<< $msg->short_code() >> / C<< $msg->short_code($value) >>

Type: C<Message> (L<Google::Type::PhoneNumber::PhoneNumber::ShortCode>)

A short code.

Reference(s):
 - https://wikipedia.org/wiki/Short_code

=item * C<< $msg->extension() >> / C<< $msg->extension($value) >>

Type: C<String>

The phone number's extension. The extension is not standardized in ITU
recommendations, except for being defined as a series of numbers with a
maximum length of 40 digits. Other than digits, some other dialing
characters such as ',' (indicating a wait) or '#' may be stored here.

Note that no regions currently use extensions with short codes, so this
field is normally only set in conjunction with an E.164 number. It is held
separately from the E.164 number to allow for short code extensions in the
future.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Type::PhoneNumber::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

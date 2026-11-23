package Google::Type::Quaternion;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Chxnb29nbGUvdHlwZS9xdWF0ZXJuaW9uLnByb3RvEgtnb29nbGUudHlwZSJECgpRdWF0ZXJu
aW9uEgwKAXgYASABKAFSAXgSDAoBeRgCIAEoAVIBeRIMCgF6GAMgASgBUgF6EgwKAXcYBCAB
KAFSAXdCbAoPY29tLmdvb2dsZS50eXBlQg9RdWF0ZXJuaW9uUHJvdG9QAVpAZ29vZ2xlLmdv
bGFuZy5vcmcvZ2VucHJvdG8vZ29vZ2xlYXBpcy90eXBlL3F1YXRlcm5pb247cXVhdGVybmlv
bqICA0dUUEriHAoGEgQOAF0BCrwECgEMEgMOABIysQQgQ29weXJpZ2h0IDIwMjYgR29vZ2xl
IExMQwoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAg
KHRoZSAiTGljZW5zZSIpOwogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4g
Y29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLgogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9m
IHRoZSBMaWNlbnNlIGF0CgogICAgIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9M
SUNFTlNFLTIuMAoKIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3Jl
ZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUKIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNl
bnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuICJBUyBJUyIgQkFTSVMsCiBXSVRIT1VUIFdBUlJB
TlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1w
bGllZC4KIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVy
bmluZyBwZXJtaXNzaW9ucyBhbmQKIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLgoK
CAoBAhIDEAAUCggKAQgSAxIAVwoJCgIICxIDEgBXCggKAQgSAxMAIgoJCgIIChIDEwAiCggK
AQgSAxQAMAoJCgIICBIDFAAwCggKAQgSAxUAKAoJCgIIARIDFQAoCggKAQgSAxYAIQoJCgII
JBIDFgAhCugUCgIEABIEUQBdARrbFCBBIHF1YXRlcm5pb24sIHJlcHJlc2VudGVkIGJ5IGZv
dXIgNjQtYml0IGZsb2F0aW5nIHBvaW50IHZhbHVlcy4KCiBBIHF1YXRlcm5pb24gaXMgZGVm
aW5lZCBhcyB0aGUgcXVvdGllbnQgb2YgdHdvIGRpcmVjdGVkIGxpbmVzIGluIGEKIHRocmVl
LWRpbWVuc2lvbmFsIHNwYWNlIG9yIGVxdWl2YWxlbnRseSBhcyB0aGUgcXVvdGllbnQgb2Yg
dHdvIEV1Y2xpZGVhbgogdmVjdG9ycyAoaHR0cHM6Ly9lbi53aWtpcGVkaWEub3JnL3dpa2kv
UXVhdGVybmlvbikuCgogUXVhdGVybmlvbnMgYXJlIG9mdGVuIHVzZWQgaW4gY2FsY3VsYXRp
b25zIGludm9sdmluZyB0aHJlZS1kaW1lbnNpb25hbAogcm90YXRpb25zIChodHRwczovL2Vu
Lndpa2lwZWRpYS5vcmcvd2lraS9RdWF0ZXJuaW9uc19hbmRfc3BhdGlhbF9yb3RhdGlvbiks
CiBhcyB0aGV5IHByb3ZpZGUgZ3JlYXRlciBtYXRoZW1hdGljYWwgcm9idXN0bmVzcyBieSBh
dm9pZGluZyB0aGUgZ2ltYmFsIGxvY2sKIHByb2JsZW1zIHRoYXQgY2FuIGJlIGVuY291bnRl
cmVkIHdoZW4gdXNpbmcgRXVsZXIgYW5nbGVzCiAoaHR0cHM6Ly9lbi53aWtpcGVkaWEub3Jn
L3dpa2kvR2ltYmFsX2xvY2spLgoKIFF1YXRlcm5pb25zIGFyZSBnZW5lcmFsbHkgcmVwcmVz
ZW50ZWQgaW4gdGhpcyBmb3JtOgoKICAgICB3ICsgeGkgKyB5aiArIHprCgogd2hlcmUgeCwg
eSwgeiwgYW5kIHcgYXJlIHJlYWwgbnVtYmVycywgYW5kIGksIGosIGFuZCBrIGFyZSB0aHJl
ZSBpbWFnaW5hcnkKIG51bWJlcnMuCgogVGhlIG5hbWluZyBjaG9pY2UgYCh4LCB5LCB6LCB3
KWAgY29tZXMgZnJvbSB0aGUgZGVzaXJlIHRvIGF2b2lkIGNvbmZ1c2lvbiBmb3IKIHRob3Nl
IGludGVyZXN0ZWQgaW4gdGhlIGdlb21ldHJpYyBwcm9wZXJ0aWVzIG9mIHRoZSBxdWF0ZXJu
aW9uIGluIHRoZSAzRAogQ2FydGVzaWFuIHNwYWNlLiBPdGhlciB0ZXh0cyBvZnRlbiB1c2Ug
YWx0ZXJuYXRpdmUgbmFtZXMgb3Igc3Vic2NyaXB0cywgc3VjaAogYXMgYChhLCBiLCBjLCBk
KWAsIGAoMSwgaSwgaiwgaylgLCBvciBgKDAsIDEsIDIsIDMpYCwgd2hpY2ggYXJlIHBlcmhh
cHMKIGJldHRlciBzdWl0ZWQgZm9yIG1hdGhlbWF0aWNhbCBpbnRlcnByZXRhdGlvbnMuCgog
VG8gYXZvaWQgYW55IGNvbmZ1c2lvbiwgYXMgd2VsbCBhcyB0byBtYWludGFpbiBjb21wYXRp
YmlsaXR5IHdpdGggYSBsYXJnZQogbnVtYmVyIG9mIHNvZnR3YXJlIGxpYnJhcmllcywgdGhl
IHF1YXRlcm5pb25zIHJlcHJlc2VudGVkIHVzaW5nIHRoZSBwcm90b2NvbAogYnVmZmVyIGJl
bG93ICptdXN0KiBmb2xsb3cgdGhlIEhhbWlsdG9uIGNvbnZlbnRpb24sIHdoaWNoIGRlZmlu
ZXMgYGlqID0ga2AKIChpLmUuIGEgcmlnaHQtaGFuZGVkIGFsZ2VicmEpLCBhbmQgdGhlcmVm
b3JlOgoKICAgICBpXjIgPSBqXjIgPSBrXjIgPSBpamsgPSDiiJIxCiAgICAgaWogPSDiiJJq
aSA9IGsKICAgICBqayA9IOKIkmtqID0gaQogICAgIGtpID0g4oiSaWsgPSBqCgogUGxlYXNl
IERPIE5PVCB1c2UgdGhpcyB0byByZXByZXNlbnQgcXVhdGVybmlvbnMgdGhhdCBmb2xsb3cg
dGhlIEpQTAogY29udmVudGlvbiwgb3IgYW55IG9mIHRoZSBvdGhlciBxdWF0ZXJuaW9uIGZs
YXZvcnMgb3V0IHRoZXJlLgoKIERlZmluaXRpb25zOgoKICAgLSBRdWF0ZXJuaW9uIG5vcm0g
KG9yIG1hZ25pdHVkZSk6IGBzcXJ0KHheMiArIHleMiArIHpeMiArIHdeMilgLgogICAtIFVu
aXQgKG9yIG5vcm1hbGl6ZWQpIHF1YXRlcm5pb246IGEgcXVhdGVybmlvbiB3aG9zZSBub3Jt
IGlzIDEuCiAgIC0gUHVyZSBxdWF0ZXJuaW9uOiBhIHF1YXRlcm5pb24gd2hvc2Ugc2NhbGFy
IGNvbXBvbmVudCAoYHdgKSBpcyAwLgogICAtIFJvdGF0aW9uIHF1YXRlcm5pb246IGEgdW5p
dCBxdWF0ZXJuaW9uIHVzZWQgdG8gcmVwcmVzZW50IHJvdGF0aW9uLgogICAtIE9yaWVudGF0
aW9uIHF1YXRlcm5pb246IGEgdW5pdCBxdWF0ZXJuaW9uIHVzZWQgdG8gcmVwcmVzZW50IG9y
aWVudGF0aW9uLgoKIEEgcXVhdGVybmlvbiBjYW4gYmUgbm9ybWFsaXplZCBieSBkaXZpZGlu
ZyBpdCBieSBpdHMgbm9ybS4gVGhlIHJlc3VsdGluZwogcXVhdGVybmlvbiBtYWludGFpbnMg
dGhlIHNhbWUgZGlyZWN0aW9uLCBidXQgaGFzIGEgbm9ybSBvZiAxLCBpLmUuIGl0IG1vdmVz
CiBvbiB0aGUgdW5pdCBzcGhlcmUuIFRoaXMgaXMgZ2VuZXJhbGx5IG5lY2Vzc2FyeSBmb3Ig
cm90YXRpb24gYW5kIG9yaWVudGF0aW9uCiBxdWF0ZXJuaW9ucywgdG8gYXZvaWQgcm91bmRp
bmcgZXJyb3JzOgogaHR0cHM6Ly9lbi53aWtpcGVkaWEub3JnL3dpa2kvUm90YXRpb25fZm9y
bWFsaXNtc19pbl90aHJlZV9kaW1lbnNpb25zCgogTm90ZSB0aGF0IGAoeCwgeSwgeiwgdylg
IGFuZCBgKC14LCAteSwgLXosIC13KWAgcmVwcmVzZW50IHRoZSBzYW1lIHJvdGF0aW9uLAog
YnV0IG5vcm1hbGl6YXRpb24gd291bGQgYmUgZXZlbiBtb3JlIHVzZWZ1bCwgZS5nLiBmb3Ig
Y29tcGFyaXNvbiBwdXJwb3NlcywgaWYKIGl0IHdvdWxkIHByb2R1Y2UgYSB1bmlxdWUgcmVw
cmVzZW50YXRpb24uIEl0IGlzIHRodXMgcmVjb21tZW5kZWQgdGhhdCBgd2AgYmUKIGtlcHQg
cG9zaXRpdmUsIHdoaWNoIGNhbiBiZSBhY2hpZXZlZCBieSBjaGFuZ2luZyBhbGwgdGhlIHNp
Z25zIHdoZW4gYHdgIGlzCiBuZWdhdGl2ZS4KCgoKAwQAARIDUQgSCh8KBAQAAgASA1MCDxoS
IFRoZSB4IGNvbXBvbmVudC4KCgwKBQQAAgAFEgNTAggKDAoFBAACAAESA1MJCgoMCgUEAAIA
AxIDUw0OCh8KBAQAAgESA1YCDxoSIFRoZSB5IGNvbXBvbmVudC4KCgwKBQQAAgEFEgNWAggK
DAoFBAACAQESA1YJCgoMCgUEAAIBAxIDVg0OCh8KBAQAAgISA1kCDxoSIFRoZSB6IGNvbXBv
bmVudC4KCgwKBQQAAgIFEgNZAggKDAoFBAACAgESA1kJCgoMCgUEAAICAxIDWQ0OCiQKBAQA
AgMSA1wCDxoXIFRoZSBzY2FsYXIgY29tcG9uZW50LgoKDAoFBAACAwUSA1wCCAoMCgUEAAID
ARIDXAkKCgwKBQQAAgMDEgNcDQ5iBnByb3RvMw==
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Type::Quaternion::Quaternion ===
    # Fields for Quaternion
    # Field: x Type: 1 ()
    # Field: y Type: 1 ()
    # Field: z Type: 1 ()
    # Field: w Type: 1 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Type::Quaternion - Compiled Protocol Buffers messages for google/type/quaternion.proto

=head1 SYNOPSIS

    use Google::Type::Quaternion;

    my $msg = Google::Type::Quaternion::Quaternion->new({
        x => $x,
        y => $y,
        z => $z,
        w => $w,
    });

    # Read or update a field
    my $val = $msg->x();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Type::Quaternion::Quaternion->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/type/quaternion.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Type::Quaternion::Quaternion

A quaternion, represented by four 64-bit floating point values.

A quaternion is defined as the quotient of two directed lines in a
three-dimensional space or equivalently as the quotient of two Euclidean
vectors (https://en.wikipedia.org/wiki/Quaternion).

Quaternions are often used in calculations involving three-dimensional
rotations (https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation),
as they provide greater mathematical robustness by avoiding the gimbal lock
problems that can be encountered when using Euler angles
(https://en.wikipedia.org/wiki/Gimbal_lock).

Quaternions are generally represented in this form:

    w + xi + yj + zk

where x, y, z, and w are real numbers, and i, j, and k are three imaginary
numbers.

The naming choice `(x, y, z, w)` comes from the desire to avoid confusion for
those interested in the geometric properties of the quaternion in the 3D
Cartesian space. Other texts often use alternative names or subscripts, such
as `(a, b, c, d)`, `(1, i, j, k)`, or `(0, 1, 2, 3)`, which are perhaps
better suited for mathematical interpretations.

To avoid any confusion, as well as to maintain compatibility with a large
number of software libraries, the quaternions represented using the protocol
buffer below *must* follow the Hamilton convention, which defines `ij = k`
(i.e. a right-handed algebra), and therefore:

    i^2 = j^2 = k^2 = ijk = −1
    ij = −ji = k
    jk = −kj = i
    ki = −ik = j

Please DO NOT use this to represent quaternions that follow the JPL
convention, or any of the other quaternion flavors out there.

Definitions:

  - Quaternion norm (or magnitude): `sqrt(x^2 + y^2 + z^2 + w^2)`.
  - Unit (or normalized) quaternion: a quaternion whose norm is 1.
  - Pure quaternion: a quaternion whose scalar component (`w`) is 0.
  - Rotation quaternion: a unit quaternion used to represent rotation.
  - Orientation quaternion: a unit quaternion used to represent orientation.

A quaternion can be normalized by dividing it by its norm. The resulting
quaternion maintains the same direction, but has a norm of 1, i.e. it moves
on the unit sphere. This is generally necessary for rotation and orientation
quaternions, to avoid rounding errors:
https://en.wikipedia.org/wiki/Rotation_formalisms_in_three_dimensions

Note that `(x, y, z, w)` and `(-x, -y, -z, -w)` represent the same rotation,
but normalization would be even more useful, e.g. for comparison purposes, if
it would produce a unique representation. It is thus recommended that `w` be
kept positive, which can be achieved by changing all the signs when `w` is
negative.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->x() >> / C<< $msg->x($value) >>

Type: C<Double>

The x component.

=item * C<< $msg->y() >> / C<< $msg->y($value) >>

Type: C<Double>

The y component.

=item * C<< $msg->z() >> / C<< $msg->z($value) >>

Type: C<Double>

The z component.

=item * C<< $msg->w() >> / C<< $msg->w($value) >>

Type: C<Double>

The scalar component.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Type::Quaternion::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

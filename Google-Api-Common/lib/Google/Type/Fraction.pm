package Google::Type::Fraction;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Chpnb29nbGUvdHlwZS9mcmFjdGlvbi5wcm90bxILZ29vZ2xlLnR5cGUiSgoIRnJhY3Rpb24S
HAoJbnVtZXJhdG9yGAEgASgDUgludW1lcmF0b3ISIAoLZGVub21pbmF0b3IYAiABKANSC2Rl
bm9taW5hdG9yQmYKD2NvbS5nb29nbGUudHlwZUINRnJhY3Rpb25Qcm90b1ABWjxnb29nbGUu
Z29sYW5nLm9yZy9nZW5wcm90by9nb29nbGVhcGlzL3R5cGUvZnJhY3Rpb247ZnJhY3Rpb26i
AgNHVFBKjggKBhIEDgAgAQq8BAoBDBIDDgASMrEEIENvcHlyaWdodCAyMDI2IEdvb2dsZSBM
TEMKCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0
aGUgIkxpY2Vuc2UiKTsKIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNv
bXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS4KIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0
aGUgTGljZW5zZSBhdAoKICAgICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElD
RU5TRS0yLjAKCiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVk
IHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlCiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5z
ZSBpcyBkaXN0cmlidXRlZCBvbiBhbiAiQVMgSVMiIEJBU0lTLAogV0lUSE9VVCBXQVJSQU5U
SUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxp
ZWQuCiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5p
bmcgcGVybWlzc2lvbnMgYW5kCiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS4KCggK
AQISAxAAFAoICgEIEgMSAFMKCQoCCAsSAxIAUwoICgEIEgMTACIKCQoCCAoSAxMAIgoICgEI
EgMUAC4KCQoCCAgSAxQALgoICgEIEgMVACgKCQoCCAESAxUAKAoICgEIEgMWACEKCQoCCCQS
AxYAIQpVCgIEABIEGQAgARpJIFJlcHJlc2VudHMgYSBmcmFjdGlvbiBpbiB0ZXJtcyBvZiBh
IG51bWVyYXRvciBkaXZpZGVkIGJ5IGEgZGVub21pbmF0b3IuCgoKCgMEAAESAxkIEAo8CgQE
AAIAEgMbAhYaLyBUaGUgbnVtZXJhdG9yIGluIHRoZSBmcmFjdGlvbiwgZS5nLiAyIGluIDIv
My4KCgwKBQQAAgAFEgMbAgcKDAoFBAACAAESAxsIEQoMCgUEAAIAAxIDGxQVCl0KBAQAAgES
Ax8CGBpQIFRoZSB2YWx1ZSBieSB3aGljaCB0aGUgbnVtZXJhdG9yIGlzIGRpdmlkZWQsIGUu
Zy4gMyBpbiAyLzMuIE11c3QgYmUKIHBvc2l0aXZlLgoKDAoFBAACAQUSAx8CBwoMCgUEAAIB
ARIDHwgTCgwKBQQAAgEDEgMfFhdiBnByb3RvMw==
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Type::Fraction::Fraction ===
    # Fields for Fraction
    # Field: numerator Type: 3 ()
    # Field: denominator Type: 3 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Type::Fraction - Compiled Protocol Buffers messages for google/type/fraction.proto

=head1 SYNOPSIS

    use Google::Type::Fraction;

    my $msg = Google::Type::Fraction::Fraction->new({
        numerator => $numerator,
        denominator => $denominator,
    });

    # Read or update a field
    my $val = $msg->numerator();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Type::Fraction::Fraction->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/type/fraction.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Type::Fraction::Fraction

Represents a fraction in terms of a numerator divided by a denominator.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->numerator() >> / C<< $msg->numerator($value) >>

Type: C<Int64>

The numerator in the fraction, e.g. 2 in 2/3.

=item * C<< $msg->denominator() >> / C<< $msg->denominator($value) >>

Type: C<Int64>

The value by which the numerator is divided, e.g. 3 in 2/3. Must be
positive.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Type::Fraction::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

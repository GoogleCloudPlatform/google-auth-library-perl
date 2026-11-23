package Google::Type::Decimal;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Chlnb29nbGUvdHlwZS9kZWNpbWFsLnByb3RvEgtnb29nbGUudHlwZSIfCgdEZWNpbWFsEhQK
BXZhbHVlGAEgASgJUgV2YWx1ZUJjCg9jb20uZ29vZ2xlLnR5cGVCDERlY2ltYWxQcm90b1AB
Wjpnb29nbGUuZ29sYW5nLm9yZy9nZW5wcm90by9nb29nbGVhcGlzL3R5cGUvZGVjaW1hbDtk
ZWNpbWFsogIDR1RQSoceCgYSBA4AXAEKvAQKAQwSAw4AEjKxBCBDb3B5cmlnaHQgMjAyNiBH
b29nbGUgTExDCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9u
IDIuMCAodGhlICJMaWNlbnNlIik7CiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2Vw
dCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuCiBZb3UgbWF5IG9idGFpbiBhIGNv
cHkgb2YgdGhlIExpY2Vuc2UgYXQKCiAgICAgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vu
c2VzL0xJQ0VOU0UtMi4wCgogVW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9y
IGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZQogZGlzdHJpYnV0ZWQgdW5kZXIgdGhl
IExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKIFdJVEhPVVQg
V0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBv
ciBpbXBsaWVkLgogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2Ug
Z292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZAogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vu
c2UuCgoICgECEgMQABQKCAoBCBIDEgBRCgkKAggLEgMSAFEKCAoBCBIDEwAiCgkKAggKEgMT
ACIKCAoBCBIDFAAtCgkKAggIEgMUAC0KCAoBCBIDFQAoCgkKAggBEgMVACgKCAoBCBIDFgAh
CgkKAggkEgMWACEKyAIKAgQAEgQdAFwBGrsCIEEgcmVwcmVzZW50YXRpb24gb2YgYSBkZWNp
bWFsIHZhbHVlLCBzdWNoIGFzIDIuNS4gQ2xpZW50cyBtYXkgY29udmVydCB2YWx1ZXMKIGlu
dG8gbGFuZ3VhZ2UtbmF0aXZlIGRlY2ltYWwgZm9ybWF0cywgc3VjaCBhcyBKYXZhJ3MKIFtC
aWdEZWNpbWFsXShodHRwczovL2RvY3Mub3JhY2xlLmNvbS9lbi9qYXZhL2phdmFzZS8xMS9k
b2NzL2FwaS9qYXZhLmJhc2UvamF2YS9tYXRoL0JpZ0RlY2ltYWwuaHRtbCkKIG9yIFB5dGhv
bidzCiBbZGVjaW1hbC5EZWNpbWFsXShodHRwczovL2RvY3MucHl0aG9uLm9yZy8zL2xpYnJh
cnkvZGVjaW1hbC5odG1sKS4KCgoKAwQAARIDHQgPCskVCgQEAAIAEgNbAhMauxUgVGhlIGRl
Y2ltYWwgdmFsdWUsIGFzIGEgc3RyaW5nLgoKIFRoZSBzdHJpbmcgcmVwcmVzZW50YXRpb24g
Y29uc2lzdHMgb2YgYW4gb3B0aW9uYWwgc2lnbiwgYCtgIChgVSswMDJCYCkKIG9yIGAtYCAo
YFUrMDAyRGApLCBmb2xsb3dlZCBieSBhIHNlcXVlbmNlIG9mIHplcm8gb3IgbW9yZSBkZWNp
bWFsIGRpZ2l0cwogKCJ0aGUgaW50ZWdlciIpLCBvcHRpb25hbGx5IGZvbGxvd2VkIGJ5IGEg
ZnJhY3Rpb24sIG9wdGlvbmFsbHkgZm9sbG93ZWQKIGJ5IGFuIGV4cG9uZW50LiBBbiBlbXB0
eSBzdHJpbmcgKipzaG91bGQqKiBiZSBpbnRlcnByZXRlZCBhcyBgMGAuCgogVGhlIGZyYWN0
aW9uIGNvbnNpc3RzIG9mIGEgZGVjaW1hbCBwb2ludCBmb2xsb3dlZCBieSB6ZXJvIG9yIG1v
cmUgZGVjaW1hbAogZGlnaXRzLiBUaGUgc3RyaW5nIG11c3QgY29udGFpbiBhdCBsZWFzdCBv
bmUgZGlnaXQgaW4gZWl0aGVyIHRoZSBpbnRlZ2VyCiBvciB0aGUgZnJhY3Rpb24uIFRoZSBu
dW1iZXIgZm9ybWVkIGJ5IHRoZSBzaWduLCB0aGUgaW50ZWdlciBhbmQgdGhlCiBmcmFjdGlv
biBpcyByZWZlcnJlZCB0byBhcyB0aGUgc2lnbmlmaWNhbmQuCgogVGhlIGV4cG9uZW50IGNv
bnNpc3RzIG9mIHRoZSBjaGFyYWN0ZXIgYGVgIChgVSswMDY1YCkgb3IgYEVgIChgVSswMDQ1
YCkKIGZvbGxvd2VkIGJ5IG9uZSBvciBtb3JlIGRlY2ltYWwgZGlnaXRzLgoKIFNlcnZpY2Vz
ICoqc2hvdWxkKiogbm9ybWFsaXplIGRlY2ltYWwgdmFsdWVzIGJlZm9yZSBzdG9yaW5nIHRo
ZW0gYnk6CgogICAtIFJlbW92aW5nIGFuIGV4cGxpY2l0bHktcHJvdmlkZWQgYCtgIHNpZ24g
KGArMi41YCAtPiBgMi41YCkuCiAgIC0gUmVwbGFjaW5nIGEgemVyby1sZW5ndGggaW50ZWdl
ciB2YWx1ZSB3aXRoIGAwYCAoYC41YCAtPiBgMC41YCkuCiAgIC0gQ29lcmNpbmcgdGhlIGV4
cG9uZW50IGNoYXJhY3RlciB0byB1cHBlci1jYXNlLCB3aXRoIGV4cGxpY2l0IHNpZ24KICAg
ICAoYDIuNWU4YCAtPiBgMi41RSs4YCkuCiAgIC0gUmVtb3ZpbmcgYW4gZXhwbGljaXRseS1w
cm92aWRlZCB6ZXJvIGV4cG9uZW50IChgMi41RTBgIC0+IGAyLjVgKS4KCiBTZXJ2aWNlcyAq
Km1heSoqIHBlcmZvcm0gYWRkaXRpb25hbCBub3JtYWxpemF0aW9uIGJhc2VkIG9uIGl0cyBv
d24gbmVlZHMKIGFuZCB0aGUgaW50ZXJuYWwgZGVjaW1hbCBpbXBsZW1lbnRhdGlvbiBzZWxl
Y3RlZCwgc3VjaCBhcyBzaGlmdGluZyB0aGUKIGRlY2ltYWwgcG9pbnQgYW5kIGV4cG9uZW50
IHZhbHVlIHRvZ2V0aGVyIChleGFtcGxlOiBgMi41RS0xYCA8LT4gYDAuMjVgKS4KIEFkZGl0
aW9uYWxseSwgc2VydmljZXMgKiptYXkqKiBwcmVzZXJ2ZSB0cmFpbGluZyB6ZXJvZXMgaW4g
dGhlIGZyYWN0aW9uCiB0byBpbmRpY2F0ZSBpbmNyZWFzZWQgcHJlY2lzaW9uLCBidXQgYXJl
IG5vdCByZXF1aXJlZCB0byBkbyBzby4KCiBOb3RlIHRoYXQgb25seSB0aGUgYC5gIGNoYXJh
Y3RlciBpcyBzdXBwb3J0ZWQgdG8gZGl2aWRlIHRoZSBpbnRlZ2VyCiBhbmQgdGhlIGZyYWN0
aW9uOyBgLGAgKipzaG91bGQgbm90KiogYmUgc3VwcG9ydGVkIHJlZ2FyZGxlc3Mgb2YgbG9j
YWxlLgogQWRkaXRpb25hbGx5LCB0aG91c2FuZCBzZXBhcmF0b3JzICoqc2hvdWxkIG5vdCoq
IGJlIHN1cHBvcnRlZC4gSWYgYQogc2VydmljZSBkb2VzIHN1cHBvcnQgdGhlbSwgdmFsdWVz
ICoqbXVzdCoqIGJlIG5vcm1hbGl6ZWQuCgogVGhlIEVOQkYgZ3JhbW1hciBpczoKCiAgICAg
RGVjaW1hbFN0cmluZyA9CiAgICAgICAnJyB8IFtTaWduXSBTaWduaWZpY2FuZCBbRXhwb25l
bnRdOwoKICAgICBTaWduID0gJysnIHwgJy0nOwoKICAgICBTaWduaWZpY2FuZCA9CiAgICAg
ICBEaWdpdHMgWycuJ10gW0RpZ2l0c10gfCBbRGlnaXRzXSAnLicgRGlnaXRzOwoKICAgICBF
eHBvbmVudCA9ICgnZScgfCAnRScpIFtTaWduXSBEaWdpdHM7CgogICAgIERpZ2l0cyA9IHsg
JzAnIHwgJzEnIHwgJzInIHwgJzMnIHwgJzQnIHwgJzUnIHwgJzYnIHwgJzcnIHwgJzgnIHwg
JzknIH07CgogU2VydmljZXMgKipzaG91bGQqKiBjbGVhcmx5IGRvY3VtZW50IHRoZSByYW5n
ZSBvZiBzdXBwb3J0ZWQgdmFsdWVzLCB0aGUKIG1heGltdW0gc3VwcG9ydGVkIHByZWNpc2lv
biAodG90YWwgbnVtYmVyIG9mIGRpZ2l0cyksIGFuZCwgaWYgYXBwbGljYWJsZSwKIHRoZSBz
Y2FsZSAobnVtYmVyIG9mIGRpZ2l0cyBhZnRlciB0aGUgZGVjaW1hbCBwb2ludCksIGFzIHdl
bGwgYXMgaG93IGl0CiBiZWhhdmVzIHdoZW4gcmVjZWl2aW5nIG91dC1vZi1ib3VuZHMgdmFs
dWVzLgoKIFNlcnZpY2VzICoqbWF5KiogY2hvb3NlIHRvIGFjY2VwdCB2YWx1ZXMgcGFzc2Vk
IGFzIGlucHV0IGV2ZW4gd2hlbiB0aGUKIHZhbHVlIGhhcyBhIGhpZ2hlciBwcmVjaXNpb24g
b3Igc2NhbGUgdGhhbiB0aGUgc2VydmljZSBzdXBwb3J0cywgYW5kCiAqKnNob3VsZCoqIHJv
dW5kIHRoZSB2YWx1ZSB0byBmaXQgdGhlIHN1cHBvcnRlZCBzY2FsZS4gQWx0ZXJuYXRpdmVs
eSwgdGhlCiBzZXJ2aWNlICoqbWF5KiogZXJyb3Igd2l0aCBgNDAwIEJhZCBSZXF1ZXN0YCAo
YElOVkFMSURfQVJHVU1FTlRgIGluIGdSUEMpCiBpZiBwcmVjaXNpb24gd291bGQgYmUgbG9z
dC4KCiBTZXJ2aWNlcyAqKnNob3VsZCoqIGVycm9yIHdpdGggYDQwMCBCYWQgUmVxdWVzdGAg
KGBJTlZBTElEX0FSR1VNRU5UYCBpbgogZ1JQQykgaWYgdGhlIHNlcnZpY2UgcmVjZWl2ZXMg
YSB2YWx1ZSBvdXRzaWRlIG9mIHRoZSBzdXBwb3J0ZWQgcmFuZ2UuCgoMCgUEAAIABRIDWwII
CgwKBQQAAgABEgNbCQ4KDAoFBAACAAMSA1sREmIGcHJvdG8z
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Type::Decimal::Decimal ===
    # Fields for Decimal
    # Field: value Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Type::Decimal - Compiled Protocol Buffers messages for google/type/decimal.proto

=head1 SYNOPSIS

    use Google::Type::Decimal;

    my $msg = Google::Type::Decimal::Decimal->new({
        value => $value,
    });

    # Read or update a field
    my $val = $msg->value();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Type::Decimal::Decimal->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/type/decimal.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Type::Decimal::Decimal

A representation of a decimal value, such as 2.5. Clients may convert values
into language-native decimal formats, such as Java's
[BigDecimal](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/math/BigDecimal.html)
or Python's
[decimal.Decimal](https://docs.python.org/3/library/decimal.html).

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->value() >> / C<< $msg->value($value) >>

Type: C<String>

The decimal value, as a string.

The string representation consists of an optional sign, `+` (`U+002B`)
or `-` (`U+002D`), followed by a sequence of zero or more decimal digits
("the integer"), optionally followed by a fraction, optionally followed
by an exponent. An empty string B<should> be interpreted as `0`.

The fraction consists of a decimal point followed by zero or more decimal
digits. The string must contain at least one digit in either the integer
or the fraction. The number formed by the sign, the integer and the
fraction is referred to as the significand.

The exponent consists of the character `e` (`U+0065`) or `E` (`U+0045`)
followed by one or more decimal digits.

Services B<should> normalize decimal values before storing them by:

  - Removing an explicitly-provided `+` sign (`+2.5` -> `2.5`).
  - Replacing a zero-length integer value with `0` (`.5` -> `0.5`).
  - Coercing the exponent character to upper-case, with explicit sign
    (`2.5e8` -> `2.5E+8`).
  - Removing an explicitly-provided zero exponent (`2.5E0` -> `2.5`).

Services B<may> perform additional normalization based on its own needs
and the internal decimal implementation selected, such as shifting the
decimal point and exponent value together (example: `2.5E-1` <-> `0.25`).
Additionally, services B<may> preserve trailing zeroes in the fraction
to indicate increased precision, but are not required to do so.

Note that only the `.` character is supported to divide the integer
and the fraction; `,` B<should not> be supported regardless of locale.
Additionally, thousand separators B<should not> be supported. If a
service does support them, values B<must> be normalized.

The ENBF grammar is:

    DecimalString =
      '' | [Sign] Significand [Exponent];

    Sign = '+' | '-';

    Significand =
      Digits ['.'] [Digits] | [Digits] '.' Digits;

    Exponent = ('e' | 'E') [Sign] Digits;

    Digits = { '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' };

Services B<should> clearly document the range of supported values, the
maximum supported precision (total number of digits), and, if applicable,
the scale (number of digits after the decimal point), as well as how it
behaves when receiving out-of-bounds values.

Services B<may> choose to accept values passed as input even when the
value has a higher precision or scale than the service supports, and
B<should> round the value to fit the supported scale. Alternatively, the
service B<may> error with `400 Bad Request` (`INVALID_ARGUMENT` in gRPC)
if precision would be lost.

Services B<should> error with `400 Bad Request` (`INVALID_ARGUMENT` in
gRPC) if the service receives a value outside of the supported range.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Type::Decimal::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

package Google::Type::Money;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Chdnb29nbGUvdHlwZS9tb25leS5wcm90bxILZ29vZ2xlLnR5cGUiWAoFTW9uZXkSIwoNY3Vy
cmVuY3lfY29kZRgBIAEoCVIMY3VycmVuY3lDb2RlEhQKBXVuaXRzGAIgASgDUgV1bml0cxIU
CgVuYW5vcxgDIAEoBVIFbmFub3NCXQoPY29tLmdvb2dsZS50eXBlQgpNb25leVByb3RvUAFa
Nmdvb2dsZS5nb2xhbmcub3JnL2dlbnByb3RvL2dvb2dsZWFwaXMvdHlwZS9tb25leTttb25l
eaICA0dUUErJCwoGEgQOACgBCrwECgEMEgMOABIysQQgQ29weXJpZ2h0IDIwMjYgR29vZ2xl
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
CAoBAhIDEAAUCggKAQgSAxIATQoJCgIICxIDEgBNCggKAQgSAxMAIgoJCgIIChIDEwAiCggK
AQgSAxQAKwoJCgIICBIDFAArCggKAQgSAxUAKAoJCgIIARIDFQAoCggKAQgSAxYAIQoJCgII
JBIDFgAhCkMKAgQAEgQZACgBGjcgUmVwcmVzZW50cyBhbiBhbW91bnQgb2YgbW9uZXkgd2l0
aCBpdHMgY3VycmVuY3kgdHlwZS4KCgoKAwQAARIDGQgNCkIKBAQAAgASAxsCGxo1IFRoZSB0
aHJlZS1sZXR0ZXIgY3VycmVuY3kgY29kZSBkZWZpbmVkIGluIElTTyA0MjE3LgoKDAoFBAAC
AAUSAxsCCAoMCgUEAAIAARIDGwkWCgwKBQQAAgADEgMbGRoKdgoEBAACARIDHwISGmkgVGhl
IHdob2xlIHVuaXRzIG9mIHRoZSBhbW91bnQuCiBGb3IgZXhhbXBsZSBpZiBgY3VycmVuY3lD
b2RlYCBpcyBgIlVTRCJgLCB0aGVuIDEgdW5pdCBpcyBvbmUgVVMgZG9sbGFyLgoKDAoFBAAC
AQUSAx8CBwoMCgUEAAIBARIDHwgNCgwKBQQAAgEDEgMfEBEKgQMKBAQAAgISAycCEhrzAiBO
dW1iZXIgb2YgbmFubyAoMTBeLTkpIHVuaXRzIG9mIHRoZSBhbW91bnQuCiBUaGUgdmFsdWUg
bXVzdCBiZSBiZXR3ZWVuIC05OTksOTk5LDk5OSBhbmQgKzk5OSw5OTksOTk5IGluY2x1c2l2
ZS4KIElmIGB1bml0c2AgaXMgcG9zaXRpdmUsIGBuYW5vc2AgbXVzdCBiZSBwb3NpdGl2ZSBv
ciB6ZXJvLgogSWYgYHVuaXRzYCBpcyB6ZXJvLCBgbmFub3NgIGNhbiBiZSBwb3NpdGl2ZSwg
emVybywgb3IgbmVnYXRpdmUuCiBJZiBgdW5pdHNgIGlzIG5lZ2F0aXZlLCBgbmFub3NgIG11
c3QgYmUgbmVnYXRpdmUgb3IgemVyby4KIEZvciBleGFtcGxlICQtMS43NSBpcyByZXByZXNl
bnRlZCBhcyBgdW5pdHNgPS0xIGFuZCBgbmFub3NgPS03NTAsMDAwLDAwMC4KCgwKBQQAAgIF
EgMnAgcKDAoFBAACAgESAycIDQoMCgUEAAICAxIDJxARYgZwcm90bzM=
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Type::Money::Money ===
    # Fields for Money
    # Field: currency_code Type: 9 ()
    # Field: units Type: 3 ()
    # Field: nanos Type: 5 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Type::Money - Compiled Protocol Buffers messages for google/type/money.proto

=head1 SYNOPSIS

    use Google::Type::Money;

    my $msg = Google::Type::Money::Money->new({
        currency_code => $currency_code,
        units => $units,
        nanos => $nanos,
    });

    # Read or update a field
    my $val = $msg->currency_code();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Type::Money::Money->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/type/money.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Type::Money::Money

Represents an amount of money with its currency type.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->currency_code() >> / C<< $msg->currency_code($value) >>

Type: C<String>

The three-letter currency code defined in ISO 4217.

=item * C<< $msg->units() >> / C<< $msg->units($value) >>

Type: C<Int64>

The whole units of the amount.
For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.

=item * C<< $msg->nanos() >> / C<< $msg->nanos($value) >>

Type: C<Int32>

Number of nano (10^-9) units of the amount.
The value must be between -999,999,999 and +999,999,999 inclusive.
If `units` is positive, `nanos` must be positive or zero.
If `units` is zero, `nanos` can be positive, zero, or negative.
If `units` is negative, `nanos` must be negative or zero.
For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Type::Money::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

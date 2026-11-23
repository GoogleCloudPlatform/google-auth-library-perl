package Google::Type::Interval;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    eval { require Google::Protobuf::Timestamp };
    my $descriptor_b64 = <<'EOF';
Chpnb29nbGUvdHlwZS9pbnRlcnZhbC5wcm90bxILZ29vZ2xlLnR5cGUaH2dvb2dsZS9wcm90
b2J1Zi90aW1lc3RhbXAucHJvdG8ifAoISW50ZXJ2YWwSOQoKc3RhcnRfdGltZRgBIAEoCzIa
Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0VGltZRI1CghlbmRfdGltZRgCIAEo
CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB2VuZFRpbWVCZgoPY29tLmdvb2dsZS50
eXBlQg1JbnRlcnZhbFByb3RvUAFaPGdvb2dsZS5nb2xhbmcub3JnL2dlbnByb3RvL2dvb2ds
ZWFwaXMvdHlwZS9pbnRlcnZhbDtpbnRlcnZhbKICA0dUUEqOCwoGEgQOACwBCrwECgEMEgMO
ABIysQQgQ29weXJpZ2h0IDIwMjYgR29vZ2xlIExMQwoKIExpY2Vuc2VkIHVuZGVyIHRoZSBB
cGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSAiTGljZW5zZSIpOwogeW91IG1heSBu
b3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNl
LgogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0CgogICAgIGh0dHA6
Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMAoKIFVubGVzcyByZXF1aXJl
ZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUK
IGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuICJB
UyBJUyIgQkFTSVMsCiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkg
S0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC4KIFNlZSB0aGUgTGljZW5zZSBmb3Ig
dGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmQKIGxpbWl0
YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLgoKCAoBAhIDEAAUCgkKAgMAEgMSACkKCAoBCBID
FABTCgkKAggLEgMUAFMKCAoBCBIDFQAiCgkKAggKEgMVACIKCAoBCBIDFgAuCgkKAggIEgMW
AC4KCAoBCBIDFwAoCgkKAggBEgMXACgKCAoBCBIDGAAhCgkKAggkEgMYACEKugIKAgQAEgQg
ACwBGq0CIFJlcHJlc2VudHMgYSB0aW1lIGludGVydmFsLCBlbmNvZGVkIGFzIGEgVGltZXN0
YW1wIHN0YXJ0IChpbmNsdXNpdmUpIGFuZCBhCiBUaW1lc3RhbXAgZW5kIChleGNsdXNpdmUp
LgoKIFRoZSBzdGFydCBtdXN0IGJlIGxlc3MgdGhhbiBvciBlcXVhbCB0byB0aGUgZW5kLgog
V2hlbiB0aGUgc3RhcnQgZXF1YWxzIHRoZSBlbmQsIHRoZSBpbnRlcnZhbCBpcyBlbXB0eSAo
bWF0Y2hlcyBubyB0aW1lKS4KIFdoZW4gYm90aCBzdGFydCBhbmQgZW5kIGFyZSB1bnNwZWNp
ZmllZCwgdGhlIGludGVydmFsIG1hdGNoZXMgYW55IHRpbWUuCgoKCgMEAAESAyAIEAqbAQoE
BAACABIDJQIrGo0BIE9wdGlvbmFsLiBJbmNsdXNpdmUgc3RhcnQgb2YgdGhlIGludGVydmFs
LgoKIElmIHNwZWNpZmllZCwgYSBUaW1lc3RhbXAgbWF0Y2hpbmcgdGhpcyBpbnRlcnZhbCB3
aWxsIGhhdmUgdG8gYmUgdGhlIHNhbWUKIG9yIGFmdGVyIHRoZSBzdGFydC4KCgwKBQQAAgAG
EgMlAhsKDAoFBAACAAESAyUcJgoMCgUEAAIAAxIDJSkqCosBCgQEAAIBEgMrAikafiBPcHRp
b25hbC4gRXhjbHVzaXZlIGVuZCBvZiB0aGUgaW50ZXJ2YWwuCgogSWYgc3BlY2lmaWVkLCBh
IFRpbWVzdGFtcCBtYXRjaGluZyB0aGlzIGludGVydmFsIHdpbGwgaGF2ZSB0byBiZSBiZWZv
cmUgdGhlCiBlbmQuCgoMCgUEAAIBBhIDKwIbCgwKBQQAAgEBEgMrHCQKDAoFBAACAQMSAysn
KGIGcHJvdG8z
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Type::Interval::Interval ===
    # Fields for Interval
    # Field: start_time Type: 11 (.google.protobuf.Timestamp)
    # Field: end_time Type: 11 (.google.protobuf.Timestamp)

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Type::Interval - Compiled Protocol Buffers messages for google/type/interval.proto

=head1 SYNOPSIS

    use Google::Type::Interval;

    my $msg = Google::Type::Interval::Interval->new({
        start_time => $start_time,
        end_time => $end_time,
    });

    # Read or update a field
    my $val = $msg->start_time();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Type::Interval::Interval->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/type/interval.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Type::Interval::Interval

Represents a time interval, encoded as a Timestamp start (inclusive) and a
Timestamp end (exclusive).

The start must be less than or equal to the end.
When the start equals the end, the interval is empty (matches no time).
When both start and end are unspecified, the interval matches any time.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->start_time() >> / C<< $msg->start_time($value) >>

Type: C<Message> (L<Google::Protobuf::Timestamp::Timestamp>)

Optional. Inclusive start of the interval.

If specified, a Timestamp matching this interval will have to be the same
or after the start.

=item * C<< $msg->end_time() >> / C<< $msg->end_time($value) >>

Type: C<Message> (L<Google::Protobuf::Timestamp::Timestamp>)

Optional. Exclusive end of the interval.

If specified, a Timestamp matching this interval will have to be before the
end.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Type::Interval::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

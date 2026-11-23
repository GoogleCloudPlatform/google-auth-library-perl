package Google::Type::Timeofday;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Chtnb29nbGUvdHlwZS90aW1lb2ZkYXkucHJvdG8SC2dvb2dsZS50eXBlImsKCVRpbWVPZkRh
eRIUCgVob3VycxgBIAEoBVIFaG91cnMSGAoHbWludXRlcxgCIAEoBVIHbWludXRlcxIYCgdz
ZWNvbmRzGAMgASgFUgdzZWNvbmRzEhQKBW5hbm9zGAQgASgFUgVuYW5vc0JpCg9jb20uZ29v
Z2xlLnR5cGVCDlRpbWVPZkRheVByb3RvUAFaPmdvb2dsZS5nb2xhbmcub3JnL2dlbnByb3Rv
L2dvb2dsZWFwaXMvdHlwZS90aW1lb2ZkYXk7dGltZW9mZGF5ogIDR1RQSuoNCgYSBA4ALgEK
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
ZAogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuCgoICgECEgMQABQKCAoBCBIDEgBV
CgkKAggLEgMSAFUKCAoBCBIDEwAiCgkKAggKEgMTACIKCAoBCBIDFAAvCgkKAggIEgMUAC8K
CAoBCBIDFQAoCgkKAggBEgMVACgKCAoBCBIDFgAhCgkKAggkEgMWACEK+gEKAgQAEgQcAC4B
Gu0BIFJlcHJlc2VudHMgYSB0aW1lIG9mIGRheS4gVGhlIGRhdGUgYW5kIHRpbWUgem9uZSBh
cmUgZWl0aGVyIG5vdCBzaWduaWZpY2FudAogb3IgYXJlIHNwZWNpZmllZCBlbHNld2hlcmUu
IEFuIEFQSSBtYXkgY2hvb3NlIHRvIGFsbG93IGxlYXAgc2Vjb25kcy4gUmVsYXRlZAogdHlw
ZXMgYXJlIFtnb29nbGUudHlwZS5EYXRlXVtnb29nbGUudHlwZS5EYXRlXSBhbmQKIGBnb29n
bGUucHJvdG9idWYuVGltZXN0YW1wYC4KCgoKAwQAARIDHAgRCuABCgQEAAIAEgMgAhIa0gEg
SG91cnMgb2YgYSBkYXkgaW4gMjQgaG91ciBmb3JtYXQuIE11c3QgYmUgZ3JlYXRlciB0aGFu
IG9yIGVxdWFsIHRvIDAgYW5kCiB0eXBpY2FsbHkgbXVzdCBiZSBsZXNzIHRoYW4gb3IgZXF1
YWwgdG8gMjMuIEFuIEFQSSBtYXkgY2hvb3NlIHRvIGFsbG93IHRoZQogdmFsdWUgIjI0OjAw
OjAwIiBmb3Igc2NlbmFyaW9zIGxpa2UgYnVzaW5lc3MgY2xvc2luZyB0aW1lLgoKDAoFBAAC
AAUSAyACBwoMCgUEAAIAARIDIAgNCgwKBQQAAgADEgMgEBEKZAoEBAACARIDJAIUGlcgTWlu
dXRlcyBvZiBhbiBob3VyLiBNdXN0IGJlIGdyZWF0ZXIgdGhhbiBvciBlcXVhbCB0byAwIGFu
ZCBsZXNzIHRoYW4gb3IKIGVxdWFsIHRvIDU5LgoKDAoFBAACAQUSAyQCBwoMCgUEAAIBARID
JAgPCgwKBQQAAgEDEgMkEhMKsgEKBAQAAgISAykCFBqkASBTZWNvbmRzIG9mIGEgbWludXRl
LiBNdXN0IGJlIGdyZWF0ZXIgdGhhbiBvciBlcXVhbCB0byAwIGFuZCB0eXBpY2FsbHkgbXVz
dAogYmUgbGVzcyB0aGFuIG9yIGVxdWFsIHRvIDU5LiBBbiBBUEkgbWF5IGFsbG93IHRoZSB2
YWx1ZSA2MCBpZiBpdCBhbGxvd3MKIGxlYXAtc2Vjb25kcy4KCgwKBQQAAgIFEgMpAgcKDAoF
BAACAgESAykIDwoMCgUEAAICAxIDKRITCn8KBAQAAgMSAy0CEhpyIEZyYWN0aW9ucyBvZiBz
ZWNvbmRzLCBpbiBuYW5vc2Vjb25kcy4gTXVzdCBiZSBncmVhdGVyIHRoYW4gb3IgZXF1YWwg
dG8gMAogYW5kIGxlc3MgdGhhbiBvciBlcXVhbCB0byA5OTksOTk5LDk5OS4KCgwKBQQAAgMF
EgMtAgcKDAoFBAACAwESAy0IDQoMCgUEAAIDAxIDLRARYgZwcm90bzM=
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Type::Timeofday::TimeOfDay ===
    # Fields for TimeOfDay
    # Field: hours Type: 5 ()
    # Field: minutes Type: 5 ()
    # Field: seconds Type: 5 ()
    # Field: nanos Type: 5 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Type::Timeofday - Compiled Protocol Buffers messages for google/type/timeofday.proto

=head1 SYNOPSIS

    use Google::Type::Timeofday;

    my $msg = Google::Type::Timeofday::TimeOfDay->new({
        hours => $hours,
        minutes => $minutes,
        seconds => $seconds,
        nanos => $nanos,
    });

    # Read or update a field
    my $val = $msg->hours();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Type::Timeofday::TimeOfDay->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/type/timeofday.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Type::Timeofday::TimeOfDay

Represents a time of day. The date and time zone are either not significant
or are specified elsewhere. An API may choose to allow leap seconds. Related
types are [google.type.Date][google.type.Date] and
`google.protobuf.Timestamp`.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->hours() >> / C<< $msg->hours($value) >>

Type: C<Int32>

Hours of a day in 24 hour format. Must be greater than or equal to 0 and
typically must be less than or equal to 23. An API may choose to allow the
value "24:00:00" for scenarios like business closing time.

=item * C<< $msg->minutes() >> / C<< $msg->minutes($value) >>

Type: C<Int32>

Minutes of an hour. Must be greater than or equal to 0 and less than or
equal to 59.

=item * C<< $msg->seconds() >> / C<< $msg->seconds($value) >>

Type: C<Int32>

Seconds of a minute. Must be greater than or equal to 0 and typically must
be less than or equal to 59. An API may allow the value 60 if it allows
leap-seconds.

=item * C<< $msg->nanos() >> / C<< $msg->nanos($value) >>

Type: C<Int32>

Fractions of seconds, in nanoseconds. Must be greater than or equal to 0
and less than or equal to 999,999,999.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Type::Timeofday::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

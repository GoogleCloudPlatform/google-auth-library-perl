package Google::Type::Datetime;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    eval { require Google::Protobuf::Duration };
    my $descriptor_b64 = <<'EOF';
Chpnb29nbGUvdHlwZS9kYXRldGltZS5wcm90bxILZ29vZ2xlLnR5cGUaHmdvb2dsZS9wcm90
b2J1Zi9kdXJhdGlvbi5wcm90byKnAgoIRGF0ZVRpbWUSEgoEeWVhchgBIAEoBVIEeWVhchIU
CgVtb250aBgCIAEoBVIFbW9udGgSEAoDZGF5GAMgASgFUgNkYXkSFAoFaG91cnMYBCABKAVS
BWhvdXJzEhgKB21pbnV0ZXMYBSABKAVSB21pbnV0ZXMSGAoHc2Vjb25kcxgGIAEoBVIHc2Vj
b25kcxIUCgVuYW5vcxgHIAEoBVIFbmFub3MSOgoKdXRjX29mZnNldBgIIAEoCzIZLmdvb2ds
ZS5wcm90b2J1Zi5EdXJhdGlvbkgAUgl1dGNPZmZzZXQSNAoJdGltZV96b25lGAkgASgLMhUu
Z29vZ2xlLnR5cGUuVGltZVpvbmVIAFIIdGltZVpvbmVCDQoLdGltZV9vZmZzZXQiNAoIVGlt
ZVpvbmUSDgoCaWQYASABKAlSAmlkEhgKB3ZlcnNpb24YAiABKAlSB3ZlcnNpb25CZgoPY29t
Lmdvb2dsZS50eXBlQg1EYXRlVGltZVByb3RvUAFaPGdvb2dsZS5nb2xhbmcub3JnL2dlbnBy
b3RvL2dvb2dsZWFwaXMvdHlwZS9kYXRldGltZTtkYXRldGltZaICA0dUUEryHwoGEgQOAGcB
CrwECgEMEgMOABIysQQgQ29weXJpZ2h0IDIwMjYgR29vZ2xlIExMQwoKIExpY2Vuc2VkIHVu
ZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSAiTGljZW5zZSIpOwog
eW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRo
ZSBMaWNlbnNlLgogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0Cgog
ICAgIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMAoKIFVubGVz
cyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywg
c29mdHdhcmUKIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVk
IG9uIGFuICJBUyBJUyIgQkFTSVMsCiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9O
UyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC4KIFNlZSB0aGUgTGlj
ZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBh
bmQKIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLgoKCAoBAhIDEAAUCgkKAgMAEgMS
ACgKCAoBCBIDFABTCgkKAggLEgMUAFMKCAoBCBIDFQAiCgkKAggKEgMVACIKCAoBCBIDFgAu
CgkKAggIEgMWAC4KCAoBCBIDFwAoCgkKAggBEgMXACgKCAoBCBIDGAAhCgkKAggkEgMYACEK
xggKAgQAEgQyAF0BGrkIIFJlcHJlc2VudHMgY2l2aWwgdGltZSAob3Igb2NjYXNpb25hbGx5
IHBoeXNpY2FsIHRpbWUpLgoKIFRoaXMgdHlwZSBjYW4gcmVwcmVzZW50IGEgY2l2aWwgdGlt
ZSBpbiBvbmUgb2YgYSBmZXcgcG9zc2libGUgd2F5czoKCiAgKiBXaGVuIHV0Y19vZmZzZXQg
aXMgc2V0IGFuZCB0aW1lX3pvbmUgaXMgdW5zZXQ6IGEgY2l2aWwgdGltZSBvbiBhIGNhbGVu
ZGFyCiAgICBkYXkgd2l0aCBhIHBhcnRpY3VsYXIgb2Zmc2V0IGZyb20gVVRDLgogICogV2hl
biB0aW1lX3pvbmUgaXMgc2V0IGFuZCB1dGNfb2Zmc2V0IGlzIHVuc2V0OiBhIGNpdmlsIHRp
bWUgb24gYSBjYWxlbmRhcgogICAgZGF5IGluIGEgcGFydGljdWxhciB0aW1lIHpvbmUuCiAg
KiBXaGVuIG5laXRoZXIgdGltZV96b25lIG5vciB1dGNfb2Zmc2V0IGlzIHNldDogYSBjaXZp
bCB0aW1lIG9uIGEgY2FsZW5kYXIKICAgIGRheSBpbiBsb2NhbCB0aW1lLgoKIFRoZSBkYXRl
IGlzIHJlbGF0aXZlIHRvIHRoZSBQcm9sZXB0aWMgR3JlZ29yaWFuIENhbGVuZGFyLgoKIElm
IHllYXIsIG1vbnRoLCBvciBkYXkgYXJlIDAsIHRoZSBEYXRlVGltZSBpcyBjb25zaWRlcmVk
IG5vdCB0byBoYXZlIGEKIHNwZWNpZmljIHllYXIsIG1vbnRoLCBvciBkYXkgcmVzcGVjdGl2
ZWx5LgoKIFRoaXMgdHlwZSBtYXkgYWxzbyBiZSB1c2VkIHRvIHJlcHJlc2VudCBhIHBoeXNp
Y2FsIHRpbWUgaWYgYWxsIHRoZSBkYXRlIGFuZAogdGltZSBmaWVsZHMgYXJlIHNldCBhbmQg
ZWl0aGVyIGNhc2Ugb2YgdGhlIGB0aW1lX29mZnNldGAgb25lb2YgaXMgc2V0LgogQ29uc2lk
ZXIgdXNpbmcgYFRpbWVzdGFtcGAgbWVzc2FnZSBmb3IgcGh5c2ljYWwgdGltZSBpbnN0ZWFk
LiBJZiB5b3VyIHVzZQogY2FzZSBhbHNvIHdvdWxkIGxpa2UgdG8gc3RvcmUgdGhlIHVzZXIn
cyB0aW1lem9uZSwgdGhhdCBjYW4gYmUgZG9uZSBpbgogYW5vdGhlciBmaWVsZC4KCiBUaGlz
IHR5cGUgaXMgbW9yZSBmbGV4aWJsZSB0aGFuIHNvbWUgYXBwbGljYXRpb25zIG1heSB3YW50
LiBNYWtlIHN1cmUgdG8KIGRvY3VtZW50IGFuZCB2YWxpZGF0ZSB5b3VyIGFwcGxpY2F0aW9u
J3MgbGltaXRhdGlvbnMuCgoKCgMEAAESAzIIEAptCgQEAAIAEgM1AhEaYCBPcHRpb25hbC4g
WWVhciBvZiBkYXRlLiBNdXN0IGJlIGZyb20gMSB0byA5OTk5LCBvciAwIGlmIHNwZWNpZnlp
bmcgYQogZGF0ZXRpbWUgd2l0aG91dCBhIHllYXIuCgoMCgUEAAIABRIDNQIHCgwKBQQAAgAB
EgM1CAwKDAoFBAACAAMSAzUPEAptCgQEAAIBEgM5AhIaYCBPcHRpb25hbC4gTW9udGggb2Yg
eWVhci4gTXVzdCBiZSBmcm9tIDEgdG8gMTIsIG9yIDAgaWYgc3BlY2lmeWluZyBhCiBkYXRl
dGltZSB3aXRob3V0IGEgbW9udGguCgoMCgUEAAIBBRIDOQIHCgwKBQQAAgEBEgM5CA0KDAoF
BAACAQMSAzkQEQqLAQoEBAACAhIDPQIQGn4gT3B0aW9uYWwuIERheSBvZiBtb250aC4gTXVz
dCBiZSBmcm9tIDEgdG8gMzEgYW5kIHZhbGlkIGZvciB0aGUgeWVhciBhbmQKIG1vbnRoLCBv
ciAwIGlmIHNwZWNpZnlpbmcgYSBkYXRldGltZSB3aXRob3V0IGEgZGF5LgoKDAoFBAACAgUS
Az0CBwoMCgUEAAICARIDPQgLCgwKBQQAAgIDEgM9Dg8KxwEKBAQAAgMSA0ICEhq5ASBPcHRp
b25hbC4gSG91cnMgb2YgZGF5IGluIDI0IGhvdXIgZm9ybWF0LiBTaG91bGQgYmUgZnJvbSAw
IHRvIDIzLCBkZWZhdWx0cwogdG8gMCAobWlkbmlnaHQpLiBBbiBBUEkgbWF5IGNob29zZSB0
byBhbGxvdyB0aGUgdmFsdWUgIjI0OjAwOjAwIiBmb3IKIHNjZW5hcmlvcyBsaWtlIGJ1c2lu
ZXNzIGNsb3NpbmcgdGltZS4KCgwKBQQAAgMFEgNCAgcKDAoFBAACAwESA0IIDQoMCgUEAAID
AxIDQhARClUKBAQAAgQSA0UCFBpIIE9wdGlvbmFsLiBNaW51dGVzIG9mIGhvdXIgb2YgZGF5
LiBNdXN0IGJlIGZyb20gMCB0byA1OSwgZGVmYXVsdHMgdG8gMC4KCgwKBQQAAgQFEgNFAgcK
DAoFBAACBAESA0UIDwoMCgUEAAIEAxIDRRITCqEBCgQEAAIFEgNJAhQakwEgT3B0aW9uYWwu
IFNlY29uZHMgb2YgbWludXRlcyBvZiB0aGUgdGltZS4gTXVzdCBub3JtYWxseSBiZSBmcm9t
IDAgdG8gNTksCiBkZWZhdWx0cyB0byAwLiBBbiBBUEkgbWF5IGFsbG93IHRoZSB2YWx1ZSA2
MCBpZiBpdCBhbGxvd3MgbGVhcC1zZWNvbmRzLgoKDAoFBAACBQUSA0kCBwoMCgUEAAIFARID
SQgPCgwKBQQAAgUDEgNJEhMKbAoEBAACBhIDTQISGl8gT3B0aW9uYWwuIEZyYWN0aW9ucyBv
ZiBzZWNvbmRzIGluIG5hbm9zZWNvbmRzLiBNdXN0IGJlIGZyb20gMCB0bwogOTk5LDk5OSw5
OTksIGRlZmF1bHRzIHRvIDAuCgoMCgUEAAIGBRIDTQIHCgwKBQQAAgYBEgNNCA0KDAoFBAAC
BgMSA00QEQr1AgoEBAAIABIEVAJcAxrmAiBPcHRpb25hbC4gU3BlY2lmaWVzIGVpdGhlciB0
aGUgVVRDIG9mZnNldCBvciB0aGUgdGltZSB6b25lIG9mIHRoZSBEYXRlVGltZS4KIENob29z
ZSBjYXJlZnVsbHkgYmV0d2VlbiB0aGVtLCBjb25zaWRlcmluZyB0aGF0IHRpbWUgem9uZSBk
YXRhIG1heSBjaGFuZ2UKIGluIHRoZSBmdXR1cmUgKGZvciBleGFtcGxlLCBhIGNvdW50cnkg
bW9kaWZpZXMgdGhlaXIgRFNUIHN0YXJ0L2VuZCBkYXRlcywKIGFuZCBmdXR1cmUgRGF0ZVRp
bWVzIGluIHRoZSBhZmZlY3RlZCByYW5nZSBoYWQgYWxyZWFkeSBiZWVuIHN0b3JlZCkuCiBJ
ZiBvbWl0dGVkLCB0aGUgRGF0ZVRpbWUgaXMgY29uc2lkZXJlZCB0byBiZSBpbiBsb2NhbCB0
aW1lLgoKDAoFBAAIAAESA1QIEwqlAQoEBAACBxIDWAQsGpcBIFVUQyBvZmZzZXQuIE11c3Qg
YmUgd2hvbGUgc2Vjb25kcywgYmV0d2VlbiAtMTggaG91cnMgYW5kICsxOCBob3Vycy4KIEZv
ciBleGFtcGxlLCBhIFVUQyBvZmZzZXQgb2YgLTQ6MDAgd291bGQgYmUgcmVwcmVzZW50ZWQg
YXMKIHsgc2Vjb25kczogLTE0NDAwIH0uCgoMCgUEAAIHBhIDWAQcCgwKBQQAAgcBEgNYHScK
DAoFBAACBwMSA1gqKwoZCgQEAAIIEgNbBBsaDCBUaW1lIHpvbmUuCgoMCgUEAAIIBhIDWwQM
CgwKBQQAAggBEgNbDRYKDAoFBAACCAMSA1sZGgpqCgIEARIEYQBnARpeIFJlcHJlc2VudHMg
YSB0aW1lIHpvbmUgZnJvbSB0aGUKIFtJQU5BIFRpbWUgWm9uZSBEYXRhYmFzZV0oaHR0cHM6
Ly93d3cuaWFuYS5vcmcvdGltZS16b25lcykuCgoKCgMEAQESA2EIEApRCgQEAQIAEgNjAhAa
RCBJQU5BIFRpbWUgWm9uZSBEYXRhYmFzZSB0aW1lIHpvbmUuIEZvciBleGFtcGxlICJBbWVy
aWNhL05ld19Zb3JrIi4KCgwKBQQBAgAFEgNjAggKDAoFBAECAAESA2MJCwoMCgUEAQIAAxID
Yw4PClUKBAQBAgESA2YCFRpIIE9wdGlvbmFsLiBJQU5BIFRpbWUgWm9uZSBEYXRhYmFzZSB2
ZXJzaW9uIG51bWJlci4gRm9yIGV4YW1wbGUgIjIwMTlhIi4KCgwKBQQBAgEFEgNmAggKDAoF
BAECAQESA2YJEAoMCgUEAQIBAxIDZhMUYgZwcm90bzM=
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Type::Datetime::DateTime ===
    # Fields for DateTime
    # Field: year Type: 5 ()
    # Field: month Type: 5 ()
    # Field: day Type: 5 ()
    # Field: hours Type: 5 ()
    # Field: minutes Type: 5 ()
    # Field: seconds Type: 5 ()
    # Field: nanos Type: 5 ()
    # Field: utc_offset Type: 11 (.google.protobuf.Duration)
    # Field: time_zone Type: 11 (.google.type.TimeZone)

# === Message: Google::Type::Datetime::TimeZone ===
    # Fields for TimeZone
    # Field: id Type: 9 ()
    # Field: version Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Type::Datetime - Compiled Protocol Buffers messages for google/type/datetime.proto

=head1 SYNOPSIS

    use Google::Type::Datetime;

    my $msg = Google::Type::Datetime::DateTime->new({
        year => $year,
        month => $month,
        day => $day,
        hours => $hours,
    });

    # Read or update a field
    my $val = $msg->year();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Type::Datetime::DateTime->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/type/datetime.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Type::Datetime::DateTime

Represents civil time (or occasionally physical time).

This type can represent a civil time in one of a few possible ways:

 * When utc_offset is set and time_zone is unset: a civil time on a calendar
   day with a particular offset from UTC.
 * When time_zone is set and utc_offset is unset: a civil time on a calendar
   day in a particular time zone.
 * When neither time_zone nor utc_offset is set: a civil time on a calendar
   day in local time.

The date is relative to the Proleptic Gregorian Calendar.

If year, month, or day are 0, the DateTime is considered not to have a
specific year, month, or day respectively.

This type may also be used to represent a physical time if all the date and
time fields are set and either case of the `time_offset` oneof is set.
Consider using `Timestamp` message for physical time instead. If your use
case also would like to store the user's timezone, that can be done in
another field.

This type is more flexible than some applications may want. Make sure to
document and validate your application's limitations.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->year() >> / C<< $msg->year($value) >>

Type: C<Int32>

Optional. Year of date. Must be from 1 to 9999, or 0 if specifying a
datetime without a year.

=item * C<< $msg->month() >> / C<< $msg->month($value) >>

Type: C<Int32>

Optional. Month of year. Must be from 1 to 12, or 0 if specifying a
datetime without a month.

=item * C<< $msg->day() >> / C<< $msg->day($value) >>

Type: C<Int32>

Optional. Day of month. Must be from 1 to 31 and valid for the year and
month, or 0 if specifying a datetime without a day.

=item * C<< $msg->hours() >> / C<< $msg->hours($value) >>

Type: C<Int32>

Optional. Hours of day in 24 hour format. Should be from 0 to 23, defaults
to 0 (midnight). An API may choose to allow the value "24:00:00" for
scenarios like business closing time.

=item * C<< $msg->minutes() >> / C<< $msg->minutes($value) >>

Type: C<Int32>

Optional. Minutes of hour of day. Must be from 0 to 59, defaults to 0.

=item * C<< $msg->seconds() >> / C<< $msg->seconds($value) >>

Type: C<Int32>

Optional. Seconds of minutes of the time. Must normally be from 0 to 59,
defaults to 0. An API may allow the value 60 if it allows leap-seconds.

=item * C<< $msg->nanos() >> / C<< $msg->nanos($value) >>

Type: C<Int32>

Optional. Fractions of seconds in nanoseconds. Must be from 0 to
999,999,999, defaults to 0.

=item * C<< $msg->utc_offset() >> / C<< $msg->utc_offset($value) >>

Type: C<Message> (L<Google::Protobuf::Duration::Duration>)

UTC offset. Must be whole seconds, between -18 hours and +18 hours.
For example, a UTC offset of -4:00 would be represented as
{ seconds: -14400 }.

=item * C<< $msg->time_zone() >> / C<< $msg->time_zone($value) >>

Type: C<Message> (L<Google::Type::Datetime::TimeZone>)

Time zone.

=back

=head2 Google::Type::Datetime::TimeZone

Represents a time zone from the
[IANA Time Zone Database](https://www.iana.org/time-zones).

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->id() >> / C<< $msg->id($value) >>

Type: C<String>

IANA Time Zone Database time zone. For example "America/New_York".

=item * C<< $msg->version() >> / C<< $msg->version($value) >>

Type: C<String>

Optional. IANA Time Zone Database version number. For example "2019a".

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Type::Datetime::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

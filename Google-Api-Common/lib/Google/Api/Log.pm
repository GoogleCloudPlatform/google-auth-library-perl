package Google::Api::Log;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    eval { require Google::Api::Label };
    my $descriptor_b64 = <<'EOF';
ChRnb29nbGUvYXBpL2xvZy5wcm90bxIKZ29vZ2xlLmFwaRoWZ29vZ2xlL2FwaS9sYWJlbC5w
cm90byKdAQoNTG9nRGVzY3JpcHRvchISCgRuYW1lGAEgASgJUgRuYW1lEjMKBmxhYmVscxgC
IAMoCzIbLmdvb2dsZS5hcGkuTGFiZWxEZXNjcmlwdG9yUgZsYWJlbHMSIAoLZGVzY3JpcHRp
b24YAyABKAlSC2Rlc2NyaXB0aW9uEiEKDGRpc3BsYXlfbmFtZRgEIAEoCVILZGlzcGxheU5h
bWVCagoOY29tLmdvb2dsZS5hcGlCCExvZ1Byb3RvUAFaRWdvb2dsZS5nb2xhbmcub3JnL2dl
bnByb3RvL2dvb2dsZWFwaXMvYXBpL3NlcnZpY2Vjb25maWc7c2VydmljZWNvbmZpZ6ICBEdB
UElK/g4KBhIEDgA1AQq8BAoBDBIDDgASMrEEIENvcHlyaWdodCAyMDI2IEdvb2dsZSBMTEMK
CiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0aGUg
IkxpY2Vuc2UiKTsKIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBs
aWFuY2Ugd2l0aCB0aGUgTGljZW5zZS4KIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUg
TGljZW5zZSBhdAoKICAgICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5T
RS0yLjAKCiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVkIHRv
IGluIHdyaXRpbmcsIHNvZnR3YXJlCiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBp
cyBkaXN0cmlidXRlZCBvbiBhbiAiQVMgSVMiIEJBU0lTLAogV0lUSE9VVCBXQVJSQU5USUVT
IE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQu
CiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcg
cGVybWlzc2lvbnMgYW5kCiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS4KCggKAQIS
AxAAEwoJCgIDABIDEgAgCggKAQgSAxQAXAoJCgIICxIDFABcCggKAQgSAxUAIgoJCgIIChID
FQAiCggKAQgSAxYAKQoJCgIICBIDFgApCggKAQgSAxcAJwoJCgIIARIDFwAnCggKAQgSAxgA
IgoJCgIIJBIDGAAiCsICCgIEABIEIgA1ARq1AiBBIGRlc2NyaXB0aW9uIG9mIGEgbG9nIHR5
cGUuIEV4YW1wbGUgaW4gWUFNTCBmb3JtYXQ6CgogICAgIC0gbmFtZTogbGlicmFyeS5nb29n
bGVhcGlzLmNvbS9hY3Rpdml0eV9oaXN0b3J5CiAgICAgICBkZXNjcmlwdGlvbjogVGhlIGhp
c3Rvcnkgb2YgYm9ycm93aW5nIGFuZCByZXR1cm5pbmcgbGlicmFyeSBpdGVtcy4KICAgICAg
IGRpc3BsYXlfbmFtZTogQWN0aXZpdHkKICAgICAgIGxhYmVsczoKICAgICAgIC0ga2V5OiAv
Y3VzdG9tZXJfaWQKICAgICAgICAgZGVzY3JpcHRpb246IElkZW50aWZpZXIgb2YgYSBsaWJy
YXJ5IGN1c3RvbWVyCgoKCgMEAAESAyIIFQqEAgoEBAACABIDJwISGvYBIFRoZSBuYW1lIG9m
IHRoZSBsb2cuIEl0IG11c3QgYmUgbGVzcyB0aGFuIDUxMiBjaGFyYWN0ZXJzIGxvbmcgYW5k
IGNhbgogaW5jbHVkZSB0aGUgZm9sbG93aW5nIGNoYXJhY3RlcnM6IHVwcGVyLSBhbmQgbG93
ZXItY2FzZSBhbHBoYW51bWVyaWMKIGNoYXJhY3RlcnMgW0EtWmEtejAtOV0sIGFuZCBwdW5j
dHVhdGlvbiBjaGFyYWN0ZXJzIGluY2x1ZGluZwogc2xhc2gsIHVuZGVyc2NvcmUsIGh5cGhl
biwgcGVyaW9kIFsvXy0uXS4KCgwKBQQAAgAFEgMnAggKDAoFBAACAAESAycJDQoMCgUEAAIA
AxIDJxARCqgBCgQEAAIBEgMsAiYamgEgVGhlIHNldCBvZiBsYWJlbHMgdGhhdCBhcmUgYXZh
aWxhYmxlIHRvIGRlc2NyaWJlIGEgc3BlY2lmaWMgbG9nIGVudHJ5LgogUnVudGltZSByZXF1
ZXN0cyB0aGF0IGNvbnRhaW4gbGFiZWxzIG5vdCBzcGVjaWZpZWQgaGVyZSBhcmUKIGNvbnNp
ZGVyZWQgaW52YWxpZC4KCgwKBQQAAgEEEgMsAgoKDAoFBAACAQYSAywLGgoMCgUEAAIBARID
LBshCgwKBQQAAgEDEgMsJCUKgAEKBAQAAgISAzACGRpzIEEgaHVtYW4tcmVhZGFibGUgZGVz
Y3JpcHRpb24gb2YgdGhpcyBsb2cuIFRoaXMgaW5mb3JtYXRpb24gYXBwZWFycyBpbgogdGhl
IGRvY3VtZW50YXRpb24gYW5kIGNhbiBjb250YWluIGRldGFpbHMuCgoMCgUEAAICBRIDMAII
CgwKBQQAAgIBEgMwCRQKDAoFBAACAgMSAzAXGAp7CgQEAAIDEgM0AhoabiBUaGUgaHVtYW4t
cmVhZGFibGUgbmFtZSBmb3IgdGhpcyBsb2cuIFRoaXMgaW5mb3JtYXRpb24gYXBwZWFycyBv
bgogdGhlIHVzZXIgaW50ZXJmYWNlIGFuZCBzaG91bGQgYmUgY29uY2lzZS4KCgwKBQQAAgMF
EgM0AggKDAoFBAACAwESAzQJFQoMCgUEAAIDAxIDNBgZYgZwcm90bzM=
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Log::LogDescriptor ===
    # Fields for LogDescriptor
    # Field: name Type: 9 ()
    # Field: labels Type: 11 (.google.api.LabelDescriptor)
    # Field: description Type: 9 ()
    # Field: display_name Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Log - Compiled Protocol Buffers messages for google/api/log.proto

=head1 SYNOPSIS

    use Google::Api::Log;

    my $msg = Google::Api::Log::LogDescriptor->new({
        name => $name,
        labels => $labels,
        description => $description,
        display_name => $display_name,
    });

    # Read or update a field
    my $val = $msg->name();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Log::LogDescriptor->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/log.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Log::LogDescriptor

A description of a log type. Example in YAML format:

    - name: library.googleapis.com/activity_history
      description: The history of borrowing and returning library items.
      display_name: Activity
      labels:
      - key: /customer_id
        description: Identifier of a library customer

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->name() >> / C<< $msg->name($value) >>

Type: C<String>

The name of the log. It must be less than 512 characters long and can
include the following characters: upper- and lower-case alphanumeric
characters [A-Za-z0-9], and punctuation characters including
slash, underscore, hyphen, period [/_-.].

=item * C<< $msg->labels() >> / C<< $msg->labels($value) >>

Type: C<Message> (L<Google::Api::Label::LabelDescriptor>)

The set of labels that are available to describe a specific log entry.
Runtime requests that contain labels not specified here are
considered invalid.

=item * C<< $msg->description() >> / C<< $msg->description($value) >>

Type: C<String>

A human-readable description of this log. This information appears in
the documentation and can contain details.

=item * C<< $msg->display_name() >> / C<< $msg->display_name($value) >>

Type: C<String>

The human-readable name for this log. This information appears on
the user interface and should be concise.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Log::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

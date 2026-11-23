package Google::Rpc::Http;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
ChVnb29nbGUvcnBjL2h0dHAucHJvdG8SCmdvb2dsZS5ycGMifQoLSHR0cFJlcXVlc3QSFgoG
bWV0aG9kGAEgASgJUgZtZXRob2QSEAoDdXJpGAIgASgJUgN1cmkSMAoHaGVhZGVycxgDIAMo
CzIWLmdvb2dsZS5ycGMuSHR0cEhlYWRlclIHaGVhZGVycxISCgRib2R5GAQgASgMUgRib2R5
IoQBCgxIdHRwUmVzcG9uc2USFgoGc3RhdHVzGAEgASgFUgZzdGF0dXMSFgoGcmVhc29uGAIg
ASgJUgZyZWFzb24SMAoHaGVhZGVycxgDIAMoCzIWLmdvb2dsZS5ycGMuSHR0cEhlYWRlclIH
aGVhZGVycxISCgRib2R5GAQgASgMUgRib2R5IjQKCkh0dHBIZWFkZXISEAoDa2V5GAEgASgJ
UgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlQlgKDmNvbS5nb29nbGUucnBjQglIdHRwUHJv
dG9QAVozZ29vZ2xlLmdvbGFuZy5vcmcvZ2VucHJvdG8vZ29vZ2xlYXBpcy9ycGMvaHR0cDto
dHRwogIDUlBDSrYQCgYSBA4APwEKvAQKAQwSAw4AEjKxBCBDb3B5cmlnaHQgMjAyNiBHb29n
bGUgTExDCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIu
MCAodGhlICJMaWNlbnNlIik7CiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBp
biBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuCiBZb3UgbWF5IG9idGFpbiBhIGNvcHkg
b2YgdGhlIExpY2Vuc2UgYXQKCiAgICAgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2Vz
L0xJQ0VOU0UtMi4wCgogVW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFn
cmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZQogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExp
Y2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKIFdJVEhPVVQgV0FS
UkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBp
bXBsaWVkLgogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292
ZXJuaW5nIHBlcm1pc3Npb25zIGFuZAogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2Uu
CgoICgECEgMQABMKCAoBCBIDEgBKCgkKAggLEgMSAEoKCAoBCBIDEwAiCgkKAggKEgMTACIK
CAoBCBIDFAAqCgkKAggIEgMUACoKCAoBCBIDFQAnCgkKAggBEgMVACcKCAoBCBIDFgAhCgkK
AggkEgMWACEKKQoCBAASBBkAJgEaHSBSZXByZXNlbnRzIGFuIEhUVFAgcmVxdWVzdC4KCgoK
AwQAARIDGQgTCicKBAQAAgASAxsCFBoaIFRoZSBIVFRQIHJlcXVlc3QgbWV0aG9kLgoKDAoF
BAACAAUSAxsCCAoMCgUEAAIAARIDGwkPCgwKBQQAAgADEgMbEhMKJAoEBAACARIDHgIRGhcg
VGhlIEhUVFAgcmVxdWVzdCBVUkkuCgoMCgUEAAIBBRIDHgIICgwKBQQAAgEBEgMeCQwKDAoF
BAACAQMSAx4PEAqWAQoEBAACAhIDIgIiGogBIFRoZSBIVFRQIHJlcXVlc3QgaGVhZGVycy4g
VGhlIG9yZGVyaW5nIG9mIHRoZSBoZWFkZXJzIGlzIHNpZ25pZmljYW50LgogTXVsdGlwbGUg
aGVhZGVycyB3aXRoIHRoZSBzYW1lIGtleSBtYXkgcHJlc2VudCBmb3IgdGhlIHJlcXVlc3Qu
CgoMCgUEAAICBBIDIgIKCgwKBQQAAgIGEgMiCxUKDAoFBAACAgESAyIWHQoMCgUEAAICAxID
IiAhClYKBAQAAgMSAyUCERpJIFRoZSBIVFRQIHJlcXVlc3QgYm9keS4gSWYgdGhlIGJvZHkg
aXMgbm90IGV4cGVjdGVkLCBpdCBzaG91bGQgYmUgZW1wdHkuCgoMCgUEAAIDBRIDJQIHCgwK
BQQAAgMBEgMlCAwKDAoFBAACAwMSAyUPEAoqCgIEARIEKQA2ARoeIFJlcHJlc2VudHMgYW4g
SFRUUCByZXNwb25zZS4KCgoKAwQBARIDKQgUCjgKBAQBAgASAysCExorIFRoZSBIVFRQIHN0
YXR1cyBjb2RlLCBzdWNoIGFzIDIwMCBvciA0MDQuCgoMCgUEAQIABRIDKwIHCgwKBQQBAgAB
EgMrCA4KDAoFBAECAAMSAysREgpDCgQEAQIBEgMuAhQaNiBUaGUgSFRUUCByZWFzb24gcGhy
YXNlLCBzdWNoIGFzICJPSyIgb3IgIk5vdCBGb3VuZCIuCgoMCgUEAQIBBRIDLgIICgwKBQQB
AgEBEgMuCQ8KDAoFBAECAQMSAy4SEwqYAQoEBAECAhIDMgIiGooBIFRoZSBIVFRQIHJlc3Bv
bnNlIGhlYWRlcnMuIFRoZSBvcmRlcmluZyBvZiB0aGUgaGVhZGVycyBpcyBzaWduaWZpY2Fu
dC4KIE11bHRpcGxlIGhlYWRlcnMgd2l0aCB0aGUgc2FtZSBrZXkgbWF5IHByZXNlbnQgZm9y
IHRoZSByZXNwb25zZS4KCgwKBQQBAgIEEgMyAgoKDAoFBAECAgYSAzILFQoMCgUEAQICARID
MhYdCgwKBQQBAgIDEgMyICEKVwoEBAECAxIDNQIRGkogVGhlIEhUVFAgcmVzcG9uc2UgYm9k
eS4gSWYgdGhlIGJvZHkgaXMgbm90IGV4cGVjdGVkLCBpdCBzaG91bGQgYmUgZW1wdHkuCgoM
CgUEAQIDBRIDNQIHCgwKBQQBAgMBEgM1CAwKDAoFBAECAwMSAzUPEAooCgIEAhIEOQA/ARoc
IFJlcHJlc2VudHMgYW4gSFRUUCBoZWFkZXIuCgoKCgMEAgESAzkIEgo7CgQEAgIAEgM7AhEa
LiBUaGUgSFRUUCBoZWFkZXIga2V5LiBJdCBpcyBjYXNlIGluc2Vuc2l0aXZlLgoKDAoFBAIC
AAUSAzsCCAoMCgUEAgIAARIDOwkMCgwKBQQCAgADEgM7DxAKJQoEBAICARIDPgITGhggVGhl
IEhUVFAgaGVhZGVyIHZhbHVlLgoKDAoFBAICAQUSAz4CCAoMCgUEAgIBARIDPgkOCgwKBQQC
AgEDEgM+ERJiBnByb3RvMw==
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Rpc::Http::HttpRequest ===
    # Fields for HttpRequest
    # Field: method Type: 9 ()
    # Field: uri Type: 9 ()
    # Field: headers Type: 11 (.google.rpc.HttpHeader)
    # Field: body Type: 12 ()

# === Message: Google::Rpc::Http::HttpResponse ===
    # Fields for HttpResponse
    # Field: status Type: 5 ()
    # Field: reason Type: 9 ()
    # Field: headers Type: 11 (.google.rpc.HttpHeader)
    # Field: body Type: 12 ()

# === Message: Google::Rpc::Http::HttpHeader ===
    # Fields for HttpHeader
    # Field: key Type: 9 ()
    # Field: value Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Rpc::Http - Compiled Protocol Buffers messages for google/rpc/http.proto

=head1 SYNOPSIS

    use Google::Rpc::Http;

    my $msg = Google::Rpc::Http::HttpRequest->new({
        method => $method,
        uri => $uri,
        headers => $headers,
        body => $body,
    });

    # Read or update a field
    my $val = $msg->method();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Rpc::Http::HttpRequest->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/rpc/http.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Rpc::Http::HttpRequest

Represents an HTTP request.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->method() >> / C<< $msg->method($value) >>

Type: C<String>

The HTTP request method.

=item * C<< $msg->uri() >> / C<< $msg->uri($value) >>

Type: C<String>

The HTTP request URI.

=item * C<< $msg->headers() >> / C<< $msg->headers($value) >>

Type: C<Message> (L<Google::Rpc::Http::HttpHeader>)

The HTTP request headers. The ordering of the headers is significant.
Multiple headers with the same key may present for the request.

=item * C<< $msg->body() >> / C<< $msg->body($value) >>

Type: C<Bytes>

The HTTP request body. If the body is not expected, it should be empty.

=back

=head2 Google::Rpc::Http::HttpResponse

Represents an HTTP response.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->status() >> / C<< $msg->status($value) >>

Type: C<Int32>

The HTTP status code, such as 200 or 404.

=item * C<< $msg->reason() >> / C<< $msg->reason($value) >>

Type: C<String>

The HTTP reason phrase, such as "OK" or "Not Found".

=item * C<< $msg->headers() >> / C<< $msg->headers($value) >>

Type: C<Message> (L<Google::Rpc::Http::HttpHeader>)

The HTTP response headers. The ordering of the headers is significant.
Multiple headers with the same key may present for the response.

=item * C<< $msg->body() >> / C<< $msg->body($value) >>

Type: C<Bytes>

The HTTP response body. If the body is not expected, it should be empty.

=back

=head2 Google::Rpc::Http::HttpHeader

Represents an HTTP header.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->key() >> / C<< $msg->key($value) >>

Type: C<String>

The HTTP header key. It is case insensitive.

=item * C<< $msg->value() >> / C<< $msg->value($value) >>

Type: C<String>

The HTTP header value.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Rpc::Http::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

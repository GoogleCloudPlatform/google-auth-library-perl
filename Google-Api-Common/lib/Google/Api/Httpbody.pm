package Google::Api::Httpbody;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    eval { require Google::Protobuf::Any };
    my $descriptor_b64 = <<'EOF';
Chlnb29nbGUvYXBpL2h0dHBib2R5LnByb3RvEgpnb29nbGUuYXBpGhlnb29nbGUvcHJvdG9i
dWYvYW55LnByb3RvIncKCEh0dHBCb2R5EiEKDGNvbnRlbnRfdHlwZRgBIAEoCVILY29udGVu
dFR5cGUSEgoEZGF0YRgCIAEoDFIEZGF0YRI0CgpleHRlbnNpb25zGAMgAygLMhQuZ29vZ2xl
LnByb3RvYnVmLkFueVIKZXh0ZW5zaW9uc0JlCg5jb20uZ29vZ2xlLmFwaUINSHR0cEJvZHlQ
cm90b1ABWjtnb29nbGUuZ29sYW5nLm9yZy9nZW5wcm90by9nb29nbGVhcGlzL2FwaS9odHRw
Ym9keTtodHRwYm9keaICBEdBUElKmxMKBhIEDgBPAQq8BAoBDBIDDgASMrEEIENvcHlyaWdo
dCAyMDI2IEdvb2dsZSBMTEMKCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2Us
IFZlcnNpb24gMi4wICh0aGUgIkxpY2Vuc2UiKTsKIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZp
bGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS4KIFlvdSBtYXkgb2J0
YWluIGEgY29weSBvZiB0aGUgTGljZW5zZSBhdAoKICAgICBodHRwOi8vd3d3LmFwYWNoZS5v
cmcvbGljZW5zZXMvTElDRU5TRS0yLjAKCiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJs
ZSBsYXcgb3IgYWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlCiBkaXN0cmlidXRlZCB1
bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiAiQVMgSVMiIEJBU0lTLAog
V0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBl
eHByZXNzIG9yIGltcGxpZWQuCiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBs
YW5ndWFnZSBnb3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kCiBsaW1pdGF0aW9ucyB1bmRlciB0
aGUgTGljZW5zZS4KCggKAQISAxAAEwoJCgIDABIDEgAjCggKAQgSAxQAUgoJCgIICxIDFABS
CggKAQgSAxUAIgoJCgIIChIDFQAiCggKAQgSAxYALgoJCgIICBIDFgAuCggKAQgSAxcAJwoJ
CgIIARIDFwAnCggKAQgSAxgAIgoJCgIIJBIDGAAiCrIKCgIEABIERQBPARqlCiBNZXNzYWdl
IHRoYXQgcmVwcmVzZW50cyBhbiBhcmJpdHJhcnkgSFRUUCBib2R5LiBJdCBzaG91bGQgb25s
eSBiZSB1c2VkIGZvcgogcGF5bG9hZCBmb3JtYXRzIHRoYXQgY2FuJ3QgYmUgcmVwcmVzZW50
ZWQgYXMgSlNPTiwgc3VjaCBhcyByYXcgYmluYXJ5IG9yCiBhbiBIVE1MIHBhZ2UuCgoKIFRo
aXMgbWVzc2FnZSBjYW4gYmUgdXNlZCBib3RoIGluIHN0cmVhbWluZyBhbmQgbm9uLXN0cmVh
bWluZyBBUEkgbWV0aG9kcyBpbgogdGhlIHJlcXVlc3QgYXMgd2VsbCBhcyB0aGUgcmVzcG9u
c2UuCgogSXQgY2FuIGJlIHVzZWQgYXMgYSB0b3AtbGV2ZWwgcmVxdWVzdCBmaWVsZCwgd2hp
Y2ggaXMgY29udmVuaWVudCBpZiBvbmUKIHdhbnRzIHRvIGV4dHJhY3QgcGFyYW1ldGVycyBm
cm9tIGVpdGhlciB0aGUgVVJMIG9yIEhUVFAgdGVtcGxhdGUgaW50byB0aGUKIHJlcXVlc3Qg
ZmllbGRzIGFuZCBhbHNvIHdhbnQgYWNjZXNzIHRvIHRoZSByYXcgSFRUUCBib2R5LgoKIEV4
YW1wbGU6CgogICAgIG1lc3NhZ2UgR2V0UmVzb3VyY2VSZXF1ZXN0IHsKICAgICAgIC8vIEEg
dW5pcXVlIHJlcXVlc3QgaWQuCiAgICAgICBzdHJpbmcgcmVxdWVzdF9pZCA9IDE7CgogICAg
ICAgLy8gVGhlIHJhdyBIVFRQIGJvZHkgaXMgYm91bmQgdG8gdGhpcyBmaWVsZC4KICAgICAg
IGdvb2dsZS5hcGkuSHR0cEJvZHkgaHR0cF9ib2R5ID0gMjsKCiAgICAgfQoKICAgICBzZXJ2
aWNlIFJlc291cmNlU2VydmljZSB7CiAgICAgICBycGMgR2V0UmVzb3VyY2UoR2V0UmVzb3Vy
Y2VSZXF1ZXN0KQogICAgICAgICByZXR1cm5zIChnb29nbGUuYXBpLkh0dHBCb2R5KTsKICAg
ICAgIHJwYyBVcGRhdGVSZXNvdXJjZShnb29nbGUuYXBpLkh0dHBCb2R5KQogICAgICAgICBy
ZXR1cm5zIChnb29nbGUucHJvdG9idWYuRW1wdHkpOwoKICAgICB9CgogRXhhbXBsZSB3aXRo
IHN0cmVhbWluZyBtZXRob2RzOgoKICAgICBzZXJ2aWNlIENhbGRhdlNlcnZpY2UgewogICAg
ICAgcnBjIEdldENhbGVuZGFyKHN0cmVhbSBnb29nbGUuYXBpLkh0dHBCb2R5KQogICAgICAg
ICByZXR1cm5zIChzdHJlYW0gZ29vZ2xlLmFwaS5IdHRwQm9keSk7CiAgICAgICBycGMgVXBk
YXRlQ2FsZW5kYXIoc3RyZWFtIGdvb2dsZS5hcGkuSHR0cEJvZHkpCiAgICAgICAgIHJldHVy
bnMgKHN0cmVhbSBnb29nbGUuYXBpLkh0dHBCb2R5KTsKCiAgICAgfQoKIFVzZSBvZiB0aGlz
IHR5cGUgb25seSBjaGFuZ2VzIGhvdyB0aGUgcmVxdWVzdCBhbmQgcmVzcG9uc2UgYm9kaWVz
IGFyZQogaGFuZGxlZCwgYWxsIG90aGVyIGZlYXR1cmVzIHdpbGwgY29udGludWUgdG8gd29y
ayB1bmNoYW5nZWQuCgoKCgMEAAESA0UIEApaCgQEAAIAEgNHAhoaTSBUaGUgSFRUUCBDb250
ZW50LVR5cGUgaGVhZGVyIHZhbHVlIHNwZWNpZnlpbmcgdGhlIGNvbnRlbnQgdHlwZSBvZiB0
aGUgYm9keS4KCgwKBQQAAgAFEgNHAggKDAoFBAACAAESA0cJFQoMCgUEAAIAAxIDRxgZCjwK
BAQAAgESA0oCERovIFRoZSBIVFRQIHJlcXVlc3QvcmVzcG9uc2UgYm9keSBhcyByYXcgYmlu
YXJ5LgoKDAoFBAACAQUSA0oCBwoMCgUEAAIBARIDSggMCgwKBQQAAgEDEgNKDxAKbQoEBAAC
AhIDTgIuGmAgQXBwbGljYXRpb24gc3BlY2lmaWMgcmVzcG9uc2UgbWV0YWRhdGEuIE11c3Qg
YmUgc2V0IGluIHRoZSBmaXJzdCByZXNwb25zZQogZm9yIHN0cmVhbWluZyBBUElzLgoKDAoF
BAACAgQSA04CCgoMCgUEAAICBhIDTgseCgwKBQQAAgIBEgNOHykKDAoFBAACAgMSA04sLWIG
cHJvdG8z
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Httpbody::HttpBody ===
    # Fields for HttpBody
    # Field: content_type Type: 9 ()
    # Field: data Type: 12 ()
    # Field: extensions Type: 11 (.google.protobuf.Any)

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Httpbody - Compiled Protocol Buffers messages for google/api/httpbody.proto

=head1 SYNOPSIS

    use Google::Api::Httpbody;

    my $msg = Google::Api::Httpbody::HttpBody->new({
        content_type => $content_type,
        data => $data,
        extensions => $extensions,
    });

    # Read or update a field
    my $val = $msg->content_type();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Httpbody::HttpBody->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/httpbody.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Httpbody::HttpBody

Message that represents an arbitrary HTTP body. It should only be used for
payload formats that can't be represented as JSON, such as raw binary or
an HTML page.


This message can be used both in streaming and non-streaming API methods in
the request as well as the response.

It can be used as a top-level request field, which is convenient if one
wants to extract parameters from either the URL or HTTP template into the
request fields and also want access to the raw HTTP body.

Example:

    message GetResourceRequest {
      // A unique request id.
      string request_id = 1;

      // The raw HTTP body is bound to this field.
      google.api.HttpBody http_body = 2;

    }

    service ResourceService {
      rpc GetResource(GetResourceRequest)
        returns (google.api.HttpBody);
      rpc UpdateResource(google.api.HttpBody)
        returns (google.protobuf.Empty);

    }

Example with streaming methods:

    service CaldavService {
      rpc GetCalendar(stream google.api.HttpBody)
        returns (stream google.api.HttpBody);
      rpc UpdateCalendar(stream google.api.HttpBody)
        returns (stream google.api.HttpBody);

    }

Use of this type only changes how the request and response bodies are
handled, all other features will continue to work unchanged.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->content_type() >> / C<< $msg->content_type($value) >>

Type: C<String>

The HTTP Content-Type header value specifying the content type of the body.

=item * C<< $msg->data() >> / C<< $msg->data($value) >>

Type: C<Bytes>

The HTTP request/response body as raw binary.

=item * C<< $msg->extensions() >> / C<< $msg->extensions($value) >>

Type: C<Message> (L<Google::Protobuf::Any::Any>)

Application specific response metadata. Must be set in the first response
for streaming APIs.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Httpbody::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

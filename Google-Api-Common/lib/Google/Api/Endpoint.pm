package Google::Api::Endpoint;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Chlnb29nbGUvYXBpL2VuZHBvaW50LnByb3RvEgpnb29nbGUuYXBpIm8KCEVuZHBvaW50EhIK
BG5hbWUYASABKAlSBG5hbWUSGAoHYWxpYXNlcxgCIAMoCVIHYWxpYXNlcxIWCgZ0YXJnZXQY
ZSABKAlSBnRhcmdldBIdCgphbGxvd19jb3JzGAUgASgIUglhbGxvd0NvcnNCbwoOY29tLmdv
b2dsZS5hcGlCDUVuZHBvaW50UHJvdG9QAVpFZ29vZ2xlLmdvbGFuZy5vcmcvZ2VucHJvdG8v
Z29vZ2xlYXBpcy9hcGkvc2VydmljZWNvbmZpZztzZXJ2aWNlY29uZmlnogIER0FQSUrLFQoG
EgQOAEQBCrwECgEMEgMOABIysQQgQ29weXJpZ2h0IDIwMjYgR29vZ2xlIExMQwoKIExpY2Vu
c2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSAiTGljZW5z
ZSIpOwogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3
aXRoIHRoZSBMaWNlbnNlLgogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNl
IGF0CgogICAgIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMAoK
IFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3Jp
dGluZywgc29mdHdhcmUKIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3Ry
aWJ1dGVkIG9uIGFuICJBUyBJUyIgQkFTSVMsCiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09O
RElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC4KIFNlZSB0
aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNz
aW9ucyBhbmQKIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLgoKCAoBAhIDEAATCggK
AQgSAxIAXAoJCgIICxIDEgBcCggKAQgSAxMAIgoJCgIIChIDEwAiCggKAQgSAxQALgoJCgII
CBIDFAAuCggKAQgSAxUAJwoJCgIIARIDFQAnCggKAQgSAxYAIgoJCgIIJBIDFgAiCtAHCgIE
ABIELQBEARrDByBgRW5kcG9pbnRgIGRlc2NyaWJlcyBhIG5ldHdvcmsgYWRkcmVzcyBvZiBh
IHNlcnZpY2UgdGhhdCBzZXJ2ZXMgYSBzZXQgb2YKIEFQSXMuIEl0IGlzIGNvbW1vbmx5IGtu
b3duIGFzIGEgc2VydmljZSBlbmRwb2ludC4gQSBzZXJ2aWNlIG1heSBleHBvc2UKIGFueSBu
dW1iZXIgb2Ygc2VydmljZSBlbmRwb2ludHMsIGFuZCBhbGwgc2VydmljZSBlbmRwb2ludHMg
c2hhcmUgdGhlIHNhbWUKIHNlcnZpY2UgZGVmaW5pdGlvbiwgc3VjaCBhcyBxdW90YSBsaW1p
dHMgYW5kIG1vbml0b3JpbmcgbWV0cmljcy4KCiBFeGFtcGxlOgoKICAgICB0eXBlOiBnb29n
bGUuYXBpLlNlcnZpY2UKICAgICBuYW1lOiBsaWJyYXJ5LWV4YW1wbGUuZ29vZ2xlYXBpcy5j
b20KICAgICBlbmRwb2ludHM6CiAgICAgICAjIERlY2xhcmVzIG5ldHdvcmsgYWRkcmVzcyBg
aHR0cHM6Ly9saWJyYXJ5LWV4YW1wbGUuZ29vZ2xlYXBpcy5jb21gCiAgICAgICAjIGZvciBz
ZXJ2aWNlIGBsaWJyYXJ5LWV4YW1wbGUuZ29vZ2xlYXBpcy5jb21gLiBUaGUgYGh0dHBzYCBz
Y2hlbWUKICAgICAgICMgaXMgaW1wbGljaXQgZm9yIGFsbCBzZXJ2aWNlIGVuZHBvaW50cy4g
T3RoZXIgc2NoZW1lcyBtYXkgYmUKICAgICAgICMgc3VwcG9ydGVkIGluIHRoZSBmdXR1cmUu
CiAgICAgLSBuYW1lOiBsaWJyYXJ5LWV4YW1wbGUuZ29vZ2xlYXBpcy5jb20KICAgICAgIGFs
bG93X2NvcnM6IGZhbHNlCiAgICAgLSBuYW1lOiBjb250ZW50LXN0YWdpbmctbGlicmFyeS1l
eGFtcGxlLmdvb2dsZWFwaXMuY29tCiAgICAgICAjIEFsbG93cyBIVFRQIE9QVElPTlMgY2Fs
bHMgdG8gYmUgcGFzc2VkIHRvIHRoZSBBUEkgZnJvbnRlbmQsIGZvciBpdAogICAgICAgIyB0
byBkZWNpZGUgd2hldGhlciB0aGUgc3Vic2VxdWVudCBjcm9zcy1vcmlnaW4gcmVxdWVzdCBp
cyBhbGxvd2VkCiAgICAgICAjIHRvIHByb2NlZWQuCiAgICAgICBhbGxvd19jb3JzOiB0cnVl
CgoKCgMEAAESAy0IEAozCgQEAAIAEgMvAhIaJiBUaGUgY2Fub25pY2FsIG5hbWUgb2YgdGhp
cyBlbmRwb2ludC4KCgwKBQQAAgAFEgMvAggKDAoFBAACAAESAy8JDQoMCgUEAAIAAxIDLxAR
CrEBCgQEAAIBEgM0Ah4aowEgQWxpYXNlcyBmb3IgdGhpcyBlbmRwb2ludCwgdGhlc2Ugd2ls
bCBiZSBzZXJ2ZWQgYnkgdGhlIHNhbWUgVXJsTWFwIGFzIHRoZQogcGFyZW50IGVuZHBvaW50
LCBhbmQgd2lsbCBiZSBwcm92aXNpb25lZCBpbiB0aGUgR0NQIHN0YWNrIGZvciB0aGUgUmVn
aW9uYWwKIEVuZHBvaW50cy4KCgwKBQQAAgEEEgM0AgoKDAoFBAACAQUSAzQLEQoMCgUEAAIB
ARIDNBIZCgwKBQQAAgEDEgM0HB0KtAIKBAQAAgISAzsCFhqmAiBUaGUgc3BlY2lmaWNhdGlv
biBvZiBhbiBJbnRlcm5ldCByb3V0YWJsZSBhZGRyZXNzIG9mIEFQSSBmcm9udGVuZCB0aGF0
IHdpbGwKIGhhbmRsZSByZXF1ZXN0cyB0byB0aGlzIFtBUEkKIEVuZHBvaW50XShodHRwczov
L2Nsb3VkLmdvb2dsZS5jb20vYXBpcy9kZXNpZ24vZ2xvc3NhcnkpLiBJdCBzaG91bGQgYmUK
IGVpdGhlciBhIHZhbGlkIElQdjQgYWRkcmVzcyBvciBhIGZ1bGx5LXF1YWxpZmllZCBkb21h
aW4gbmFtZS4gRm9yIGV4YW1wbGUsCiAiOC44LjguOCIgb3IgIm15c2VydmljZS5hcHBzcG90
LmNvbSIuCgoMCgUEAAICBRIDOwIICgwKBQQAAgIBEgM7CQ8KDAoFBAACAgMSAzsSFQrZAgoE
BAACAxIDQwIWGssCIEFsbG93aW5nCiBbQ09SU10oaHR0cHM6Ly9lbi53aWtpcGVkaWEub3Jn
L3dpa2kvQ3Jvc3Mtb3JpZ2luX3Jlc291cmNlX3NoYXJpbmcpLCBha2EKIGNyb3NzLWRvbWFp
biB0cmFmZmljLCB3b3VsZCBhbGxvdyB0aGUgYmFja2VuZHMgc2VydmVkIGZyb20gdGhpcyBl
bmRwb2ludCB0bwogcmVjZWl2ZSBhbmQgcmVzcG9uZCB0byBIVFRQIE9QVElPTlMgcmVxdWVz
dHMuIFRoZSByZXNwb25zZSB3aWxsIGJlIHVzZWQgYnkKIHRoZSBicm93c2VyIHRvIGRldGVy
bWluZSB3aGV0aGVyIHRoZSBzdWJzZXF1ZW50IGNyb3NzLW9yaWdpbiByZXF1ZXN0IGlzCiBh
bGxvd2VkIHRvIHByb2NlZWQuCgoMCgUEAAIDBRIDQwIGCgwKBQQAAgMBEgNDBxEKDAoFBAAC
AwMSA0MUFWIGcHJvdG8z
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Endpoint::Endpoint ===
    # Fields for Endpoint
    # Field: name Type: 9 ()
    # Field: aliases Type: 9 ()
    # Field: target Type: 9 ()
    # Field: allow_cors Type: 8 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Endpoint - Compiled Protocol Buffers messages for google/api/endpoint.proto

=head1 SYNOPSIS

    use Google::Api::Endpoint;

    my $msg = Google::Api::Endpoint::Endpoint->new({
        name => $name,
        aliases => $aliases,
        target => $target,
        allow_cors => $allow_cors,
    });

    # Read or update a field
    my $val = $msg->name();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Endpoint::Endpoint->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/endpoint.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Endpoint::Endpoint

`Endpoint` describes a network address of a service that serves a set of
APIs. It is commonly known as a service endpoint. A service may expose
any number of service endpoints, and all service endpoints share the same
service definition, such as quota limits and monitoring metrics.

Example:

    type: google.api.Service
    name: library-example.googleapis.com
    endpoints:
      # Declares network address `https://library-example.googleapis.com`
      # for service `library-example.googleapis.com`. The `https` scheme
      # is implicit for all service endpoints. Other schemes may be
      # supported in the future.
    - name: library-example.googleapis.com
      allow_cors: false
    - name: content-staging-library-example.googleapis.com
      # Allows HTTP OPTIONS calls to be passed to the API frontend, for it
      # to decide whether the subsequent cross-origin request is allowed
      # to proceed.
      allow_cors: true

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->name() >> / C<< $msg->name($value) >>

Type: C<String>

The canonical name of this endpoint.

=item * C<< $msg->aliases() >> / C<< $msg->aliases($value) >>

Type: C<String>

Aliases for this endpoint, these will be served by the same UrlMap as the
parent endpoint, and will be provisioned in the GCP stack for the Regional
Endpoints.

=item * C<< $msg->target() >> / C<< $msg->target($value) >>

Type: C<String>

The specification of an Internet routable address of API frontend that will
handle requests to this [API
Endpoint](https://cloud.google.com/apis/design/glossary). It should be
either a valid IPv4 address or a fully-qualified domain name. For example,
"8.8.8.8" or "myservice.appspot.com".

=item * C<< $msg->allow_cors() >> / C<< $msg->allow_cors($value) >>

Type: C<Bool>

Allowing
[CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing), aka
cross-domain traffic, would allow the backends served from this endpoint to
receive and respond to HTTP OPTIONS requests. The response will be used by
the browser to determine whether the subsequent cross-origin request is
allowed to proceed.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Endpoint::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

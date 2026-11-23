package Google::Api::Monitoring;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Chtnb29nbGUvYXBpL21vbml0b3JpbmcucHJvdG8SCmdvb2dsZS5hcGkitAIKCk1vbml0b3Jp
bmcSYQoVcHJvZHVjZXJfZGVzdGluYXRpb25zGAEgAygLMiwuZ29vZ2xlLmFwaS5Nb25pdG9y
aW5nLk1vbml0b3JpbmdEZXN0aW5hdGlvblIUcHJvZHVjZXJEZXN0aW5hdGlvbnMSYQoVY29u
c3VtZXJfZGVzdGluYXRpb25zGAIgAygLMiwuZ29vZ2xlLmFwaS5Nb25pdG9yaW5nLk1vbml0
b3JpbmdEZXN0aW5hdGlvblIUY29uc3VtZXJEZXN0aW5hdGlvbnMaYAoVTW9uaXRvcmluZ0Rl
c3RpbmF0aW9uEi0KEm1vbml0b3JlZF9yZXNvdXJjZRgBIAEoCVIRbW9uaXRvcmVkUmVzb3Vy
Y2USGAoHbWV0cmljcxgCIAMoCVIHbWV0cmljc0JxCg5jb20uZ29vZ2xlLmFwaUIPTW9uaXRv
cmluZ1Byb3RvUAFaRWdvb2dsZS5nb2xhbmcub3JnL2dlbnByb3RvL2dvb2dsZWFwaXMvYXBp
L3NlcnZpY2Vjb25maWc7c2VydmljZWNvbmZpZ6ICBEdBUElK0yAKBhIEDgBqAQq8BAoBDBID
DgASMrEEIENvcHlyaWdodCAyMDI2IEdvb2dsZSBMTEMKCiBMaWNlbnNlZCB1bmRlciB0aGUg
QXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0aGUgIkxpY2Vuc2UiKTsKIHlvdSBtYXkg
bm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5z
ZS4KIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0aGUgTGljZW5zZSBhdAoKICAgICBodHRw
Oi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAKCiBVbmxlc3MgcmVxdWly
ZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJl
CiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiAi
QVMgSVMiIEJBU0lTLAogV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5Z
IEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuCiBTZWUgdGhlIExpY2Vuc2UgZm9y
IHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kCiBsaW1p
dGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS4KCggKAQISAxAAEwoICgEIEgMSAFwKCQoCCAsS
AxIAXAoICgEIEgMTACIKCQoCCAoSAxMAIgoICgEIEgMUADAKCQoCCAgSAxQAMAoICgEIEgMV
ACcKCQoCCAESAxUAJwoICgEIEgMWACIKCQoCCCQSAxYAIgqeDwoCBAASBEwAagEakQ8gTW9u
aXRvcmluZyBjb25maWd1cmF0aW9uIG9mIHRoZSBzZXJ2aWNlLgoKIFRoZSBleGFtcGxlIGJl
bG93IHNob3dzIGhvdyB0byBjb25maWd1cmUgbW9uaXRvcmVkIHJlc291cmNlcyBhbmQgbWV0
cmljcwogZm9yIG1vbml0b3JpbmcuIEluIHRoZSBleGFtcGxlLCBhIG1vbml0b3JlZCByZXNv
dXJjZSBhbmQgdHdvIG1ldHJpY3MgYXJlCiBkZWZpbmVkLiBUaGUgYGxpYnJhcnkuZ29vZ2xl
YXBpcy5jb20vYm9vay9yZXR1cm5lZF9jb3VudGAgbWV0cmljIGlzIHNlbnQKIHRvIGJvdGgg
cHJvZHVjZXIgYW5kIGNvbnN1bWVyIHByb2plY3RzLCB3aGVyZWFzIHRoZQogYGxpYnJhcnku
Z29vZ2xlYXBpcy5jb20vYm9vay9udW1fb3ZlcmR1ZWAgbWV0cmljIGlzIG9ubHkgc2VudCB0
byB0aGUKIGNvbnN1bWVyIHByb2plY3QuCgogICAgIG1vbml0b3JlZF9yZXNvdXJjZXM6CiAg
ICAgLSB0eXBlOiBsaWJyYXJ5Lmdvb2dsZWFwaXMuY29tL0JyYW5jaAogICAgICAgZGlzcGxh
eV9uYW1lOiAiTGlicmFyeSBCcmFuY2giCiAgICAgICBkZXNjcmlwdGlvbjogIkEgYnJhbmNo
IG9mIGEgbGlicmFyeS4iCiAgICAgICBsYXVuY2hfc3RhZ2U6IEdBCiAgICAgICBsYWJlbHM6
CiAgICAgICAtIGtleTogcmVzb3VyY2VfY29udGFpbmVyCiAgICAgICAgIGRlc2NyaXB0aW9u
OiAiVGhlIENsb3VkIGNvbnRhaW5lciAoaWUuIHByb2plY3QgaWQpIGZvciB0aGUgQnJhbmNo
LiIKICAgICAgIC0ga2V5OiBsb2NhdGlvbgogICAgICAgICBkZXNjcmlwdGlvbjogIlRoZSBs
b2NhdGlvbiBvZiB0aGUgbGlicmFyeSBicmFuY2guIgogICAgICAgLSBrZXk6IGJyYW5jaF9p
ZAogICAgICAgICBkZXNjcmlwdGlvbjogIlRoZSBpZCBvZiB0aGUgYnJhbmNoLiIKICAgICBt
ZXRyaWNzOgogICAgIC0gbmFtZTogbGlicmFyeS5nb29nbGVhcGlzLmNvbS9ib29rL3JldHVy
bmVkX2NvdW50CiAgICAgICBkaXNwbGF5X25hbWU6ICJCb29rcyBSZXR1cm5lZCIKICAgICAg
IGRlc2NyaXB0aW9uOiAiVGhlIGNvdW50IG9mIGJvb2tzIHRoYXQgaGF2ZSBiZWVuIHJldHVy
bmVkLiIKICAgICAgIGxhdW5jaF9zdGFnZTogR0EKICAgICAgIG1ldHJpY19raW5kOiBERUxU
QQogICAgICAgdmFsdWVfdHlwZTogSU5UNjQKICAgICAgIHVuaXQ6ICIxIgogICAgICAgbGFi
ZWxzOgogICAgICAgLSBrZXk6IGN1c3RvbWVyX2lkCiAgICAgICAgIGRlc2NyaXB0aW9uOiAi
VGhlIGlkIG9mIHRoZSBjdXN0b21lci4iCiAgICAgLSBuYW1lOiBsaWJyYXJ5Lmdvb2dsZWFw
aXMuY29tL2Jvb2svbnVtX292ZXJkdWUKICAgICAgIGRpc3BsYXlfbmFtZTogIkJvb2tzIE92
ZXJkdWUiCiAgICAgICBkZXNjcmlwdGlvbjogIlRoZSBjdXJyZW50IG51bWJlciBvZiBvdmVy
ZHVlIGJvb2tzLiIKICAgICAgIGxhdW5jaF9zdGFnZTogR0EKICAgICAgIG1ldHJpY19raW5k
OiBHQVVHRQogICAgICAgdmFsdWVfdHlwZTogSU5UNjQKICAgICAgIHVuaXQ6ICIxIgogICAg
ICAgbGFiZWxzOgogICAgICAgLSBrZXk6IGN1c3RvbWVyX2lkCiAgICAgICAgIGRlc2NyaXB0
aW9uOiAiVGhlIGlkIG9mIHRoZSBjdXN0b21lci4iCiAgICAgbW9uaXRvcmluZzoKICAgICAg
IHByb2R1Y2VyX2Rlc3RpbmF0aW9uczoKICAgICAgIC0gbW9uaXRvcmVkX3Jlc291cmNlOiBs
aWJyYXJ5Lmdvb2dsZWFwaXMuY29tL0JyYW5jaAogICAgICAgICBtZXRyaWNzOgogICAgICAg
ICAtIGxpYnJhcnkuZ29vZ2xlYXBpcy5jb20vYm9vay9yZXR1cm5lZF9jb3VudAogICAgICAg
Y29uc3VtZXJfZGVzdGluYXRpb25zOgogICAgICAgLSBtb25pdG9yZWRfcmVzb3VyY2U6IGxp
YnJhcnkuZ29vZ2xlYXBpcy5jb20vQnJhbmNoCiAgICAgICAgIG1ldHJpY3M6CiAgICAgICAg
IC0gbGlicmFyeS5nb29nbGVhcGlzLmNvbS9ib29rL3JldHVybmVkX2NvdW50CiAgICAgICAg
IC0gbGlicmFyeS5nb29nbGVhcGlzLmNvbS9ib29rL251bV9vdmVyZHVlCgoKCgMEAAESA0wI
EgpzCgQEAAMAEgRPAlkDGmUgQ29uZmlndXJhdGlvbiBvZiBhIHNwZWNpZmljIG1vbml0b3Jp
bmcgZGVzdGluYXRpb24gKHRoZSBwcm9kdWNlciBwcm9qZWN0CiBvciB0aGUgY29uc3VtZXIg
cHJvamVjdCkuCgoMCgUEAAMAARIDTwofCpsBCgYEAAMAAgASA1MEIhqLASBUaGUgbW9uaXRv
cmVkIHJlc291cmNlIHR5cGUuIFRoZSB0eXBlIG11c3QgYmUgZGVmaW5lZCBpbgogW1NlcnZp
Y2UubW9uaXRvcmVkX3Jlc291cmNlc11bZ29vZ2xlLmFwaS5TZXJ2aWNlLm1vbml0b3JlZF9y
ZXNvdXJjZXNdCiBzZWN0aW9uLgoKDgoHBAADAAIABRIDUwQKCg4KBwQAAwACAAESA1MLHQoO
CgcEAAMAAgADEgNTICEKpgEKBgQAAwACARIDWAQgGpYBIFR5cGVzIG9mIHRoZSBtZXRyaWNz
IHRvIHJlcG9ydCB0byB0aGlzIG1vbml0b3JpbmcgZGVzdGluYXRpb24uCiBFYWNoIHR5cGUg
bXVzdCBiZSBkZWZpbmVkIGluCiBbU2VydmljZS5tZXRyaWNzXVtnb29nbGUuYXBpLlNlcnZp
Y2UubWV0cmljc10gc2VjdGlvbi4KCg4KBwQAAwACAQQSA1gEDAoOCgcEAAMAAgEFEgNYDRMK
DgoHBAADAAIBARIDWBQbCg4KBwQAAwACAQMSA1geHwqeAwoEBAACABIDYQI7GpADIE1vbml0
b3JpbmcgY29uZmlndXJhdGlvbnMgZm9yIHNlbmRpbmcgbWV0cmljcyB0byB0aGUgcHJvZHVj
ZXIgcHJvamVjdC4KIFRoZXJlIGNhbiBiZSBtdWx0aXBsZSBwcm9kdWNlciBkZXN0aW5hdGlv
bnMuIEEgbW9uaXRvcmVkIHJlc291cmNlIHR5cGUgbWF5CiBhcHBlYXIgaW4gbXVsdGlwbGUg
bW9uaXRvcmluZyBkZXN0aW5hdGlvbnMgaWYgZGlmZmVyZW50IGFnZ3JlZ2F0aW9ucyBhcmUK
IG5lZWRlZCBmb3IgZGlmZmVyZW50IHNldHMgb2YgbWV0cmljcyBhc3NvY2lhdGVkIHdpdGgg
dGhhdCBtb25pdG9yZWQKIHJlc291cmNlIHR5cGUuIEEgbW9uaXRvcmVkIHJlc291cmNlIGFu
ZCBtZXRyaWMgcGFpciBtYXkgb25seSBiZSB1c2VkIG9uY2UKIGluIHRoZSBNb25pdG9yaW5n
IGNvbmZpZ3VyYXRpb24uCgoMCgUEAAIABBIDYQIKCgwKBQQAAgAGEgNhCyAKDAoFBAACAAES
A2EhNgoMCgUEAAIAAxIDYTk6Cp4DCgQEAAIBEgNpAjsakAMgTW9uaXRvcmluZyBjb25maWd1
cmF0aW9ucyBmb3Igc2VuZGluZyBtZXRyaWNzIHRvIHRoZSBjb25zdW1lciBwcm9qZWN0Lgog
VGhlcmUgY2FuIGJlIG11bHRpcGxlIGNvbnN1bWVyIGRlc3RpbmF0aW9ucy4gQSBtb25pdG9y
ZWQgcmVzb3VyY2UgdHlwZSBtYXkKIGFwcGVhciBpbiBtdWx0aXBsZSBtb25pdG9yaW5nIGRl
c3RpbmF0aW9ucyBpZiBkaWZmZXJlbnQgYWdncmVnYXRpb25zIGFyZQogbmVlZGVkIGZvciBk
aWZmZXJlbnQgc2V0cyBvZiBtZXRyaWNzIGFzc29jaWF0ZWQgd2l0aCB0aGF0IG1vbml0b3Jl
ZAogcmVzb3VyY2UgdHlwZS4gQSBtb25pdG9yZWQgcmVzb3VyY2UgYW5kIG1ldHJpYyBwYWly
IG1heSBvbmx5IGJlIHVzZWQgb25jZQogaW4gdGhlIE1vbml0b3JpbmcgY29uZmlndXJhdGlv
bi4KCgwKBQQAAgEEEgNpAgoKDAoFBAACAQYSA2kLIAoMCgUEAAIBARIDaSE2CgwKBQQAAgED
EgNpOTpiBnByb3RvMw==
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Monitoring::Monitoring ===
    # Fields for Monitoring
    # Field: producer_destinations Type: 11 (.google.api.Monitoring.MonitoringDestination)
    # Field: consumer_destinations Type: 11 (.google.api.Monitoring.MonitoringDestination)

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Monitoring - Compiled Protocol Buffers messages for google/api/monitoring.proto

=head1 SYNOPSIS

    use Google::Api::Monitoring;

    my $msg = Google::Api::Monitoring::Monitoring->new({
        producer_destinations => $producer_destinations,
        consumer_destinations => $consumer_destinations,
    });

    # Read or update a field
    my $val = $msg->producer_destinations();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Monitoring::Monitoring->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/monitoring.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Monitoring::Monitoring

Monitoring configuration of the service.

The example below shows how to configure monitored resources and metrics
for monitoring. In the example, a monitored resource and two metrics are
defined. The `library.googleapis.com/book/returned_count` metric is sent
to both producer and consumer projects, whereas the
`library.googleapis.com/book/num_overdue` metric is only sent to the
consumer project.

    monitored_resources:
    - type: library.googleapis.com/Branch
      display_name: "Library Branch"
      description: "A branch of a library."
      launch_stage: GA
      labels:
      - key: resource_container
        description: "The Cloud container (ie. project id) for the Branch."
      - key: location
        description: "The location of the library branch."
      - key: branch_id
        description: "The id of the branch."
    metrics:
    - name: library.googleapis.com/book/returned_count
      display_name: "Books Returned"
      description: "The count of books that have been returned."
      launch_stage: GA
      metric_kind: DELTA
      value_type: INT64
      unit: "1"
      labels:
      - key: customer_id
        description: "The id of the customer."
    - name: library.googleapis.com/book/num_overdue
      display_name: "Books Overdue"
      description: "The current number of overdue books."
      launch_stage: GA
      metric_kind: GAUGE
      value_type: INT64
      unit: "1"
      labels:
      - key: customer_id
        description: "The id of the customer."
    monitoring:
      producer_destinations:
      - monitored_resource: library.googleapis.com/Branch
        metrics:
        - library.googleapis.com/book/returned_count
      consumer_destinations:
      - monitored_resource: library.googleapis.com/Branch
        metrics:
        - library.googleapis.com/book/returned_count
        - library.googleapis.com/book/num_overdue

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->producer_destinations() >> / C<< $msg->producer_destinations($value) >>

Type: C<Message> (L<Google::Api::Monitoring::Monitoring::MonitoringDestination>)

Monitoring configurations for sending metrics to the producer project.
There can be multiple producer destinations. A monitored resource type may
appear in multiple monitoring destinations if different aggregations are
needed for different sets of metrics associated with that monitored
resource type. A monitored resource and metric pair may only be used once
in the Monitoring configuration.

=item * C<< $msg->consumer_destinations() >> / C<< $msg->consumer_destinations($value) >>

Type: C<Message> (L<Google::Api::Monitoring::Monitoring::MonitoringDestination>)

Monitoring configurations for sending metrics to the consumer project.
There can be multiple consumer destinations. A monitored resource type may
appear in multiple monitoring destinations if different aggregations are
needed for different sets of metrics associated with that monitored
resource type. A monitored resource and metric pair may only be used once
in the Monitoring configuration.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Monitoring::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

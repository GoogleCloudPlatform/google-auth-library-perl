package Google::Api::Logging;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Chhnb29nbGUvYXBpL2xvZ2dpbmcucHJvdG8SCmdvb2dsZS5hcGkinAIKB0xvZ2dpbmcSWwoV
cHJvZHVjZXJfZGVzdGluYXRpb25zGAEgAygLMiYuZ29vZ2xlLmFwaS5Mb2dnaW5nLkxvZ2dp
bmdEZXN0aW5hdGlvblIUcHJvZHVjZXJEZXN0aW5hdGlvbnMSWwoVY29uc3VtZXJfZGVzdGlu
YXRpb25zGAIgAygLMiYuZ29vZ2xlLmFwaS5Mb2dnaW5nLkxvZ2dpbmdEZXN0aW5hdGlvblIU
Y29uc3VtZXJEZXN0aW5hdGlvbnMaVwoSTG9nZ2luZ0Rlc3RpbmF0aW9uEi0KEm1vbml0b3Jl
ZF9yZXNvdXJjZRgDIAEoCVIRbW9uaXRvcmVkUmVzb3VyY2USEgoEbG9ncxgBIAMoCVIEbG9n
c0JuCg5jb20uZ29vZ2xlLmFwaUIMTG9nZ2luZ1Byb3RvUAFaRWdvb2dsZS5nb2xhbmcub3Jn
L2dlbnByb3RvL2dvb2dsZWFwaXMvYXBpL3NlcnZpY2Vjb25maWc7c2VydmljZWNvbmZpZ6IC
BEdBUElKmhcKBhIEDgBQAQq8BAoBDBIDDgASMrEEIENvcHlyaWdodCAyMDI2IEdvb2dsZSBM
TEMKCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wICh0
aGUgIkxpY2Vuc2UiKTsKIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNv
bXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS4KIFlvdSBtYXkgb2J0YWluIGEgY29weSBvZiB0
aGUgTGljZW5zZSBhdAoKICAgICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElD
RU5TRS0yLjAKCiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdyZWVk
IHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlCiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5z
ZSBpcyBkaXN0cmlidXRlZCBvbiBhbiAiQVMgSVMiIEJBU0lTLAogV0lUSE9VVCBXQVJSQU5U
SUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxp
ZWQuCiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zlcm5p
bmcgcGVybWlzc2lvbnMgYW5kCiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS4KCggK
AQISAxAAEwoICgEIEgMSAFwKCQoCCAsSAxIAXAoICgEIEgMTACIKCQoCCAoSAxMAIgoICgEI
EgMUAC0KCQoCCAgSAxQALQoICgEIEgMVACcKCQoCCAESAxUAJwoICgEIEgMWACIKCQoCCCQS
AxYAIgraBwoCBAASBDUAUAEazQcgTG9nZ2luZyBjb25maWd1cmF0aW9uIG9mIHRoZSBzZXJ2
aWNlLgoKIFRoZSBmb2xsb3dpbmcgZXhhbXBsZSBzaG93cyBob3cgdG8gY29uZmlndXJlIGxv
Z3MgdG8gYmUgc2VudCB0byB0aGUKIHByb2R1Y2VyIGFuZCBjb25zdW1lciBwcm9qZWN0cy4g
SW4gdGhlIGV4YW1wbGUsIHRoZSBgYWN0aXZpdHlfaGlzdG9yeWAKIGxvZyBpcyBzZW50IHRv
IGJvdGggdGhlIHByb2R1Y2VyIGFuZCBjb25zdW1lciBwcm9qZWN0cywgd2hlcmVhcyB0aGUK
IGBwdXJjaGFzZV9oaXN0b3J5YCBsb2cgaXMgb25seSBzZW50IHRvIHRoZSBwcm9kdWNlciBw
cm9qZWN0LgoKICAgICBtb25pdG9yZWRfcmVzb3VyY2VzOgogICAgIC0gdHlwZTogbGlicmFy
eS5nb29nbGVhcGlzLmNvbS9icmFuY2gKICAgICAgIGxhYmVsczoKICAgICAgIC0ga2V5OiAv
Y2l0eQogICAgICAgICBkZXNjcmlwdGlvbjogVGhlIGNpdHkgd2hlcmUgdGhlIGxpYnJhcnkg
YnJhbmNoIGlzIGxvY2F0ZWQgaW4uCiAgICAgICAtIGtleTogL25hbWUKICAgICAgICAgZGVz
Y3JpcHRpb246IFRoZSBuYW1lIG9mIHRoZSBicmFuY2guCiAgICAgbG9nczoKICAgICAtIG5h
bWU6IGFjdGl2aXR5X2hpc3RvcnkKICAgICAgIGxhYmVsczoKICAgICAgIC0ga2V5OiAvY3Vz
dG9tZXJfaWQKICAgICAtIG5hbWU6IHB1cmNoYXNlX2hpc3RvcnkKICAgICBsb2dnaW5nOgog
ICAgICAgcHJvZHVjZXJfZGVzdGluYXRpb25zOgogICAgICAgLSBtb25pdG9yZWRfcmVzb3Vy
Y2U6IGxpYnJhcnkuZ29vZ2xlYXBpcy5jb20vYnJhbmNoCiAgICAgICAgIGxvZ3M6CiAgICAg
ICAgIC0gYWN0aXZpdHlfaGlzdG9yeQogICAgICAgICAtIHB1cmNoYXNlX2hpc3RvcnkKICAg
ICAgIGNvbnN1bWVyX2Rlc3RpbmF0aW9uczoKICAgICAgIC0gbW9uaXRvcmVkX3Jlc291cmNl
OiBsaWJyYXJ5Lmdvb2dsZWFwaXMuY29tL2JyYW5jaAogICAgICAgICBsb2dzOgogICAgICAg
ICAtIGFjdGl2aXR5X2hpc3RvcnkKCgoKAwQAARIDNQgPCnAKBAQAAwASBDgCQwMaYiBDb25m
aWd1cmF0aW9uIG9mIGEgc3BlY2lmaWMgbG9nZ2luZyBkZXN0aW5hdGlvbiAodGhlIHByb2R1
Y2VyIHByb2plY3QKIG9yIHRoZSBjb25zdW1lciBwcm9qZWN0KS4KCgwKBQQAAwABEgM4ChwK
nwEKBgQAAwACABIDPAQiGo8BIFRoZSBtb25pdG9yZWQgcmVzb3VyY2UgdHlwZS4gVGhlIHR5
cGUgbXVzdCBiZSBkZWZpbmVkIGluIHRoZQogW1NlcnZpY2UubW9uaXRvcmVkX3Jlc291cmNl
c11bZ29vZ2xlLmFwaS5TZXJ2aWNlLm1vbml0b3JlZF9yZXNvdXJjZXNdCiBzZWN0aW9uLgoK
DgoHBAADAAIABRIDPAQKCg4KBwQAAwACAAESAzwLHQoOCgcEAAMAAgADEgM8ICEKjgIKBgQA
AwACARIDQgQdGv4BIE5hbWVzIG9mIHRoZSBsb2dzIHRvIGJlIHNlbnQgdG8gdGhpcyBkZXN0
aW5hdGlvbi4gRWFjaCBuYW1lIG11c3QKIGJlIGRlZmluZWQgaW4gdGhlIFtTZXJ2aWNlLmxv
Z3NdW2dvb2dsZS5hcGkuU2VydmljZS5sb2dzXSBzZWN0aW9uLiBJZiB0aGUKIGxvZyBuYW1l
IGlzIG5vdCBhIGRvbWFpbiBzY29wZWQgbmFtZSwgaXQgd2lsbCBiZSBhdXRvbWF0aWNhbGx5
IHByZWZpeGVkCiB3aXRoIHRoZSBzZXJ2aWNlIG5hbWUgZm9sbG93ZWQgYnkgIi8iLgoKDgoH
BAADAAIBBBIDQgQMCg4KBwQAAwACAQUSA0INEwoOCgcEAAMAAgEBEgNCFBgKDgoHBAADAAIB
AxIDQhscCu8BCgQEAAIAEgNJAjga4QEgTG9nZ2luZyBjb25maWd1cmF0aW9ucyBmb3Igc2Vu
ZGluZyBsb2dzIHRvIHRoZSBwcm9kdWNlciBwcm9qZWN0LgogVGhlcmUgY2FuIGJlIG11bHRp
cGxlIHByb2R1Y2VyIGRlc3RpbmF0aW9ucywgZWFjaCBvbmUgbXVzdCBoYXZlIGEKIGRpZmZl
cmVudCBtb25pdG9yZWQgcmVzb3VyY2UgdHlwZS4gQSBsb2cgY2FuIGJlIHVzZWQgaW4gYXQg
bW9zdAogb25lIHByb2R1Y2VyIGRlc3RpbmF0aW9uLgoKDAoFBAACAAQSA0kCCgoMCgUEAAIA
BhIDSQsdCgwKBQQAAgABEgNJHjMKDAoFBAACAAMSA0k2NwrvAQoEBAACARIDTwI4GuEBIExv
Z2dpbmcgY29uZmlndXJhdGlvbnMgZm9yIHNlbmRpbmcgbG9ncyB0byB0aGUgY29uc3VtZXIg
cHJvamVjdC4KIFRoZXJlIGNhbiBiZSBtdWx0aXBsZSBjb25zdW1lciBkZXN0aW5hdGlvbnMs
IGVhY2ggb25lIG11c3QgaGF2ZSBhCiBkaWZmZXJlbnQgbW9uaXRvcmVkIHJlc291cmNlIHR5
cGUuIEEgbG9nIGNhbiBiZSB1c2VkIGluIGF0IG1vc3QKIG9uZSBjb25zdW1lciBkZXN0aW5h
dGlvbi4KCgwKBQQAAgEEEgNPAgoKDAoFBAACAQYSA08LHQoMCgUEAAIBARIDTx4zCgwKBQQA
AgEDEgNPNjdiBnByb3RvMw==
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Logging::Logging ===
    # Fields for Logging
    # Field: producer_destinations Type: 11 (.google.api.Logging.LoggingDestination)
    # Field: consumer_destinations Type: 11 (.google.api.Logging.LoggingDestination)

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Logging - Compiled Protocol Buffers messages for google/api/logging.proto

=head1 SYNOPSIS

    use Google::Api::Logging;

    my $msg = Google::Api::Logging::Logging->new({
        producer_destinations => $producer_destinations,
        consumer_destinations => $consumer_destinations,
    });

    # Read or update a field
    my $val = $msg->producer_destinations();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Logging::Logging->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/logging.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Logging::Logging

Logging configuration of the service.

The following example shows how to configure logs to be sent to the
producer and consumer projects. In the example, the `activity_history`
log is sent to both the producer and consumer projects, whereas the
`purchase_history` log is only sent to the producer project.

    monitored_resources:
    - type: library.googleapis.com/branch
      labels:
      - key: /city
        description: The city where the library branch is located in.
      - key: /name
        description: The name of the branch.
    logs:
    - name: activity_history
      labels:
      - key: /customer_id
    - name: purchase_history
    logging:
      producer_destinations:
      - monitored_resource: library.googleapis.com/branch
        logs:
        - activity_history
        - purchase_history
      consumer_destinations:
      - monitored_resource: library.googleapis.com/branch
        logs:
        - activity_history

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->producer_destinations() >> / C<< $msg->producer_destinations($value) >>

Type: C<Message> (L<Google::Api::Logging::Logging::LoggingDestination>)

Logging configurations for sending logs to the producer project.
There can be multiple producer destinations, each one must have a
different monitored resource type. A log can be used in at most
one producer destination.

=item * C<< $msg->consumer_destinations() >> / C<< $msg->consumer_destinations($value) >>

Type: C<Message> (L<Google::Api::Logging::Logging::LoggingDestination>)

Logging configurations for sending logs to the consumer project.
There can be multiple consumer destinations, each one must have a
different monitored resource type. A log can be used in at most
one consumer destination.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Logging::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

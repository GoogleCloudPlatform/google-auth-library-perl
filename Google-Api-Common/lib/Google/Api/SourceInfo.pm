package Google::Api::SourceInfo;

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
Chxnb29nbGUvYXBpL3NvdXJjZV9pbmZvLnByb3RvEgpnb29nbGUuYXBpGhlnb29nbGUvcHJv
dG9idWYvYW55LnByb3RvIkUKClNvdXJjZUluZm8SNwoMc291cmNlX2ZpbGVzGAEgAygLMhQu
Z29vZ2xlLnByb3RvYnVmLkFueVILc291cmNlRmlsZXNCcQoOY29tLmdvb2dsZS5hcGlCD1Nv
dXJjZUluZm9Qcm90b1ABWkVnb29nbGUuZ29sYW5nLm9yZy9nZW5wcm90by9nb29nbGVhcGlz
L2FwaS9zZXJ2aWNlY29uZmlnO3NlcnZpY2Vjb25maWeiAgRHQVBJSoQHCgYSBA4AHgEKvAQK
AQwSAw4AEjKxBCBDb3B5cmlnaHQgMjAyNiBHb29nbGUgTExDCgogTGljZW5zZWQgdW5kZXIg
dGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlICJMaWNlbnNlIik7CiB5b3Ug
bWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExp
Y2Vuc2UuCiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2UgYXQKCiAgICAg
aHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wCgogVW5sZXNzIHJl
cXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0
d2FyZQogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24g
YW4gIkFTIElTIiBCQVNJUywKIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9G
IEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLgogU2VlIHRoZSBMaWNlbnNl
IGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZAog
bGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuCgoICgECEgMQABMKCQoCAwASAxIAIwoI
CgEIEgMUAFwKCQoCCAsSAxQAXAoICgEIEgMVACIKCQoCCAoSAxUAIgoICgEIEgMWADAKCQoC
CAgSAxYAMAoICgEIEgMXACcKCQoCCAESAxcAJwoICgEIEgMYACIKCQoCCCQSAxgAIgpACgIE
ABIEGwAeARo0IFNvdXJjZSBpbmZvcm1hdGlvbiB1c2VkIHRvIGNyZWF0ZSBhIFNlcnZpY2Ug
Q29uZmlnCgoKCgMEAAESAxsIEgo3CgQEAAIAEgMdAjAaKiBBbGwgZmlsZXMgdXNlZCBkdXJp
bmcgY29uZmlnIGdlbmVyYXRpb24uCgoMCgUEAAIABBIDHQIKCgwKBQQAAgAGEgMdCx4KDAoF
BAACAAESAx0fKwoMCgUEAAIAAxIDHS4vYgZwcm90bzM=
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::SourceInfo::SourceInfo ===
    # Fields for SourceInfo
    # Field: source_files Type: 11 (.google.protobuf.Any)

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::SourceInfo - Compiled Protocol Buffers messages for google/api/source_info.proto

=head1 SYNOPSIS

    use Google::Api::SourceInfo;

    my $msg = Google::Api::SourceInfo::SourceInfo->new({
        source_files => $source_files,
    });

    # Read or update a field
    my $val = $msg->source_files();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::SourceInfo::SourceInfo->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/source_info.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::SourceInfo::SourceInfo

Source information used to create a Service Config

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->source_files() >> / C<< $msg->source_files($value) >>

Type: C<Message> (L<Google::Protobuf::Any::Any>)

All files used during config generation.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::SourceInfo::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

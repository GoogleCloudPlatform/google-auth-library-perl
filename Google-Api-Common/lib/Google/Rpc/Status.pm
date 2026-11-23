package Google::Rpc::Status;

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
Chdnb29nbGUvcnBjL3N0YXR1cy5wcm90bxIKZ29vZ2xlLnJwYxoZZ29vZ2xlL3Byb3RvYnVm
L2FueS5wcm90byJmCgZTdGF0dXMSEgoEY29kZRgBIAEoBVIEY29kZRIYCgdtZXNzYWdlGAIg
ASgJUgdtZXNzYWdlEi4KB2RldGFpbHMYAyADKAsyFC5nb29nbGUucHJvdG9idWYuQW55Ugdk
ZXRhaWxzQl4KDmNvbS5nb29nbGUucnBjQgtTdGF0dXNQcm90b1ABWjdnb29nbGUuZ29sYW5n
Lm9yZy9nZW5wcm90by9nb29nbGVhcGlzL3JwYy9zdGF0dXM7c3RhdHVzogIDUlBDSu8NCgYS
BA4ALwEKvAQKAQwSAw4AEjKxBCBDb3B5cmlnaHQgMjAyNiBHb29nbGUgTExDCgogTGljZW5z
ZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlICJMaWNlbnNl
Iik7CiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdp
dGggdGhlIExpY2Vuc2UuCiBZb3UgbWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2Ug
YXQKCiAgICAgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wCgog
VW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0
aW5nLCBzb2Z0d2FyZQogZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJp
YnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05E
SVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLgogU2VlIHRo
ZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Np
b25zIGFuZAogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuCgoICgECEgMQABMKCQoC
AwASAxIAIwoICgEIEgMUAE4KCQoCCAsSAxQATgoICgEIEgMVACIKCQoCCAoSAxUAIgoICgEI
EgMWACwKCQoCCAgSAxYALAoICgEIEgMXACcKCQoCCAESAxcAJwoICgEIEgMYACEKCQoCCCQS
AxgAIQq+AwoCBAASBCEALwEasQMgVGhlIGBTdGF0dXNgIHR5cGUgZGVmaW5lcyBhIGxvZ2lj
YWwgZXJyb3IgbW9kZWwgdGhhdCBpcyBzdWl0YWJsZSBmb3IKIGRpZmZlcmVudCBwcm9ncmFt
bWluZyBlbnZpcm9ubWVudHMsIGluY2x1ZGluZyBSRVNUIEFQSXMgYW5kIFJQQyBBUElzLiBJ
dCBpcwogdXNlZCBieSBbZ1JQQ10oaHR0cHM6Ly9naXRodWIuY29tL2dycGMpLiBFYWNoIGBT
dGF0dXNgIG1lc3NhZ2UgY29udGFpbnMKIHRocmVlIHBpZWNlcyBvZiBkYXRhOiBlcnJvciBj
b2RlLCBlcnJvciBtZXNzYWdlLCBhbmQgZXJyb3IgZGV0YWlscy4KCiBZb3UgY2FuIGZpbmQg
b3V0IG1vcmUgYWJvdXQgdGhpcyBlcnJvciBtb2RlbCBhbmQgaG93IHRvIHdvcmsgd2l0aCBp
dCBpbiB0aGUKIFtBUEkgRGVzaWduIEd1aWRlXShodHRwczovL2Nsb3VkLmdvb2dsZS5jb20v
YXBpcy9kZXNpZ24vZXJyb3JzKS4KCgoKAwQAARIDIQgOCmUKBAQAAgASAyQCERpYIFRoZSBz
dGF0dXMgY29kZSwgd2hpY2ggc2hvdWxkIGJlIGFuIGVudW0gdmFsdWUgb2YKIFtnb29nbGUu
cnBjLkNvZGVdW2dvb2dsZS5ycGMuQ29kZV0uCgoMCgUEAAIABRIDJAIHCgwKBQQAAgABEgMk
CAwKDAoFBAACAAMSAyQPEArsAQoEBAACARIDKgIVGt4BIEEgZGV2ZWxvcGVyLWZhY2luZyBl
cnJvciBtZXNzYWdlLCB3aGljaCBzaG91bGQgYmUgaW4gRW5nbGlzaC4gQW55CiB1c2VyLWZh
Y2luZyBlcnJvciBtZXNzYWdlIHNob3VsZCBiZSBsb2NhbGl6ZWQgYW5kIHNlbnQgaW4gdGhl
CiBbZ29vZ2xlLnJwYy5TdGF0dXMuZGV0YWlsc11bZ29vZ2xlLnJwYy5TdGF0dXMuZGV0YWls
c10gZmllbGQsIG9yIGxvY2FsaXplZAogYnkgdGhlIGNsaWVudC4KCgwKBQQAAgEFEgMqAggK
DAoFBAACAQESAyoJEAoMCgUEAAIBAxIDKhMUCnkKBAQAAgISAy4CKxpsIEEgbGlzdCBvZiBt
ZXNzYWdlcyB0aGF0IGNhcnJ5IHRoZSBlcnJvciBkZXRhaWxzLiAgVGhlcmUgaXMgYSBjb21t
b24gc2V0IG9mCiBtZXNzYWdlIHR5cGVzIGZvciBBUElzIHRvIHVzZS4KCgwKBQQAAgIEEgMu
AgoKDAoFBAACAgYSAy4LHgoMCgUEAAICARIDLh8mCgwKBQQAAgIDEgMuKSpiBnByb3RvMw==

EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Rpc::Status::Status ===
    # Fields for Status
    # Field: code Type: 5 ()
    # Field: message Type: 9 ()
    # Field: details Type: 11 (.google.protobuf.Any)

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Rpc::Status - Compiled Protocol Buffers messages for google/rpc/status.proto

=head1 SYNOPSIS

    use Google::Rpc::Status;

    my $msg = Google::Rpc::Status::Status->new({
        code => $code,
        message => $message,
        details => $details,
    });

    # Read or update a field
    my $val = $msg->code();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Rpc::Status::Status->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/rpc/status.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Rpc::Status::Status

The `Status` type defines a logical error model that is suitable for
different programming environments, including REST APIs and RPC APIs. It is
used by [gRPC](https://github.com/grpc). Each `Status` message contains
three pieces of data: error code, error message, and error details.

You can find out more about this error model and how to work with it in the
[API Design Guide](https://cloud.google.com/apis/design/errors).

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->code() >> / C<< $msg->code($value) >>

Type: C<Int32>

The status code, which should be an enum value of
[google.rpc.Code][google.rpc.Code].

=item * C<< $msg->message() >> / C<< $msg->message($value) >>

Type: C<String>

A developer-facing error message, which should be in English. Any
user-facing error message should be localized and sent in the
[google.rpc.Status.details][google.rpc.Status.details] field, or localized
by the client.

=item * C<< $msg->details() >> / C<< $msg->details($value) >>

Type: C<Message> (L<Google::Protobuf::Any::Any>)

A list of messages that carry the error details.  There is a common set of
message types for APIs to use.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Rpc::Status::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

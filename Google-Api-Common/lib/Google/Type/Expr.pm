package Google::Type::Expr;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
ChZnb29nbGUvdHlwZS9leHByLnByb3RvEgtnb29nbGUudHlwZSJ6CgRFeHByEh4KCmV4cHJl
c3Npb24YASABKAlSCmV4cHJlc3Npb24SFAoFdGl0bGUYAiABKAlSBXRpdGxlEiAKC2Rlc2Ny
aXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhIaCghsb2NhdGlvbhgEIAEoCVIIbG9jYXRpb25C
WgoPY29tLmdvb2dsZS50eXBlQglFeHByUHJvdG9QAVo0Z29vZ2xlLmdvbGFuZy5vcmcvZ2Vu
cHJvdG8vZ29vZ2xlYXBpcy90eXBlL2V4cHI7ZXhwcqICA0dUUEq5FAoGEgQOAEgBCrwECgEM
EgMOABIysQQgQ29weXJpZ2h0IDIwMjYgR29vZ2xlIExMQwoKIExpY2Vuc2VkIHVuZGVyIHRo
ZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSAiTGljZW5zZSIpOwogeW91IG1h
eSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNl
bnNlLgogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0CgogICAgIGh0
dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMAoKIFVubGVzcyByZXF1
aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdh
cmUKIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFu
ICJBUyBJUyIgQkFTSVMsCiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBB
TlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC4KIFNlZSB0aGUgTGljZW5zZSBm
b3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmQKIGxp
bWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLgoKCAoBAhIDEAAUCggKAQgSAxIASwoJCgII
CxIDEgBLCggKAQgSAxMAIgoJCgIIChIDEwAiCggKAQgSAxQAKgoJCgIICBIDFAAqCggKAQgS
AxUAKAoJCgIIARIDFQAoCggKAQgSAxYAIQoJCgIIJBIDFgAhCp8JCgIEABIENwBIARqSCSBS
ZXByZXNlbnRzIGEgdGV4dHVhbCBleHByZXNzaW9uIGluIHRoZSBDb21tb24gRXhwcmVzc2lv
biBMYW5ndWFnZSAoQ0VMKQogc3ludGF4LiBDRUwgaXMgYSBDLWxpa2UgZXhwcmVzc2lvbiBs
YW5ndWFnZS4gVGhlIHN5bnRheCBhbmQgc2VtYW50aWNzIG9mIENFTAogYXJlIGRvY3VtZW50
ZWQgYXQgaHR0cHM6Ly9naXRodWIuY29tL2dvb2dsZS9jZWwtc3BlYy4KCiBFeGFtcGxlIChD
b21wYXJpc29uKToKCiAgICAgdGl0bGU6ICJTdW1tYXJ5IHNpemUgbGltaXQiCiAgICAgZGVz
Y3JpcHRpb246ICJEZXRlcm1pbmVzIGlmIGEgc3VtbWFyeSBpcyBsZXNzIHRoYW4gMTAwIGNo
YXJzIgogICAgIGV4cHJlc3Npb246ICJkb2N1bWVudC5zdW1tYXJ5LnNpemUoKSA8IDEwMCIK
CiBFeGFtcGxlIChFcXVhbGl0eSk6CgogICAgIHRpdGxlOiAiUmVxdWVzdG9yIGlzIG93bmVy
IgogICAgIGRlc2NyaXB0aW9uOiAiRGV0ZXJtaW5lcyBpZiByZXF1ZXN0b3IgaXMgdGhlIGRv
Y3VtZW50IG93bmVyIgogICAgIGV4cHJlc3Npb246ICJkb2N1bWVudC5vd25lciA9PSByZXF1
ZXN0LmF1dGguY2xhaW1zLmVtYWlsIgoKIEV4YW1wbGUgKExvZ2ljKToKCiAgICAgdGl0bGU6
ICJQdWJsaWMgZG9jdW1lbnRzIgogICAgIGRlc2NyaXB0aW9uOiAiRGV0ZXJtaW5lIHdoZXRo
ZXIgdGhlIGRvY3VtZW50IHNob3VsZCBiZSBwdWJsaWNseSB2aXNpYmxlIgogICAgIGV4cHJl
c3Npb246ICJkb2N1bWVudC50eXBlICE9ICdwcml2YXRlJyAmJiBkb2N1bWVudC50eXBlICE9
ICdpbnRlcm5hbCciCgogRXhhbXBsZSAoRGF0YSBNYW5pcHVsYXRpb24pOgoKICAgICB0aXRs
ZTogIk5vdGlmaWNhdGlvbiBzdHJpbmciCiAgICAgZGVzY3JpcHRpb246ICJDcmVhdGUgYSBu
b3RpZmljYXRpb24gc3RyaW5nIHdpdGggYSB0aW1lc3RhbXAuIgogICAgIGV4cHJlc3Npb246
ICInTmV3IG1lc3NhZ2UgcmVjZWl2ZWQgYXQgJyArIHN0cmluZyhkb2N1bWVudC5jcmVhdGVf
dGltZSkiCgogVGhlIGV4YWN0IHZhcmlhYmxlcyBhbmQgZnVuY3Rpb25zIHRoYXQgbWF5IGJl
IHJlZmVyZW5jZWQgd2l0aGluIGFuIGV4cHJlc3Npb24KIGFyZSBkZXRlcm1pbmVkIGJ5IHRo
ZSBzZXJ2aWNlIHRoYXQgZXZhbHVhdGVzIGl0LiBTZWUgdGhlIHNlcnZpY2UKIGRvY3VtZW50
YXRpb24gZm9yIGFkZGl0aW9uYWwgaW5mb3JtYXRpb24uCgoKCgMEAAESAzcIDApdCgQEAAIA
EgM6AhgaUCBUZXh0dWFsIHJlcHJlc2VudGF0aW9uIG9mIGFuIGV4cHJlc3Npb24gaW4gQ29t
bW9uIEV4cHJlc3Npb24gTGFuZ3VhZ2UKIHN5bnRheC4KCgwKBQQAAgAFEgM6AggKDAoFBAAC
AAESAzoJEwoMCgUEAAIAAxIDOhYXCqMBCgQEAAIBEgM/AhMalQEgT3B0aW9uYWwuIFRpdGxl
IGZvciB0aGUgZXhwcmVzc2lvbiwgaS5lLiBhIHNob3J0IHN0cmluZyBkZXNjcmliaW5nCiBp
dHMgcHVycG9zZS4gVGhpcyBjYW4gYmUgdXNlZCBlLmcuIGluIFVJcyB3aGljaCBhbGxvdyB0
byBlbnRlciB0aGUKIGV4cHJlc3Npb24uCgoMCgUEAAIBBRIDPwIICgwKBQQAAgEBEgM/CQ4K
DAoFBAACAQMSAz8REgqSAQoEBAACAhIDQwIZGoQBIE9wdGlvbmFsLiBEZXNjcmlwdGlvbiBv
ZiB0aGUgZXhwcmVzc2lvbi4gVGhpcyBpcyBhIGxvbmdlciB0ZXh0IHdoaWNoCiBkZXNjcmli
ZXMgdGhlIGV4cHJlc3Npb24sIGUuZy4gd2hlbiBob3ZlcmVkIG92ZXIgaXQgaW4gYSBVSS4K
CgwKBQQAAgIFEgNDAggKDAoFBAACAgESA0MJFAoMCgUEAAICAxIDQxcYCowBCgQEAAIDEgNH
AhYafyBPcHRpb25hbC4gU3RyaW5nIGluZGljYXRpbmcgdGhlIGxvY2F0aW9uIG9mIHRoZSBl
eHByZXNzaW9uIGZvciBlcnJvcgogcmVwb3J0aW5nLCBlLmcuIGEgZmlsZSBuYW1lIGFuZCBh
IHBvc2l0aW9uIGluIHRoZSBmaWxlLgoKDAoFBAACAwUSA0cCCAoMCgUEAAIDARIDRwkRCgwK
BQQAAgMDEgNHFBViBnByb3RvMw==
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Type::Expr::Expr ===
    # Fields for Expr
    # Field: expression Type: 9 ()
    # Field: title Type: 9 ()
    # Field: description Type: 9 ()
    # Field: location Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Type::Expr - Compiled Protocol Buffers messages for google/type/expr.proto

=head1 SYNOPSIS

    use Google::Type::Expr;

    my $msg = Google::Type::Expr::Expr->new({
        expression => $expression,
        title => $title,
        description => $description,
        location => $location,
    });

    # Read or update a field
    my $val = $msg->expression();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Type::Expr::Expr->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/type/expr.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Type::Expr::Expr

Represents a textual expression in the Common Expression Language (CEL)
syntax. CEL is a C-like expression language. The syntax and semantics of CEL
are documented at https://github.com/google/cel-spec.

Example (Comparison):

    title: "Summary size limit"
    description: "Determines if a summary is less than 100 chars"
    expression: "document.summary.size() < 100"

Example (Equality):

    title: "Requestor is owner"
    description: "Determines if requestor is the document owner"
    expression: "document.owner == request.auth.claims.email"

Example (Logic):

    title: "Public documents"
    description: "Determine whether the document should be publicly visible"
    expression: "document.type != 'private' && document.type != 'internal'"

Example (Data Manipulation):

    title: "Notification string"
    description: "Create a notification string with a timestamp."
    expression: "'New message received at ' + string(document.create_time)"

The exact variables and functions that may be referenced within an expression
are determined by the service that evaluates it. See the service
documentation for additional information.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->expression() >> / C<< $msg->expression($value) >>

Type: C<String>

Textual representation of an expression in Common Expression Language
syntax.

=item * C<< $msg->title() >> / C<< $msg->title($value) >>

Type: C<String>

Optional. Title for the expression, i.e. a short string describing
its purpose. This can be used e.g. in UIs which allow one to enter the
expression.

=item * C<< $msg->description() >> / C<< $msg->description($value) >>

Type: C<String>

Optional. Description of the expression. This is a longer text which
describes the expression, e.g. when hovered over it in a UI.

=item * C<< $msg->location() >> / C<< $msg->location($value) >>

Type: C<String>

Optional. String indicating the location of the expression for error
reporting, e.g. a file name and a position in the file.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Type::Expr::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

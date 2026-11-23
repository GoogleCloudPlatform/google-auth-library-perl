package Google::Type::Color;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    eval { require Google::Protobuf::Wrappers };
    my $descriptor_b64 = <<'EOF';
Chdnb29nbGUvdHlwZS9jb2xvci5wcm90bxILZ29vZ2xlLnR5cGUaHmdvb2dsZS9wcm90b2J1
Zi93cmFwcGVycy5wcm90byJ2CgVDb2xvchIQCgNyZWQYASABKAJSA3JlZBIUCgVncmVlbhgC
IAEoAlIFZ3JlZW4SEgoEYmx1ZRgDIAEoAlIEYmx1ZRIxCgVhbHBoYRgEIAEoCzIbLmdvb2ds
ZS5wcm90b2J1Zi5GbG9hdFZhbHVlUgVhbHBoYUJdCg9jb20uZ29vZ2xlLnR5cGVCCkNvbG9y
UHJvdG9QAVo2Z29vZ2xlLmdvbGFuZy5vcmcvZ2VucHJvdG8vZ29vZ2xlYXBpcy90eXBlL2Nv
bG9yO2NvbG9yogIDR1RQSoIvCgcSBQ4ArAEBCrwECgEMEgMOABIysQQgQ29weXJpZ2h0IDIw
MjYgR29vZ2xlIExMQwoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVy
c2lvbiAyLjAgKHRoZSAiTGljZW5zZSIpOwogeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBl
eGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLgogWW91IG1heSBvYnRhaW4g
YSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0CgogICAgIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9s
aWNlbnNlcy9MSUNFTlNFLTIuMAoKIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxh
dyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUKIGRpc3RyaWJ1dGVkIHVuZGVy
IHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuICJBUyBJUyIgQkFTSVMsCiBXSVRI
T1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJl
c3Mgb3IgaW1wbGllZC4KIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1
YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmQKIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBM
aWNlbnNlLgoKCAoBAhIDEAAUCgkKAgMAEgMSACgKCAoBCBIDFABNCgkKAggLEgMUAE0KCAoB
CBIDFQAiCgkKAggKEgMVACIKCAoBCBIDFgArCgkKAggIEgMWACsKCAoBCBIDFwAoCgkKAggB
EgMXACgKCAoBCBIDGAAhCgkKAggkEgMYACEKgSEKAgQAEgaWAQCsAQEa8iAgUmVwcmVzZW50
cyBhIGNvbG9yIGluIHRoZSBSR0JBIGNvbG9yIHNwYWNlLiBUaGlzIHJlcHJlc2VudGF0aW9u
IGlzIGRlc2lnbmVkCiBmb3Igc2ltcGxpY2l0eSBvZiBjb252ZXJzaW9uIHRvIGFuZCBmcm9t
IGNvbG9yIHJlcHJlc2VudGF0aW9ucyBpbiB2YXJpb3VzCiBsYW5ndWFnZXMgb3ZlciBjb21w
YWN0bmVzcy4gRm9yIGV4YW1wbGUsIHRoZSBmaWVsZHMgb2YgdGhpcyByZXByZXNlbnRhdGlv
bgogY2FuIGJlIHRyaXZpYWxseSBwcm92aWRlZCB0byB0aGUgY29uc3RydWN0b3Igb2YgYGph
dmEuYXd0LkNvbG9yYCBpbiBKYXZhOyBpdAogY2FuIGFsc28gYmUgdHJpdmlhbGx5IHByb3Zp
ZGVkIHRvIFVJQ29sb3IncyBgK2NvbG9yV2l0aFJlZDpncmVlbjpibHVlOmFscGhhYAogbWV0
aG9kIGluIGlPUzsgYW5kLCB3aXRoIGp1c3QgYSBsaXR0bGUgd29yaywgaXQgY2FuIGJlIGVh
c2lseSBmb3JtYXR0ZWQgaW50bwogYSBDU1MgYHJnYmEoKWAgc3RyaW5nIGluIEphdmFTY3Jp
cHQuCgogVGhpcyByZWZlcmVuY2UgcGFnZSBkb2Vzbid0IGhhdmUgaW5mb3JtYXRpb24gYWJv
dXQgdGhlIGFic29sdXRlIGNvbG9yCiBzcGFjZSB0aGF0IHNob3VsZCBiZSB1c2VkIHRvIGlu
dGVycHJldCB0aGUgUkdCIHZhbHVl4oCUZm9yIGV4YW1wbGUsIHNSR0IsCiBBZG9iZSBSR0Is
CiBEQ0ktUDMsIGFuZCBCVC4yMDIwLiBCeSBkZWZhdWx0LCBhcHBsaWNhdGlvbnMgc2hvdWxk
IGFzc3VtZSB0aGUgc1JHQiBjb2xvcgogc3BhY2UuCgogV2hlbiBjb2xvciBlcXVhbGl0eSBu
ZWVkcyB0byBiZSBkZWNpZGVkLCBpbXBsZW1lbnRhdGlvbnMsIHVubGVzcyBkb2N1bWVudGVk
CiBvdGhlcndpc2UsIHRyZWF0IHR3byBjb2xvcnMgYXMgZXF1YWwgaWYgYWxsIHRoZWlyIHJl
ZCwgZ3JlZW4sIGJsdWUsIGFuZCBhbHBoYQogdmFsdWVzIGVhY2ggZGlmZmVyIGJ5IGF0IG1v
c3QgYDFlLTVgLgoKIEV4YW1wbGUgKEphdmEpOgoKICAgICAgaW1wb3J0IGNvbS5nb29nbGUu
dHlwZS5Db2xvcjsKCiAgICAgIC8vIC4uLgogICAgICBwdWJsaWMgc3RhdGljIGphdmEuYXd0
LkNvbG9yIGZyb21Qcm90byhDb2xvciBwcm90b2NvbG9yKSB7CiAgICAgICAgZmxvYXQgYWxw
aGEgPSBwcm90b2NvbG9yLmhhc0FscGhhKCkKICAgICAgICAgICAgPyBwcm90b2NvbG9yLmdl
dEFscGhhKCkuZ2V0VmFsdWUoKQogICAgICAgICAgICA6IDEuMDsKCiAgICAgICAgcmV0dXJu
IG5ldyBqYXZhLmF3dC5Db2xvcigKICAgICAgICAgICAgcHJvdG9jb2xvci5nZXRSZWQoKSwK
ICAgICAgICAgICAgcHJvdG9jb2xvci5nZXRHcmVlbigpLAogICAgICAgICAgICBwcm90b2Nv
bG9yLmdldEJsdWUoKSwKICAgICAgICAgICAgYWxwaGEpOwogICAgICB9CgogICAgICBwdWJs
aWMgc3RhdGljIENvbG9yIHRvUHJvdG8oamF2YS5hd3QuQ29sb3IgY29sb3IpIHsKICAgICAg
ICBmbG9hdCByZWQgPSAoZmxvYXQpIGNvbG9yLmdldFJlZCgpOwogICAgICAgIGZsb2F0IGdy
ZWVuID0gKGZsb2F0KSBjb2xvci5nZXRHcmVlbigpOwogICAgICAgIGZsb2F0IGJsdWUgPSAo
ZmxvYXQpIGNvbG9yLmdldEJsdWUoKTsKICAgICAgICBmbG9hdCBkZW5vbWluYXRvciA9IDI1
NS4wOwogICAgICAgIENvbG9yLkJ1aWxkZXIgcmVzdWx0QnVpbGRlciA9CiAgICAgICAgICAg
IENvbG9yCiAgICAgICAgICAgICAgICAubmV3QnVpbGRlcigpCiAgICAgICAgICAgICAgICAu
c2V0UmVkKHJlZCAvIGRlbm9taW5hdG9yKQogICAgICAgICAgICAgICAgLnNldEdyZWVuKGdy
ZWVuIC8gZGVub21pbmF0b3IpCiAgICAgICAgICAgICAgICAuc2V0Qmx1ZShibHVlIC8gZGVu
b21pbmF0b3IpOwogICAgICAgIGludCBhbHBoYSA9IGNvbG9yLmdldEFscGhhKCk7CiAgICAg
ICAgaWYgKGFscGhhICE9IDI1NSkgewogICAgICAgICAgcmVzdWx0LnNldEFscGhhKAogICAg
ICAgICAgICAgIEZsb2F0VmFsdWUKICAgICAgICAgICAgICAgICAgLm5ld0J1aWxkZXIoKQog
ICAgICAgICAgICAgICAgICAuc2V0VmFsdWUoKChmbG9hdCkgYWxwaGEpIC8gZGVub21pbmF0
b3IpCiAgICAgICAgICAgICAgICAgIC5idWlsZCgpKTsKICAgICAgICB9CiAgICAgICAgcmV0
dXJuIHJlc3VsdEJ1aWxkZXIuYnVpbGQoKTsKICAgICAgfQogICAgICAvLyAuLi4KCiBFeGFt
cGxlIChpT1MgLyBPYmotQyk6CgogICAgICAvLyAuLi4KICAgICAgc3RhdGljIFVJQ29sb3Iq
IGZyb21Qcm90byhDb2xvciogcHJvdG9jb2xvcikgewogICAgICAgICBmbG9hdCByZWQgPSBb
cHJvdG9jb2xvciByZWRdOwogICAgICAgICBmbG9hdCBncmVlbiA9IFtwcm90b2NvbG9yIGdy
ZWVuXTsKICAgICAgICAgZmxvYXQgYmx1ZSA9IFtwcm90b2NvbG9yIGJsdWVdOwogICAgICAg
ICBGbG9hdFZhbHVlKiBhbHBoYV93cmFwcGVyID0gW3Byb3RvY29sb3IgYWxwaGFdOwogICAg
ICAgICBmbG9hdCBhbHBoYSA9IDEuMDsKICAgICAgICAgaWYgKGFscGhhX3dyYXBwZXIgIT0g
bmlsKSB7CiAgICAgICAgICAgYWxwaGEgPSBbYWxwaGFfd3JhcHBlciB2YWx1ZV07CiAgICAg
ICAgIH0KICAgICAgICAgcmV0dXJuIFtVSUNvbG9yIGNvbG9yV2l0aFJlZDpyZWQgZ3JlZW46
Z3JlZW4gYmx1ZTpibHVlIGFscGhhOmFscGhhXTsKICAgICAgfQoKICAgICAgc3RhdGljIENv
bG9yKiB0b1Byb3RvKFVJQ29sb3IqIGNvbG9yKSB7CiAgICAgICAgICBDR0Zsb2F0IHJlZCwg
Z3JlZW4sIGJsdWUsIGFscGhhOwogICAgICAgICAgaWYgKCFbY29sb3IgZ2V0UmVkOiZyZWQg
Z3JlZW46JmdyZWVuIGJsdWU6JmJsdWUgYWxwaGE6JmFscGhhXSkgewogICAgICAgICAgICBy
ZXR1cm4gbmlsOwogICAgICAgICAgfQogICAgICAgICAgQ29sb3IqIHJlc3VsdCA9IFtbQ29s
b3IgYWxsb2NdIGluaXRdOwogICAgICAgICAgW3Jlc3VsdCBzZXRSZWQ6cmVkXTsKICAgICAg
ICAgIFtyZXN1bHQgc2V0R3JlZW46Z3JlZW5dOwogICAgICAgICAgW3Jlc3VsdCBzZXRCbHVl
OmJsdWVdOwogICAgICAgICAgaWYgKGFscGhhIDw9IDAuOTk5OSkgewogICAgICAgICAgICBb
cmVzdWx0IHNldEFscGhhOmZsb2F0V3JhcHBlcldpdGhWYWx1ZShhbHBoYSldOwogICAgICAg
ICAgfQogICAgICAgICAgW3Jlc3VsdCBhdXRvcmVsZWFzZV07CiAgICAgICAgICByZXR1cm4g
cmVzdWx0OwogICAgIH0KICAgICAvLyAuLi4KCiAgRXhhbXBsZSAoSmF2YVNjcmlwdCk6Cgog
ICAgIC8vIC4uLgoKICAgICB2YXIgcHJvdG9Ub0Nzc0NvbG9yID0gZnVuY3Rpb24ocmdiX2Nv
bG9yKSB7CiAgICAgICAgdmFyIHJlZEZyYWMgPSByZ2JfY29sb3IucmVkIHx8IDAuMDsKICAg
ICAgICB2YXIgZ3JlZW5GcmFjID0gcmdiX2NvbG9yLmdyZWVuIHx8IDAuMDsKICAgICAgICB2
YXIgYmx1ZUZyYWMgPSByZ2JfY29sb3IuYmx1ZSB8fCAwLjA7CiAgICAgICAgdmFyIHJlZCA9
IE1hdGguZmxvb3IocmVkRnJhYyAqIDI1NSk7CiAgICAgICAgdmFyIGdyZWVuID0gTWF0aC5m
bG9vcihncmVlbkZyYWMgKiAyNTUpOwogICAgICAgIHZhciBibHVlID0gTWF0aC5mbG9vcihi
bHVlRnJhYyAqIDI1NSk7CgogICAgICAgIGlmICghKCdhbHBoYScgaW4gcmdiX2NvbG9yKSkg
ewogICAgICAgICAgIHJldHVybiByZ2JUb0Nzc0NvbG9yKHJlZCwgZ3JlZW4sIGJsdWUpOwog
ICAgICAgIH0KCiAgICAgICAgdmFyIGFscGhhRnJhYyA9IHJnYl9jb2xvci5hbHBoYS52YWx1
ZSB8fCAwLjA7CiAgICAgICAgdmFyIHJnYlBhcmFtcyA9IFtyZWQsIGdyZWVuLCBibHVlXS5q
b2luKCcsJyk7CiAgICAgICAgcmV0dXJuIFsncmdiYSgnLCByZ2JQYXJhbXMsICcsJywgYWxw
aGFGcmFjLCAnKSddLmpvaW4oJycpOwogICAgIH07CgogICAgIHZhciByZ2JUb0Nzc0NvbG9y
ID0gZnVuY3Rpb24ocmVkLCBncmVlbiwgYmx1ZSkgewogICAgICAgdmFyIHJnYk51bWJlciA9
IG5ldyBOdW1iZXIoKHJlZCA8PCAxNikgfCAoZ3JlZW4gPDwgOCkgfCBibHVlKTsKICAgICAg
IHZhciBoZXhTdHJpbmcgPSByZ2JOdW1iZXIudG9TdHJpbmcoMTYpOwogICAgICAgdmFyIG1p
c3NpbmdaZXJvcyA9IDYgLSBoZXhTdHJpbmcubGVuZ3RoOwogICAgICAgdmFyIHJlc3VsdEJ1
aWxkZXIgPSBbJyMnXTsKICAgICAgIGZvciAodmFyIGkgPSAwOyBpIDwgbWlzc2luZ1plcm9z
OyBpKyspIHsKICAgICAgICAgIHJlc3VsdEJ1aWxkZXIucHVzaCgnMCcpOwogICAgICAgfQog
ICAgICAgcmVzdWx0QnVpbGRlci5wdXNoKGhleFN0cmluZyk7CiAgICAgICByZXR1cm4gcmVz
dWx0QnVpbGRlci5qb2luKCcnKTsKICAgICB9OwoKICAgICAvLyAuLi4KCgsKAwQAARIElgEI
DQpRCgQEAAIAEgSYAQIQGkMgVGhlIGFtb3VudCBvZiByZWQgaW4gdGhlIGNvbG9yIGFzIGEg
dmFsdWUgaW4gdGhlIGludGVydmFsIFswLCAxXS4KCg0KBQQAAgAFEgSYAQIHCg0KBQQAAgAB
EgSYAQgLCg0KBQQAAgADEgSYAQ4PClMKBAQAAgESBJsBAhIaRSBUaGUgYW1vdW50IG9mIGdy
ZWVuIGluIHRoZSBjb2xvciBhcyBhIHZhbHVlIGluIHRoZSBpbnRlcnZhbCBbMCwgMV0uCgoN
CgUEAAIBBRIEmwECBwoNCgUEAAIBARIEmwEIDQoNCgUEAAIBAxIEmwEQEQpSCgQEAAICEgSe
AQIRGkQgVGhlIGFtb3VudCBvZiBibHVlIGluIHRoZSBjb2xvciBhcyBhIHZhbHVlIGluIHRo
ZSBpbnRlcnZhbCBbMCwgMV0uCgoNCgUEAAICBRIEngECBwoNCgUEAAICARIEngEIDAoNCgUE
AAICAxIEngEPEAr4BAoEBAACAxIEqwECJxrpBCBUaGUgZnJhY3Rpb24gb2YgdGhpcyBjb2xv
ciB0aGF0IHNob3VsZCBiZSBhcHBsaWVkIHRvIHRoZSBwaXhlbC4gVGhhdCBpcywKIHRoZSBm
aW5hbCBwaXhlbCBjb2xvciBpcyBkZWZpbmVkIGJ5IHRoZSBlcXVhdGlvbjoKCiAgIGBwaXhl
bCBjb2xvciA9IGFscGhhICogKHRoaXMgY29sb3IpICsgKDEuMCAtIGFscGhhKSAqIChiYWNr
Z3JvdW5kIGNvbG9yKWAKCiBUaGlzIG1lYW5zIHRoYXQgYSB2YWx1ZSBvZiAxLjAgY29ycmVz
cG9uZHMgdG8gYSBzb2xpZCBjb2xvciwgd2hlcmVhcwogYSB2YWx1ZSBvZiAwLjAgY29ycmVz
cG9uZHMgdG8gYSBjb21wbGV0ZWx5IHRyYW5zcGFyZW50IGNvbG9yLiBUaGlzCiB1c2VzIGEg
d3JhcHBlciBtZXNzYWdlIHJhdGhlciB0aGFuIGEgc2ltcGxlIGZsb2F0IHNjYWxhciBzbyB0
aGF0IGl0IGlzCiBwb3NzaWJsZSB0byBkaXN0aW5ndWlzaCBiZXR3ZWVuIGEgZGVmYXVsdCB2
YWx1ZSBhbmQgdGhlIHZhbHVlIGJlaW5nIHVuc2V0LgogSWYgb21pdHRlZCwgdGhpcyBjb2xv
ciBvYmplY3QgaXMgcmVuZGVyZWQgYXMgYSBzb2xpZCBjb2xvcgogKGFzIGlmIHRoZSBhbHBo
YSB2YWx1ZSBoYWQgYmVlbiBleHBsaWNpdGx5IGdpdmVuIGEgdmFsdWUgb2YgMS4wKS4KCg0K
BQQAAgMGEgSrAQIcCg0KBQQAAgMBEgSrAR0iCg0KBQQAAgMDEgSrASUmYgZwcm90bzM=
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Type::Color::Color ===
    # Fields for Color
    # Field: red Type: 2 ()
    # Field: green Type: 2 ()
    # Field: blue Type: 2 ()
    # Field: alpha Type: 11 (.google.protobuf.FloatValue)

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Type::Color - Compiled Protocol Buffers messages for google/type/color.proto

=head1 SYNOPSIS

    use Google::Type::Color;

    my $msg = Google::Type::Color::Color->new({
        red => $red,
        green => $green,
        blue => $blue,
        alpha => $alpha,
    });

    # Read or update a field
    my $val = $msg->red();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Type::Color::Color->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/type/color.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Type::Color::Color

Represents a color in the RGBA color space. This representation is designed
for simplicity of conversion to and from color representations in various
languages over compactness. For example, the fields of this representation
can be trivially provided to the constructor of `java.awt.Color` in Java; it
can also be trivially provided to UIColor's `+colorWithRed:green:blue:alpha`
method in iOS; and, with just a little work, it can be easily formatted into
a CSS `rgba()` string in JavaScript.

This reference page doesn't have information about the absolute color
space that should be used to interpret the RGB value—for example, sRGB,
Adobe RGB,
DCI-P3, and BT.2020. By default, applications should assume the sRGB color
space.

When color equality needs to be decided, implementations, unless documented
otherwise, treat two colors as equal if all their red, green, blue, and alpha
values each differ by at most `1e-5`.

Example (Java):

     import com.google.type.Color;

     // ...
     public static java.awt.Color fromProto(Color protocolor) {
       float alpha = protocolor.hasAlpha()
           ? protocolor.getAlpha().getValue()
           : 1.0;

       return new java.awt.Color(
           protocolor.getRed(),
           protocolor.getGreen(),
           protocolor.getBlue(),
           alpha);
     }

     public static Color toProto(java.awt.Color color) {
       float red = (float) color.getRed();
       float green = (float) color.getGreen();
       float blue = (float) color.getBlue();
       float denominator = 255.0;
       Color.Builder resultBuilder =
           Color
               .newBuilder()
               .setRed(red / denominator)
               .setGreen(green / denominator)
               .setBlue(blue / denominator);
       int alpha = color.getAlpha();
       if (alpha != 255) {
         result.setAlpha(
             FloatValue
                 .newBuilder()
                 .setValue(((float) alpha) / denominator)
                 .build());
       }
       return resultBuilder.build();
     }
     // ...

Example (iOS / Obj-C):

     // ...
     static UIColor* fromProto(Color* protocolor) {
        float red = [protocolor red];
        float green = [protocolor green];
        float blue = [protocolor blue];
        FloatValue* alpha_wrapper = [protocolor alpha];
        float alpha = 1.0;
        if (alpha_wrapper != nil) {
          alpha = [alpha_wrapper value];
        }
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
     }

     static Color* toProto(UIColor* color) {
         CGFloat red, green, blue, alpha;
         if (![color getRed:&red green:&green blue:&blue alpha:&alpha]) {
           return nil;
         }
         Color* result = [[Color alloc] init];
         [result setRed:red];
         [result setGreen:green];
         [result setBlue:blue];
         if (alpha <= 0.9999) {
           [result setAlpha:floatWrapperWithValue(alpha)];
         }
         [result autorelease];
         return result;
    }
    // ...

 Example (JavaScript):

    // ...

    var protoToCssColor = function(rgb_color) {
       var redFrac = rgb_color.red || 0.0;
       var greenFrac = rgb_color.green || 0.0;
       var blueFrac = rgb_color.blue || 0.0;
       var red = Math.floor(redFrac * 255);
       var green = Math.floor(greenFrac * 255);
       var blue = Math.floor(blueFrac * 255);

       if (!('alpha' in rgb_color)) {
          return rgbToCssColor(red, green, blue);
       }

       var alphaFrac = rgb_color.alpha.value || 0.0;
       var rgbParams = [red, green, blue].join(',');
       return ['rgba(', rgbParams, ',', alphaFrac, ')'].join('');
    };

    var rgbToCssColor = function(red, green, blue) {
      var rgbNumber = new Number((red << 16) | (green << 8) | blue);
      var hexString = rgbNumber.toString(16);
      var missingZeros = 6 - hexString.length;
      var resultBuilder = ['#'];
      for (var i = 0; i < missingZeros; i++) {
         resultBuilder.push('0');
      }
      resultBuilder.push(hexString);
      return resultBuilder.join('');
    };

    // ...

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->red() >> / C<< $msg->red($value) >>

Type: C<Float>

The amount of red in the color as a value in the interval [0, 1].

=item * C<< $msg->green() >> / C<< $msg->green($value) >>

Type: C<Float>

The amount of green in the color as a value in the interval [0, 1].

=item * C<< $msg->blue() >> / C<< $msg->blue($value) >>

Type: C<Float>

The amount of blue in the color as a value in the interval [0, 1].

=item * C<< $msg->alpha() >> / C<< $msg->alpha($value) >>

Type: C<Message> (L<Google::Protobuf::Wrappers::FloatValue>)

The fraction of this color that should be applied to the pixel. That is,
the final pixel color is defined by the equation:

  `pixel color = alpha * (this color) + (1.0 - alpha) * (background color)`

This means that a value of 1.0 corresponds to a solid color, whereas
a value of 0.0 corresponds to a completely transparent color. This
uses a wrapper message rather than a simple float scalar so that it is
possible to distinguish between a default value and the value being unset.
If omitted, this color object is rendered as a solid color
(as if the alpha value had been explicitly given a value of 1.0).

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Type::Color::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

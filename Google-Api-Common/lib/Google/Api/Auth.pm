package Google::Api::Auth;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
ChVnb29nbGUvYXBpL2F1dGgucHJvdG8SCmdvb2dsZS5hcGkifgoOQXV0aGVudGljYXRpb24S
NAoFcnVsZXMYAyADKAsyHi5nb29nbGUuYXBpLkF1dGhlbnRpY2F0aW9uUnVsZVIFcnVsZXMS
NgoJcHJvdmlkZXJzGAQgAygLMhguZ29vZ2xlLmFwaS5BdXRoUHJvdmlkZXJSCXByb3ZpZGVy
cyLgAQoSQXV0aGVudGljYXRpb25SdWxlEhoKCHNlbGVjdG9yGAEgASgJUghzZWxlY3RvchIz
CgVvYXV0aBgCIAEoCzIdLmdvb2dsZS5hcGkuT0F1dGhSZXF1aXJlbWVudHNSBW9hdXRoEjgK
GGFsbG93X3dpdGhvdXRfY3JlZGVudGlhbBgFIAEoCFIWYWxsb3dXaXRob3V0Q3JlZGVudGlh
bBI/CgxyZXF1aXJlbWVudHMYByADKAsyGy5nb29nbGUuYXBpLkF1dGhSZXF1aXJlbWVudFIM
cmVxdWlyZW1lbnRzIoIBCgtKd3RMb2NhdGlvbhIYCgZoZWFkZXIYASABKAlIAFIGaGVhZGVy
EhYKBXF1ZXJ5GAIgASgJSABSBXF1ZXJ5EhgKBmNvb2tpZRgEIAEoCUgAUgZjb29raWUSIQoM
dmFsdWVfcHJlZml4GAMgASgJUgt2YWx1ZVByZWZpeEIECgJpbiLaAQoMQXV0aFByb3ZpZGVy
Eg4KAmlkGAEgASgJUgJpZBIWCgZpc3N1ZXIYAiABKAlSBmlzc3VlchIZCghqd2tzX3VyaRgD
IAEoCVIHandrc1VyaRIcCglhdWRpZW5jZXMYBCABKAlSCWF1ZGllbmNlcxIrChFhdXRob3Jp
emF0aW9uX3VybBgFIAEoCVIQYXV0aG9yaXphdGlvblVybBI8Cg1qd3RfbG9jYXRpb25zGAYg
AygLMhcuZ29vZ2xlLmFwaS5Kd3RMb2NhdGlvblIMand0TG9jYXRpb25zIj4KEU9BdXRoUmVx
dWlyZW1lbnRzEikKEGNhbm9uaWNhbF9zY29wZXMYASABKAlSD2Nhbm9uaWNhbFNjb3BlcyJQ
Cg9BdXRoUmVxdWlyZW1lbnQSHwoLcHJvdmlkZXJfaWQYASABKAlSCnByb3ZpZGVySWQSHAoJ
YXVkaWVuY2VzGAIgASgJUglhdWRpZW5jZXNCawoOY29tLmdvb2dsZS5hcGlCCUF1dGhQcm90
b1ABWkVnb29nbGUuZ29sYW5nLm9yZy9nZW5wcm90by9nb29nbGVhcGlzL2FwaS9zZXJ2aWNl
Y29uZmlnO3NlcnZpY2Vjb25maWeiAgRHQVBJStRHCgcSBQ4A7QEBCrwECgEMEgMOABIysQQg
Q29weXJpZ2h0IDIwMjYgR29vZ2xlIExMQwoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUg
TGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSAiTGljZW5zZSIpOwogeW91IG1heSBub3QgdXNl
IHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLgogWW91
IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0CgogICAgIGh0dHA6Ly93d3cu
YXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMAoKIFVubGVzcyByZXF1aXJlZCBieSBh
cHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUKIGRpc3Ry
aWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuICJBUyBJUyIg
QkFTSVMsCiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwg
ZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC4KIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNw
ZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmQKIGxpbWl0YXRpb25z
IHVuZGVyIHRoZSBMaWNlbnNlLgoKCAoBAhIDEAATCggKAQgSAxIAXAoJCgIICxIDEgBcCggK
AQgSAxMAIgoJCgIIChIDEwAiCggKAQgSAxQAKgoJCgIICBIDFAAqCggKAQgSAxUAJwoJCgII
ARIDFQAnCggKAQgSAxYAIgoJCgIIJBIDFgAiCssECgIEABIEKgAyARq+BCBgQXV0aGVudGlj
YXRpb25gIGRlZmluZXMgdGhlIGF1dGhlbnRpY2F0aW9uIGNvbmZpZ3VyYXRpb24gZm9yIEFQ
SSBtZXRob2RzCiBwcm92aWRlZCBieSBhbiBBUEkgc2VydmljZS4KCiBFeGFtcGxlOgoKICAg
ICBuYW1lOiBjYWxlbmRhci5nb29nbGVhcGlzLmNvbQogICAgIGF1dGhlbnRpY2F0aW9uOgog
ICAgICAgcHJvdmlkZXJzOgogICAgICAgLSBpZDogZ29vZ2xlX2NhbGVuZGFyX2F1dGgKICAg
ICAgICAgandrc191cmk6IGh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMuY29tL29hdXRoMi92MS9j
ZXJ0cwogICAgICAgICBpc3N1ZXI6IGh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbQog
ICAgICAgcnVsZXM6CiAgICAgICAtIHNlbGVjdG9yOiAiKiIKICAgICAgICAgcmVxdWlyZW1l
bnRzOgogICAgICAgICAgIHByb3ZpZGVyX2lkOiBnb29nbGVfY2FsZW5kYXJfYXV0aAogICAg
ICAgLSBzZWxlY3RvcjogZ29vZ2xlLmNhbGVuZGFyLkRlbGVnYXRlCiAgICAgICAgIG9hdXRo
OgogICAgICAgICAgIGNhbm9uaWNhbF9zY29wZXM6IGh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMu
Y29tL2F1dGgvY2FsZW5kYXIucmVhZAoKCgoDBAABEgMqCBYKngEKBAQAAgASAy4CKBqQASBB
IGxpc3Qgb2YgYXV0aGVudGljYXRpb24gcnVsZXMgdGhhdCBhcHBseSB0byBpbmRpdmlkdWFs
IEFQSSBtZXRob2RzLgoKICoqTk9URToqKiBBbGwgc2VydmljZSBjb25maWd1cmF0aW9uIHJ1
bGVzIGZvbGxvdyAibGFzdCBvbmUgd2lucyIgb3JkZXIuCgoMCgUEAAIABBIDLgIKCgwKBQQA
AgAGEgMuCx0KDAoFBAACAAESAy4eIwoMCgUEAAIAAxIDLiYnClEKBAQAAgESAzECJhpEIERl
ZmluZXMgYSBzZXQgb2YgYXV0aGVudGljYXRpb24gcHJvdmlkZXJzIHRoYXQgYSBzZXJ2aWNl
IHN1cHBvcnRzLgoKDAoFBAACAQQSAzECCgoMCgUEAAIBBhIDMQsXCgwKBQQAAgEBEgMxGCEK
DAoFBAACAQMSAzEkJQrtAgoCBAESBD0ATQEa4AIgQXV0aGVudGljYXRpb24gcnVsZXMgZm9y
IHRoZSBzZXJ2aWNlLgoKIEJ5IGRlZmF1bHQsIGlmIGEgbWV0aG9kIGhhcyBhbnkgYXV0aGVu
dGljYXRpb24gcmVxdWlyZW1lbnRzLCBldmVyeSByZXF1ZXN0CiBtdXN0IGluY2x1ZGUgYSB2
YWxpZCBjcmVkZW50aWFsIG1hdGNoaW5nIG9uZSBvZiB0aGUgcmVxdWlyZW1lbnRzLgogSXQn
cyBhbiBlcnJvciB0byBpbmNsdWRlIG1vcmUgdGhhbiBvbmUga2luZCBvZiBjcmVkZW50aWFs
IGluIGEgc2luZ2xlCiByZXF1ZXN0LgoKIElmIGEgbWV0aG9kIGRvZXNuJ3QgaGF2ZSBhbnkg
YXV0aCByZXF1aXJlbWVudHMsIHJlcXVlc3QgY3JlZGVudGlhbHMgd2lsbCBiZQogaWdub3Jl
ZC4KCgoKAwQBARIDPQgaCpEBCgQEAQIAEgNCAhYagwEgU2VsZWN0cyB0aGUgbWV0aG9kcyB0
byB3aGljaCB0aGlzIHJ1bGUgYXBwbGllcy4KCiBSZWZlciB0byBbc2VsZWN0b3JdW2dvb2ds
ZS5hcGkuRG9jdW1lbnRhdGlvblJ1bGUuc2VsZWN0b3JdIGZvciBzeW50YXgKIGRldGFpbHMu
CgoMCgUEAQIABRIDQgIICgwKBQQBAgABEgNCCREKDAoFBAECAAMSA0IUFQo2CgQEAQIBEgNF
Ah4aKSBUaGUgcmVxdWlyZW1lbnRzIGZvciBPQXV0aCBjcmVkZW50aWFscy4KCgwKBQQBAgEG
EgNFAhMKDAoFBAECAQESA0UUGQoMCgUEAQIBAxIDRRwdCoUBCgQEAQICEgNJAiQaeCBJZiB0
cnVlLCB0aGUgc2VydmljZSBhY2NlcHRzIEFQSSBrZXlzIHdpdGhvdXQgYW55IG90aGVyIGNy
ZWRlbnRpYWwuCiBUaGlzIGZsYWcgb25seSBhcHBsaWVzIHRvIEhUVFAgYW5kIGdSUEMgcmVx
dWVzdHMuCgoMCgUEAQICBRIDSQIGCgwKBQQBAgIBEgNJBx8KDAoFBAECAgMSA0kiIwpECgQE
AQIDEgNMAiwaNyBSZXF1aXJlbWVudHMgZm9yIGFkZGl0aW9uYWwgYXV0aGVudGljYXRpb24g
cHJvdmlkZXJzLgoKDAoFBAECAwQSA0wCCgoMCgUEAQIDBhIDTAsaCgwKBQQBAgMBEgNMGycK
DAoFBAECAwMSA0wqKwpGCgIEAhIEUABlARo6IFNwZWNpZmllcyBhIGxvY2F0aW9uIHRvIGV4
dHJhY3QgSldUIGZyb20gYW4gQVBJIHJlcXVlc3QuCgoKCgMEAgESA1AIEwoMCgQEAggAEgRR
AloDCgwKBQQCCAABEgNRCAoKPwoEBAICABIDUwQWGjIgU3BlY2lmaWVzIEhUVFAgaGVhZGVy
IG5hbWUgdG8gZXh0cmFjdCBKV1QgdG9rZW4uCgoMCgUEAgIABRIDUwQKCgwKBQQCAgABEgNT
CxEKDAoFBAICAAMSA1MUFQpHCgQEAgIBEgNWBBUaOiBTcGVjaWZpZXMgVVJMIHF1ZXJ5IHBh
cmFtZXRlciBuYW1lIHRvIGV4dHJhY3QgSldUIHRva2VuLgoKDAoFBAICAQUSA1YECgoMCgUE
AgIBARIDVgsQCgwKBQQCAgEDEgNWExQKOgoEBAICAhIDWQQWGi0gU3BlY2lmaWVzIGNvb2tp
ZSBuYW1lIHRvIGV4dHJhY3QgSldUIHRva2VuLgoKDAoFBAICAgUSA1kECgoMCgUEAgICARID
WQsRCgwKBQQCAgIDEgNZFBUKqwMKBAQCAgMSA2QCGhqdAyBUaGUgdmFsdWUgcHJlZml4LiBU
aGUgdmFsdWUgZm9ybWF0IGlzICJ2YWx1ZV9wcmVmaXh7dG9rZW59IgogT25seSBhcHBsaWVz
IHRvICJpbiIgaGVhZGVyIHR5cGUuIE11c3QgYmUgZW1wdHkgZm9yICJpbiIgcXVlcnkgdHlw
ZS4KIElmIG5vdCBlbXB0eSwgdGhlIGhlYWRlciB2YWx1ZSBoYXMgdG8gbWF0Y2ggKGNhc2Ug
c2Vuc2l0aXZlKSB0aGlzIHByZWZpeC4KIElmIG5vdCBtYXRjaGVkLCBKV1Qgd2lsbCBub3Qg
YmUgZXh0cmFjdGVkLiBJZiBtYXRjaGVkLCBKV1Qgd2lsbCBiZQogZXh0cmFjdGVkIGFmdGVy
IHRoZSBwcmVmaXggaXMgcmVtb3ZlZC4KCiBGb3IgZXhhbXBsZSwgZm9yICJBdXRob3JpemF0
aW9uOiBCZWFyZXIge0pXVH0iLAogdmFsdWVfcHJlZml4PSJCZWFyZXIgIiB3aXRoIGEgc3Bh
Y2UgYXQgdGhlIGVuZC4KCgwKBQQCAgMFEgNkAggKDAoFBAICAwESA2QJFQoMCgUEAgIDAxID
ZBgZCq0BCgIEAxIFagCxAQEanwEgQ29uZmlndXJhdGlvbiBmb3IgYW4gYXV0aGVudGljYXRp
b24gcHJvdmlkZXIsIGluY2x1ZGluZyBzdXBwb3J0IGZvcgogW0pTT04gV2ViIFRva2VuCiAo
SldUKV0oaHR0cHM6Ly90b29scy5pZXRmLm9yZy9odG1sL2RyYWZ0LWlldGYtb2F1dGgtanNv
bi13ZWItdG9rZW4tMzIpLgoKCgoDBAMBEgNqCBQKkgEKBAQDAgASA28CEBqEASBUaGUgdW5p
cXVlIGlkZW50aWZpZXIgb2YgdGhlIGF1dGggcHJvdmlkZXIuIEl0IHdpbGwgYmUgcmVmZXJy
ZWQgdG8gYnkKIGBBdXRoUmVxdWlyZW1lbnQucHJvdmlkZXJfaWRgLgoKIEV4YW1wbGU6ICJi
b29rc3RvcmVfYXV0aCIuCgoMCgUEAwIABRIDbwIICgwKBQQDAgABEgNvCQsKDAoFBAMCAAMS
A28ODwqVAgoEBAMCARIDdwIUGocCIElkZW50aWZpZXMgdGhlIHByaW5jaXBhbCB0aGF0IGlz
c3VlZCB0aGUgSldULiBTZWUKIGh0dHBzOi8vdG9vbHMuaWV0Zi5vcmcvaHRtbC9kcmFmdC1p
ZXRmLW9hdXRoLWpzb24td2ViLXRva2VuLTMyI3NlY3Rpb24tNC4xLjEKIFVzdWFsbHkgYSBV
Ukwgb3IgYW4gZW1haWwgYWRkcmVzcy4KCiBFeGFtcGxlOiBodHRwczovL3NlY3VyZXRva2Vu
Lmdvb2dsZS5jb20KIEV4YW1wbGU6IDEyMzQ1NjctY29tcHV0ZUBkZXZlbG9wZXIuZ3NlcnZp
Y2VhY2NvdW50LmNvbQoKDAoFBAMCAQUSA3cCCAoMCgUEAwIBARIDdwkPCgwKBQQDAgEDEgN3
EhMK9gMKBAQDAgISBIUBAhYa5wMgVVJMIG9mIHRoZSBwcm92aWRlcidzIHB1YmxpYyBrZXkg
c2V0IHRvIHZhbGlkYXRlIHNpZ25hdHVyZSBvZiB0aGUgSldULiBTZWUKIFtPcGVuSUQKIERp
c2NvdmVyeV0oaHR0cHM6Ly9vcGVuaWQubmV0L3NwZWNzL29wZW5pZC1jb25uZWN0LWRpc2Nv
dmVyeS0xXzAuaHRtbCNQcm92aWRlck1ldGFkYXRhKS4KIE9wdGlvbmFsIGlmIHRoZSBrZXkg
c2V0IGRvY3VtZW50OgogIC0gY2FuIGJlIHJldHJpZXZlZCBmcm9tCiAgICBbT3BlbklECiAg
ICBEaXNjb3ZlcnldKGh0dHBzOi8vb3BlbmlkLm5ldC9zcGVjcy9vcGVuaWQtY29ubmVjdC1k
aXNjb3ZlcnktMV8wLmh0bWwpCiAgICBvZiB0aGUgaXNzdWVyLgogIC0gY2FuIGJlIGluZmVy
cmVkIGZyb20gdGhlIGVtYWlsIGRvbWFpbiBvZiB0aGUgaXNzdWVyIChlLmcuIGEgR29vZ2xl
CiAgc2VydmljZSBhY2NvdW50KS4KCiBFeGFtcGxlOiBodHRwczovL3d3dy5nb29nbGVhcGlz
LmNvbS9vYXV0aDIvdjEvY2VydHMKCg0KBQQDAgIFEgSFAQIICg0KBQQDAgIBEgSFAQkRCg0K
BQQDAgIDEgSFARQVCu4FCgQEAwIDEgSYAQIXGt8FIFRoZSBsaXN0IG9mIEpXVAogW2F1ZGll
bmNlc10oaHR0cHM6Ly90b29scy5pZXRmLm9yZy9odG1sL2RyYWZ0LWlldGYtb2F1dGgtanNv
bi13ZWItdG9rZW4tMzIjc2VjdGlvbi00LjEuMykuCiB0aGF0IGFyZSBhbGxvd2VkIHRvIGFj
Y2Vzcy4gQSBKV1QgY29udGFpbmluZyBhbnkgb2YgdGhlc2UgYXVkaWVuY2VzIHdpbGwKIGJl
IGFjY2VwdGVkLiBXaGVuIHRoaXMgc2V0dGluZyBpcyBhYnNlbnQsIEpXVHMgd2l0aCBhdWRp
ZW5jZXM6CiAgIC0gImh0dHBzOi8vW3NlcnZpY2UubmFtZV0vW2dvb2dsZS5wcm90b2J1Zi5B
cGkubmFtZV0iCiAgIC0gImh0dHBzOi8vW3NlcnZpY2UubmFtZV0vIgogd2lsbCBiZSBhY2Nl
cHRlZC4KIEZvciBleGFtcGxlLCBpZiBubyBhdWRpZW5jZXMgYXJlIGluIHRoZSBzZXR0aW5n
LCBMaWJyYXJ5U2VydmljZSBBUEkgd2lsbAogYWNjZXB0IEpXVHMgd2l0aCB0aGUgZm9sbG93
aW5nIGF1ZGllbmNlczoKICAgLQogICBodHRwczovL2xpYnJhcnktZXhhbXBsZS5nb29nbGVh
cGlzLmNvbS9nb29nbGUuZXhhbXBsZS5saWJyYXJ5LnYxLkxpYnJhcnlTZXJ2aWNlCiAgIC0g
aHR0cHM6Ly9saWJyYXJ5LWV4YW1wbGUuZ29vZ2xlYXBpcy5jb20vCgogRXhhbXBsZToKCiAg
ICAgYXVkaWVuY2VzOiBib29rc3RvcmVfYW5kcm9pZC5hcHBzLmdvb2dsZXVzZXJjb250ZW50
LmNvbSwKICAgICAgICAgICAgICAgIGJvb2tzdG9yZV93ZWIuYXBwcy5nb29nbGV1c2VyY29u
dGVudC5jb20KCg0KBQQDAgMFEgSYAQIICg0KBQQDAgMBEgSYAQkSCg0KBQQDAgMDEgSYARUW
CpkBCgQEAwIEEgScAQIfGooBIFJlZGlyZWN0IFVSTCBpZiBKV1QgdG9rZW4gaXMgcmVxdWly
ZWQgYnV0IG5vdCBwcmVzZW50IG9yIGlzIGV4cGlyZWQuCiBJbXBsZW1lbnQgYXV0aG9yaXph
dGlvblVybCBvZiBzZWN1cml0eURlZmluaXRpb25zIGluIE9wZW5BUEkgc3BlYy4KCg0KBQQD
AgQFEgScAQIICg0KBQQDAgQBEgScAQkaCg0KBQQDAgQDEgScAR0eCtMFCgQEAwIFEgSwAQIp
GsQFIERlZmluZXMgdGhlIGxvY2F0aW9ucyB0byBleHRyYWN0IHRoZSBKV1QuICBGb3Igbm93
IGl0IGlzIG9ubHkgdXNlZCBieSB0aGUKIENsb3VkIEVuZHBvaW50cyB0byBzdG9yZSB0aGUg
T3BlbkFQSSBleHRlbnNpb24gW3gtZ29vZ2xlLWp3dC1sb2NhdGlvbnNdCiAoaHR0cHM6Ly9j
bG91ZC5nb29nbGUuY29tL2VuZHBvaW50cy9kb2NzL29wZW5hcGkvb3BlbmFwaS1leHRlbnNp
b25zI3gtZ29vZ2xlLWp3dC1sb2NhdGlvbnMpCgogSldUIGxvY2F0aW9ucyBjYW4gYmUgb25l
IG9mIEhUVFAgaGVhZGVycywgVVJMIHF1ZXJ5IHBhcmFtZXRlcnMgb3IKIGNvb2tpZXMuIFRo
ZSBydWxlIGlzIHRoYXQgdGhlIGZpcnN0IG1hdGNoIHdpbnMuCgogSWYgbm90IHNwZWNpZmll
ZCwgIGRlZmF1bHQgdG8gdXNlIGZvbGxvd2luZyAzIGxvY2F0aW9uczoKICAgIDEpIEF1dGhv
cml6YXRpb246IEJlYXJlcgogICAgMikgeC1nb29nLWlhcC1qd3QtYXNzZXJ0aW9uCiAgICAz
KSBhY2Nlc3NfdG9rZW4gcXVlcnkgcGFyYW1ldGVyCgogRGVmYXVsdCBsb2NhdGlvbnMgY2Fu
IGJlIHNwZWNpZmllZCBhcyBmb2xsb3dpbmdzOgogICAgand0X2xvY2F0aW9uczoKICAgIC0g
aGVhZGVyOiBBdXRob3JpemF0aW9uCiAgICAgIHZhbHVlX3ByZWZpeDogIkJlYXJlciAiCiAg
ICAtIGhlYWRlcjogeC1nb29nLWlhcC1qd3QtYXNzZXJ0aW9uCiAgICAtIHF1ZXJ5OiBhY2Nl
c3NfdG9rZW4KCg0KBQQDAgUEEgSwAQIKCg0KBQQDAgUGEgSwAQsWCg0KBQQDAgUBEgSwARck
Cg0KBQQDAgUDEgSwAScoCucHCgIEBBIGxQEAzwEBGtgHIE9BdXRoIHNjb3BlcyBhcmUgYSB3
YXkgdG8gZGVmaW5lIGRhdGEgYW5kIHBlcm1pc3Npb25zIG9uIGRhdGEuIEZvciBleGFtcGxl
LAogdGhlcmUgYXJlIHNjb3BlcyBkZWZpbmVkIGZvciAiUmVhZC1vbmx5IGFjY2VzcyB0byBH
b29nbGUgQ2FsZW5kYXIiIGFuZAogIkFjY2VzcyB0byBDbG91ZCBQbGF0Zm9ybSIuIFVzZXJz
IGNhbiBjb25zZW50IHRvIGEgc2NvcGUgZm9yIGFuIGFwcGxpY2F0aW9uLAogZ2l2aW5nIGl0
IHBlcm1pc3Npb24gdG8gYWNjZXNzIHRoYXQgZGF0YSBvbiB0aGVpciBiZWhhbGYuCgogT0F1
dGggc2NvcGUgc3BlY2lmaWNhdGlvbnMgc2hvdWxkIGJlIGZhaXJseSBjb2Fyc2UgZ3JhaW5l
ZDsgYSB1c2VyIHdpbGwgbmVlZAogdG8gc2VlIGFuZCB1bmRlcnN0YW5kIHRoZSB0ZXh0IGRl
c2NyaXB0aW9uIG9mIHdoYXQgeW91ciBzY29wZSBtZWFucy4KCiBJbiBtb3N0IGNhc2VzOiB1
c2Ugb25lIG9yIGF0IG1vc3QgdHdvIE9BdXRoIHNjb3BlcyBmb3IgYW4gZW50aXJlIGZhbWls
eSBvZgogcHJvZHVjdHMuIElmIHlvdXIgcHJvZHVjdCBoYXMgbXVsdGlwbGUgQVBJcywgeW91
IHNob3VsZCBwcm9iYWJseSBiZSBzaGFyaW5nCiB0aGUgT0F1dGggc2NvcGUgYWNyb3NzIGFs
bCBvZiB0aG9zZSBBUElzLgoKIFdoZW4geW91IG5lZWQgZmluZXIgZ3JhaW5lZCBPQXV0aCBj
b25zZW50IHNjcmVlbnM6IHRhbGsgd2l0aCB5b3VyIHByb2R1Y3QKIG1hbmFnZW1lbnQgYWJv
dXQgaG93IGRldmVsb3BlcnMgd2lsbCB1c2UgdGhlbSBpbiBwcmFjdGljZS4KCiBQbGVhc2Ug
bm90ZSB0aGF0IGV2ZW4gdGhvdWdoIGVhY2ggb2YgdGhlIGNhbm9uaWNhbCBzY29wZXMgaXMg
ZW5vdWdoIGZvciBhCiByZXF1ZXN0IHRvIGJlIGFjY2VwdGVkIGFuZCBwYXNzZWQgdG8gdGhl
IGJhY2tlbmQsIGEgcmVxdWVzdCBjYW4gc3RpbGwgZmFpbAogZHVlIHRvIHRoZSBiYWNrZW5k
IHJlcXVpcmluZyBhZGRpdGlvbmFsIHNjb3BlcyBvciBwZXJtaXNzaW9ucy4KCgsKAwQEARIE
xQEIGQqsAgoEBAQCABIEzgECHhqdAiBUaGUgbGlzdCBvZiBwdWJsaWNseSBkb2N1bWVudGVk
IE9BdXRoIHNjb3BlcyB0aGF0IGFyZSBhbGxvd2VkIGFjY2Vzcy4gQW4KIE9BdXRoIHRva2Vu
IGNvbnRhaW5pbmcgYW55IG9mIHRoZXNlIHNjb3BlcyB3aWxsIGJlIGFjY2VwdGVkLgoKCiBF
eGFtcGxlOgoKICAgICAgY2Fub25pY2FsX3Njb3BlczogaHR0cHM6Ly93d3cuZ29vZ2xlYXBp
cy5jb20vYXV0aC9jYWxlbmRhciwKICAgICAgICAgICAgICAgICAgICAgICAgaHR0cHM6Ly93
d3cuZ29vZ2xlYXBpcy5jb20vYXV0aC9jYWxlbmRhci5yZWFkCgoNCgUEBAIABRIEzgECCAoN
CgUEBAIAARIEzgEJGQoNCgUEBAIAAxIEzgEcHQqqAQoCBAUSBtQBAO0BARqbASBVc2VyLWRl
ZmluZWQgYXV0aGVudGljYXRpb24gcmVxdWlyZW1lbnRzLCBpbmNsdWRpbmcgc3VwcG9ydCBm
b3IKIFtKU09OIFdlYiBUb2tlbgogKEpXVCldKGh0dHBzOi8vdG9vbHMuaWV0Zi5vcmcvaHRt
bC9kcmFmdC1pZXRmLW9hdXRoLWpzb24td2ViLXRva2VuLTMyKS4KCgsKAwQFARIE1AEIFwp7
CgQEBQIAEgTaAQIZGm0gW2lkXVtnb29nbGUuYXBpLkF1dGhQcm92aWRlci5pZF0gZnJvbSBh
dXRoZW50aWNhdGlvbiBwcm92aWRlci4KCiBFeGFtcGxlOgoKICAgICBwcm92aWRlcl9pZDog
Ym9va3N0b3JlX2F1dGgKCg0KBQQFAgAFEgTaAQIICg0KBQQFAgABEgTaAQkUCg0KBQQFAgAD
EgTaARcYCsAGCgQEBQIBEgTsAQIXGrEGIE5PVEU6IFRoaXMgd2lsbCBiZSBkZXByZWNhdGVk
IHNvb24sIG9uY2UgQXV0aFByb3ZpZGVyLmF1ZGllbmNlcyBpcwogaW1wbGVtZW50ZWQgYW5k
IGFjY2VwdGVkIGluIGFsbCB0aGUgcnVudGltZSBjb21wb25lbnRzLgoKIFRoZSBsaXN0IG9m
IEpXVAogW2F1ZGllbmNlc10oaHR0cHM6Ly90b29scy5pZXRmLm9yZy9odG1sL2RyYWZ0LWll
dGYtb2F1dGgtanNvbi13ZWItdG9rZW4tMzIjc2VjdGlvbi00LjEuMykuCiB0aGF0IGFyZSBh
bGxvd2VkIHRvIGFjY2Vzcy4gQSBKV1QgY29udGFpbmluZyBhbnkgb2YgdGhlc2UgYXVkaWVu
Y2VzIHdpbGwKIGJlIGFjY2VwdGVkLiBXaGVuIHRoaXMgc2V0dGluZyBpcyBhYnNlbnQsIG9u
bHkgSldUcyB3aXRoIGF1ZGllbmNlCiAiaHR0cHM6Ly9bU2VydmljZV9uYW1lXVtnb29nbGUu
YXBpLlNlcnZpY2UubmFtZV0vW0FQSV9uYW1lXVtnb29nbGUucHJvdG9idWYuQXBpLm5hbWVd
Igogd2lsbCBiZSBhY2NlcHRlZC4gRm9yIGV4YW1wbGUsIGlmIG5vIGF1ZGllbmNlcyBhcmUg
aW4gdGhlIHNldHRpbmcsCiBMaWJyYXJ5U2VydmljZSBBUEkgd2lsbCBvbmx5IGFjY2VwdCBK
V1RzIHdpdGggdGhlIGZvbGxvd2luZyBhdWRpZW5jZQogImh0dHBzOi8vbGlicmFyeS1leGFt
cGxlLmdvb2dsZWFwaXMuY29tL2dvb2dsZS5leGFtcGxlLmxpYnJhcnkudjEuTGlicmFyeVNl
cnZpY2UiLgoKIEV4YW1wbGU6CgogICAgIGF1ZGllbmNlczogYm9va3N0b3JlX2FuZHJvaWQu
YXBwcy5nb29nbGV1c2VyY29udGVudC5jb20sCiAgICAgICAgICAgICAgICBib29rc3RvcmVf
d2ViLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tCgoNCgUEBQIBBRIE7AECCAoNCgUEBQIB
ARIE7AEJEgoNCgUEBQIBAxIE7AEVFmIGcHJvdG8z
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Auth::Authentication ===
    # Fields for Authentication
    # Field: rules Type: 11 (.google.api.AuthenticationRule)
    # Field: providers Type: 11 (.google.api.AuthProvider)

# === Message: Google::Api::Auth::AuthenticationRule ===
    # Fields for AuthenticationRule
    # Field: selector Type: 9 ()
    # Field: oauth Type: 11 (.google.api.OAuthRequirements)
    # Field: allow_without_credential Type: 8 ()
    # Field: requirements Type: 11 (.google.api.AuthRequirement)

# === Message: Google::Api::Auth::JwtLocation ===
    # Fields for JwtLocation
    # Field: header Type: 9 ()
    # Field: query Type: 9 ()
    # Field: cookie Type: 9 ()
    # Field: value_prefix Type: 9 ()

# === Message: Google::Api::Auth::AuthProvider ===
    # Fields for AuthProvider
    # Field: id Type: 9 ()
    # Field: issuer Type: 9 ()
    # Field: jwks_uri Type: 9 ()
    # Field: audiences Type: 9 ()
    # Field: authorization_url Type: 9 ()
    # Field: jwt_locations Type: 11 (.google.api.JwtLocation)

# === Message: Google::Api::Auth::OAuthRequirements ===
    # Fields for OAuthRequirements
    # Field: canonical_scopes Type: 9 ()

# === Message: Google::Api::Auth::AuthRequirement ===
    # Fields for AuthRequirement
    # Field: provider_id Type: 9 ()
    # Field: audiences Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Auth - Compiled Protocol Buffers messages for google/api/auth.proto

=head1 SYNOPSIS

    use Google::Api::Auth;

    my $msg = Google::Api::Auth::Authentication->new({
        rules => $rules,
        providers => $providers,
    });

    # Read or update a field
    my $val = $msg->rules();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Auth::Authentication->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/auth.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Auth::Authentication

`Authentication` defines the authentication configuration for API methods
provided by an API service.

Example:

    name: calendar.googleapis.com
    authentication:
      providers:
      - id: google_calendar_auth
        jwks_uri: https://www.googleapis.com/oauth2/v1/certs
        issuer: https://securetoken.google.com
      rules:
      - selector: "*"
        requirements:
          provider_id: google_calendar_auth
      - selector: google.calendar.Delegate
        oauth:
          canonical_scopes: https://www.googleapis.com/auth/calendar.read

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->rules() >> / C<< $msg->rules($value) >>

Type: C<Message> (L<Google::Api::Auth::AuthenticationRule>)

A list of authentication rules that apply to individual API methods.

B<NOTE:> All service configuration rules follow "last one wins" order.

=item * C<< $msg->providers() >> / C<< $msg->providers($value) >>

Type: C<Message> (L<Google::Api::Auth::AuthProvider>)

Defines a set of authentication providers that a service supports.

=back

=head2 Google::Api::Auth::AuthenticationRule

Authentication rules for the service.

By default, if a method has any authentication requirements, every request
must include a valid credential matching one of the requirements.
It's an error to include more than one kind of credential in a single
request.

If a method doesn't have any auth requirements, request credentials will be
ignored.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->selector() >> / C<< $msg->selector($value) >>

Type: C<String>

Selects the methods to which this rule applies.

Refer to [selector][google.api.DocumentationRule.selector] for syntax
details.

=item * C<< $msg->oauth() >> / C<< $msg->oauth($value) >>

Type: C<Message> (L<Google::Api::Auth::OAuthRequirements>)

The requirements for OAuth credentials.

=item * C<< $msg->allow_without_credential() >> / C<< $msg->allow_without_credential($value) >>

Type: C<Bool>

If true, the service accepts API keys without any other credential.
This flag only applies to HTTP and gRPC requests.

=item * C<< $msg->requirements() >> / C<< $msg->requirements($value) >>

Type: C<Message> (L<Google::Api::Auth::AuthRequirement>)

Requirements for additional authentication providers.

=back

=head2 Google::Api::Auth::JwtLocation

Specifies a location to extract JWT from an API request.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->header() >> / C<< $msg->header($value) >>

Type: C<String>

Specifies HTTP header name to extract JWT token.

=item * C<< $msg->query() >> / C<< $msg->query($value) >>

Type: C<String>

Specifies URL query parameter name to extract JWT token.

=item * C<< $msg->cookie() >> / C<< $msg->cookie($value) >>

Type: C<String>

Specifies cookie name to extract JWT token.

=item * C<< $msg->value_prefix() >> / C<< $msg->value_prefix($value) >>

Type: C<String>

The value prefix. The value format is "value_prefix{token}"
Only applies to "in" header type. Must be empty for "in" query type.
If not empty, the header value has to match (case sensitive) this prefix.
If not matched, JWT will not be extracted. If matched, JWT will be
extracted after the prefix is removed.

For example, for "Authorization: Bearer {JWT}",
value_prefix="Bearer " with a space at the end.

=back

=head2 Google::Api::Auth::AuthProvider

Configuration for an authentication provider, including support for
[JSON Web Token
(JWT)](https://tools.ietf.org/html/draft-ietf-oauth-json-web-token-32).

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->id() >> / C<< $msg->id($value) >>

Type: C<String>

The unique identifier of the auth provider. It will be referred to by
`AuthRequirement.provider_id`.

Example: "bookstore_auth".

=item * C<< $msg->issuer() >> / C<< $msg->issuer($value) >>

Type: C<String>

Identifies the principal that issued the JWT. See
https://tools.ietf.org/html/draft-ietf-oauth-json-web-token-32#section-4.1.1
Usually a URL or an email address.

Example: https://securetoken.google.com
Example: 1234567-compute@developer.gserviceaccount.com

=item * C<< $msg->jwks_uri() >> / C<< $msg->jwks_uri($value) >>

Type: C<String>

URL of the provider's public key set to validate signature of the JWT. See
[OpenID
Discovery](https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderMetadata).
Optional if the key set document:
 - can be retrieved from
   [OpenID
   Discovery](https://openid.net/specs/openid-connect-discovery-1_0.html)
   of the issuer.
 - can be inferred from the email domain of the issuer (e.g. a Google
 service account).

Example: https://www.googleapis.com/oauth2/v1/certs

=item * C<< $msg->audiences() >> / C<< $msg->audiences($value) >>

Type: C<String>

The list of JWT
[audiences](https://tools.ietf.org/html/draft-ietf-oauth-json-web-token-32#section-4.1.3).
that are allowed to access. A JWT containing any of these audiences will
be accepted. When this setting is absent, JWTs with audiences:
  - "https://[service.name]/[google.protobuf.Api.name]"
  - "https://[service.name]/"
will be accepted.
For example, if no audiences are in the setting, LibraryService API will
accept JWTs with the following audiences:
  -
  https://library-example.googleapis.com/google.example.library.v1.LibraryService
  - https://library-example.googleapis.com/

Example:

    audiences: bookstore_android.apps.googleusercontent.com,
               bookstore_web.apps.googleusercontent.com

=item * C<< $msg->authorization_url() >> / C<< $msg->authorization_url($value) >>

Type: C<String>

Redirect URL if JWT token is required but not present or is expired.
Implement authorizationUrl of securityDefinitions in OpenAPI spec.

=item * C<< $msg->jwt_locations() >> / C<< $msg->jwt_locations($value) >>

Type: C<Message> (L<Google::Api::Auth::JwtLocation>)

Defines the locations to extract the JWT.  For now it is only used by the
Cloud Endpoints to store the OpenAPI extension [x-google-jwt-locations]
(https://cloud.google.com/endpoints/docs/openapi/openapi-extensions#x-google-jwt-locations)

JWT locations can be one of HTTP headers, URL query parameters or
cookies. The rule is that the first match wins.

If not specified,  default to use following 3 locations:
   1) Authorization: Bearer
   2) x-goog-iap-jwt-assertion
   3) access_token query parameter

Default locations can be specified as followings:
   jwt_locations:
   - header: Authorization
     value_prefix: "Bearer "
   - header: x-goog-iap-jwt-assertion
   - query: access_token

=back

=head2 Google::Api::Auth::OAuthRequirements

OAuth scopes are a way to define data and permissions on data. For example,
there are scopes defined for "Read-only access to Google Calendar" and
"Access to Cloud Platform". Users can consent to a scope for an application,
giving it permission to access that data on their behalf.

OAuth scope specifications should be fairly coarse grained; a user will need
to see and understand the text description of what your scope means.

In most cases: use one or at most two OAuth scopes for an entire family of
products. If your product has multiple APIs, you should probably be sharing
the OAuth scope across all of those APIs.

When you need finer grained OAuth consent screens: talk with your product
management about how developers will use them in practice.

Please note that even though each of the canonical scopes is enough for a
request to be accepted and passed to the backend, a request can still fail
due to the backend requiring additional scopes or permissions.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->canonical_scopes() >> / C<< $msg->canonical_scopes($value) >>

Type: C<String>

The list of publicly documented OAuth scopes that are allowed access. An
OAuth token containing any of these scopes will be accepted.


Example:

     canonical_scopes: https://www.googleapis.com/auth/calendar,
                       https://www.googleapis.com/auth/calendar.read

=back

=head2 Google::Api::Auth::AuthRequirement

User-defined authentication requirements, including support for
[JSON Web Token
(JWT)](https://tools.ietf.org/html/draft-ietf-oauth-json-web-token-32).

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->provider_id() >> / C<< $msg->provider_id($value) >>

Type: C<String>

[id][google.api.AuthProvider.id] from authentication provider.

Example:

    provider_id: bookstore_auth

=item * C<< $msg->audiences() >> / C<< $msg->audiences($value) >>

Type: C<String>

NOTE: This will be deprecated soon, once AuthProvider.audiences is
implemented and accepted in all the runtime components.

The list of JWT
[audiences](https://tools.ietf.org/html/draft-ietf-oauth-json-web-token-32#section-4.1.3).
that are allowed to access. A JWT containing any of these audiences will
be accepted. When this setting is absent, only JWTs with audience
"https://[Service_name][google.api.Service.name]/[API_name][google.protobuf.Api.name]"
will be accepted. For example, if no audiences are in the setting,
LibraryService API will only accept JWTs with the following audience
"https://library-example.googleapis.com/google.example.library.v1.LibraryService".

Example:

    audiences: bookstore_android.apps.googleusercontent.com,
               bookstore_web.apps.googleusercontent.com

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Auth::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

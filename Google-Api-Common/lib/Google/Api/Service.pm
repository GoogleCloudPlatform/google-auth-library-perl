package Google::Api::Service;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    eval { require Google::Api::Auth };
    eval { require Google::Api::Backend };
    eval { require Google::Api::Billing };
    eval { require Google::Api::Client };
    eval { require Google::Api::Context };
    eval { require Google::Api::Control };
    eval { require Google::Api::Documentation };
    eval { require Google::Api::Endpoint };
    eval { require Google::Api::Http };
    eval { require Google::Api::Log };
    eval { require Google::Api::Logging };
    eval { require Google::Api::Metric };
    eval { require Google::Api::MonitoredResource };
    eval { require Google::Api::Monitoring };
    eval { require Google::Api::Quota };
    eval { require Google::Api::SourceInfo };
    eval { require Google::Api::SystemParameter };
    eval { require Google::Api::Usage };
    eval { require Google::Protobuf::Api };
    eval { require Google::Protobuf::Type };
    eval { require Google::Protobuf::Wrappers };
    my $descriptor_b64 = <<'EOF';
Chhnb29nbGUvYXBpL3NlcnZpY2UucHJvdG8SCmdvb2dsZS5hcGkaFWdvb2dsZS9hcGkvYXV0
aC5wcm90bxoYZ29vZ2xlL2FwaS9iYWNrZW5kLnByb3RvGhhnb29nbGUvYXBpL2JpbGxpbmcu
cHJvdG8aF2dvb2dsZS9hcGkvY2xpZW50LnByb3RvGhhnb29nbGUvYXBpL2NvbnRleHQucHJv
dG8aGGdvb2dsZS9hcGkvY29udHJvbC5wcm90bxoeZ29vZ2xlL2FwaS9kb2N1bWVudGF0aW9u
LnByb3RvGhlnb29nbGUvYXBpL2VuZHBvaW50LnByb3RvGhVnb29nbGUvYXBpL2h0dHAucHJv
dG8aFGdvb2dsZS9hcGkvbG9nLnByb3RvGhhnb29nbGUvYXBpL2xvZ2dpbmcucHJvdG8aF2dv
b2dsZS9hcGkvbWV0cmljLnByb3RvGiNnb29nbGUvYXBpL21vbml0b3JlZF9yZXNvdXJjZS5w
cm90bxobZ29vZ2xlL2FwaS9tb25pdG9yaW5nLnByb3RvGhZnb29nbGUvYXBpL3F1b3RhLnBy
b3RvGhxnb29nbGUvYXBpL3NvdXJjZV9pbmZvLnByb3RvGiFnb29nbGUvYXBpL3N5c3RlbV9w
YXJhbWV0ZXIucHJvdG8aFmdvb2dsZS9hcGkvdXNhZ2UucHJvdG8aGWdvb2dsZS9wcm90b2J1
Zi9hcGkucHJvdG8aGmdvb2dsZS9wcm90b2J1Zi90eXBlLnByb3RvGh5nb29nbGUvcHJvdG9i
dWYvd3JhcHBlcnMucHJvdG8ijQoKB1NlcnZpY2USEgoEbmFtZRgBIAEoCVIEbmFtZRIUCgV0
aXRsZRgCIAEoCVIFdGl0bGUSLgoTcHJvZHVjZXJfcHJvamVjdF9pZBgWIAEoCVIRcHJvZHVj
ZXJQcm9qZWN0SWQSDgoCaWQYISABKAlSAmlkEigKBGFwaXMYAyADKAsyFC5nb29nbGUucHJv
dG9idWYuQXBpUgRhcGlzEisKBXR5cGVzGAQgAygLMhUuZ29vZ2xlLnByb3RvYnVmLlR5cGVS
BXR5cGVzEisKBWVudW1zGAUgAygLMhUuZ29vZ2xlLnByb3RvYnVmLkVudW1SBWVudW1zEj8K
DWRvY3VtZW50YXRpb24YBiABKAsyGS5nb29nbGUuYXBpLkRvY3VtZW50YXRpb25SDWRvY3Vt
ZW50YXRpb24SLQoHYmFja2VuZBgIIAEoCzITLmdvb2dsZS5hcGkuQmFja2VuZFIHYmFja2Vu
ZBIkCgRodHRwGAkgASgLMhAuZ29vZ2xlLmFwaS5IdHRwUgRodHRwEicKBXF1b3RhGAogASgL
MhEuZ29vZ2xlLmFwaS5RdW90YVIFcXVvdGESQgoOYXV0aGVudGljYXRpb24YCyABKAsyGi5n
b29nbGUuYXBpLkF1dGhlbnRpY2F0aW9uUg5hdXRoZW50aWNhdGlvbhItCgdjb250ZXh0GAwg
ASgLMhMuZ29vZ2xlLmFwaS5Db250ZXh0Ugdjb250ZXh0EicKBXVzYWdlGA8gASgLMhEuZ29v
Z2xlLmFwaS5Vc2FnZVIFdXNhZ2USMgoJZW5kcG9pbnRzGBIgAygLMhQuZ29vZ2xlLmFwaS5F
bmRwb2ludFIJZW5kcG9pbnRzEi0KB2NvbnRyb2wYFSABKAsyEy5nb29nbGUuYXBpLkNvbnRy
b2xSB2NvbnRyb2wSLQoEbG9ncxgXIAMoCzIZLmdvb2dsZS5hcGkuTG9nRGVzY3JpcHRvclIE
bG9ncxI2CgdtZXRyaWNzGBggAygLMhwuZ29vZ2xlLmFwaS5NZXRyaWNEZXNjcmlwdG9yUgdt
ZXRyaWNzElgKE21vbml0b3JlZF9yZXNvdXJjZXMYGSADKAsyJy5nb29nbGUuYXBpLk1vbml0
b3JlZFJlc291cmNlRGVzY3JpcHRvclISbW9uaXRvcmVkUmVzb3VyY2VzEi0KB2JpbGxpbmcY
GiABKAsyEy5nb29nbGUuYXBpLkJpbGxpbmdSB2JpbGxpbmcSLQoHbG9nZ2luZxgbIAEoCzIT
Lmdvb2dsZS5hcGkuTG9nZ2luZ1IHbG9nZ2luZxI2Cgptb25pdG9yaW5nGBwgASgLMhYuZ29v
Z2xlLmFwaS5Nb25pdG9yaW5nUgptb25pdG9yaW5nEkkKEXN5c3RlbV9wYXJhbWV0ZXJzGB0g
ASgLMhwuZ29vZ2xlLmFwaS5TeXN0ZW1QYXJhbWV0ZXJzUhBzeXN0ZW1QYXJhbWV0ZXJzEjcK
C3NvdXJjZV9pbmZvGCUgASgLMhYuZ29vZ2xlLmFwaS5Tb3VyY2VJbmZvUgpzb3VyY2VJbmZv
EjYKCnB1Ymxpc2hpbmcYLSABKAsyFi5nb29nbGUuYXBpLlB1Ymxpc2hpbmdSCnB1Ymxpc2hp
bmcSQwoOY29uZmlnX3ZlcnNpb24YFCABKAsyHC5nb29nbGUucHJvdG9idWYuVUludDMyVmFs
dWVSDWNvbmZpZ1ZlcnNpb25CbgoOY29tLmdvb2dsZS5hcGlCDFNlcnZpY2VQcm90b1ABWkVn
b29nbGUuZ29sYW5nLm9yZy9nZW5wcm90by9nb29nbGVhcGlzL2FwaS9zZXJ2aWNlY29uZmln
O3NlcnZpY2Vjb25maWeiAgRHQVBJSvEyCgcSBQ4AvQEBCrwECgEMEgMOABIysQQgQ29weXJp
Z2h0IDIwMjYgR29vZ2xlIExMQwoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5z
ZSwgVmVyc2lvbiAyLjAgKHRoZSAiTGljZW5zZSIpOwogeW91IG1heSBub3QgdXNlIHRoaXMg
ZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRoZSBMaWNlbnNlLgogWW91IG1heSBv
YnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0CgogICAgIGh0dHA6Ly93d3cuYXBhY2hl
Lm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMAoKIFVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNh
YmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUKIGRpc3RyaWJ1dGVk
IHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVkIG9uIGFuICJBUyBJUyIgQkFTSVMs
CiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBBTlkgS0lORCwgZWl0aGVy
IGV4cHJlc3Mgb3IgaW1wbGllZC4KIFNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmlj
IGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmQKIGxpbWl0YXRpb25zIHVuZGVy
IHRoZSBMaWNlbnNlLgoKCAoBAhIDEAATCgkKAgMAEgMSAB8KCQoCAwESAxMAIgoJCgIDAhID
FAAiCgkKAgMDEgMVACEKCQoCAwQSAxYAIgoJCgIDBRIDFwAiCgkKAgMGEgMYACgKCQoCAwcS
AxkAIwoJCgIDCBIDGgAfCgkKAgMJEgMbAB4KCQoCAwoSAxwAIgoJCgIDCxIDHQAhCgkKAgMM
EgMeAC0KCQoCAw0SAx8AJQoJCgIDDhIDIAAgCgkKAgMPEgMhACYKCQoCAxASAyIAKwoJCgID
ERIDIwAgCgkKAgMSEgMkACMKCQoCAxMSAyUAJAoJCgIDFBIDJgAoCggKAQgSAygAXAoJCgII
CxIDKABcCggKAQgSAykAIgoJCgIIChIDKQAiCggKAQgSAyoALQoJCgIICBIDKgAtCggKAQgS
AysAJwoJCgIIARIDKwAnCggKAQgSAywAIgoJCgIIJBIDLAAiCswICgIEABIFTwC9AQEavggg
YFNlcnZpY2VgIGlzIHRoZSByb290IG9iamVjdCBvZiBHb29nbGUgQVBJIHNlcnZpY2UgY29u
ZmlndXJhdGlvbiAoc2VydmljZQogY29uZmlnKS4gSXQgZGVzY3JpYmVzIHRoZSBiYXNpYyBp
bmZvcm1hdGlvbiBhYm91dCBhIGxvZ2ljYWwgc2VydmljZSwKIHN1Y2ggYXMgdGhlIHNlcnZp
Y2UgbmFtZSBhbmQgdGhlIHVzZXItZmFjaW5nIHRpdGxlLCBhbmQgZGVsZWdhdGVzIG90aGVy
CiBhc3BlY3RzIHRvIHN1Yi1zZWN0aW9ucy4gRWFjaCBzdWItc2VjdGlvbiBpcyBlaXRoZXIg
YSBwcm90byBtZXNzYWdlIG9yIGEKIHJlcGVhdGVkIHByb3RvIG1lc3NhZ2UgdGhhdCBjb25m
aWd1cmVzIGEgc3BlY2lmaWMgYXNwZWN0LCBzdWNoIGFzIGF1dGguCiBGb3IgbW9yZSBpbmZv
cm1hdGlvbiwgc2VlIGVhY2ggcHJvdG8gbWVzc2FnZSBkZWZpbml0aW9uLgoKIEV4YW1wbGU6
CgogICAgIHR5cGU6IGdvb2dsZS5hcGkuU2VydmljZQogICAgIG5hbWU6IGNhbGVuZGFyLmdv
b2dsZWFwaXMuY29tCiAgICAgdGl0bGU6IEdvb2dsZSBDYWxlbmRhciBBUEkKICAgICBhcGlz
OgogICAgIC0gbmFtZTogZ29vZ2xlLmNhbGVuZGFyLnYzLkNhbGVuZGFyCgogICAgIHZpc2li
aWxpdHk6CiAgICAgICBydWxlczoKICAgICAgIC0gc2VsZWN0b3I6ICJnb29nbGUuY2FsZW5k
YXIudjMuKiIKICAgICAgICAgcmVzdHJpY3Rpb246IFBSRVZJRVcKICAgICBiYWNrZW5kOgog
ICAgICAgcnVsZXM6CiAgICAgICAtIHNlbGVjdG9yOiAiZ29vZ2xlLmNhbGVuZGFyLnYzLioi
CiAgICAgICAgIGFkZHJlc3M6IGNhbGVuZGFyLmV4YW1wbGUuY29tCgogICAgIGF1dGhlbnRp
Y2F0aW9uOgogICAgICAgcHJvdmlkZXJzOgogICAgICAgLSBpZDogZ29vZ2xlX2NhbGVuZGFy
X2F1dGgKICAgICAgICAgandrc191cmk6IGh0dHBzOi8vd3d3Lmdvb2dsZWFwaXMuY29tL29h
dXRoMi92MS9jZXJ0cwogICAgICAgICBpc3N1ZXI6IGh0dHBzOi8vc2VjdXJldG9rZW4uZ29v
Z2xlLmNvbQogICAgICAgcnVsZXM6CiAgICAgICAtIHNlbGVjdG9yOiAiKiIKICAgICAgICAg
cmVxdWlyZW1lbnRzOgogICAgICAgICAgIHByb3ZpZGVyX2lkOiBnb29nbGVfY2FsZW5kYXJf
YXV0aAoKCgoDBAABEgNPCA8K9gEKBAQAAgASA1QCEhroASBUaGUgc2VydmljZSBuYW1lLCB3
aGljaCBpcyBhIEROUy1saWtlIGxvZ2ljYWwgaWRlbnRpZmllciBmb3IgdGhlCiBzZXJ2aWNl
LCBzdWNoIGFzIGBjYWxlbmRhci5nb29nbGVhcGlzLmNvbWAuIFRoZSBzZXJ2aWNlIG5hbWUK
IHR5cGljYWxseSBnb2VzIHRocm91Z2ggRE5TIHZlcmlmaWNhdGlvbiB0byBtYWtlIHN1cmUg
dGhlIG93bmVyCiBvZiB0aGUgc2VydmljZSBhbHNvIG93bnMgdGhlIEROUyBuYW1lLgoKDAoF
BAACAAUSA1QCCAoMCgUEAAIAARIDVAkNCgwKBQQAAgADEgNUEBEKZQoEBAACARIDWAITGlgg
VGhlIHByb2R1Y3QgdGl0bGUgZm9yIHRoaXMgc2VydmljZSwgaXQgaXMgdGhlIG5hbWUgZGlz
cGxheWVkIGluIEdvb2dsZQogQ2xvdWQgQ29uc29sZS4KCgwKBQQAAgEFEgNYAggKDAoFBAAC
AQESA1gJDgoMCgUEAAIBAxIDWBESCjkKBAQAAgISA1sCIhosIFRoZSBHb29nbGUgcHJvamVj
dCB0aGF0IG93bnMgdGhpcyBzZXJ2aWNlLgoKDAoFBAACAgUSA1sCCAoMCgUEAAICARIDWwkc
CgwKBQQAAgIDEgNbHyEKnwIKBAQAAgMSA2ECERqRAiBBIHVuaXF1ZSBJRCBmb3IgYSBzcGVj
aWZpYyBpbnN0YW5jZSBvZiB0aGlzIG1lc3NhZ2UsIHR5cGljYWxseSBhc3NpZ25lZAogYnkg
dGhlIGNsaWVudCBmb3IgdHJhY2tpbmcgcHVycG9zZS4gTXVzdCBiZSBubyBsb25nZXIgdGhh
biA2MyBjaGFyYWN0ZXJzCiBhbmQgb25seSBsb3dlciBjYXNlIGxldHRlcnMsIGRpZ2l0cywg
Jy4nLCAnXycgYW5kICctJyBhcmUgYWxsb3dlZC4gSWYKIGVtcHR5LCB0aGUgc2VydmVyIG1h
eSBjaG9vc2UgdG8gZ2VuZXJhdGUgb25lIGluc3RlYWQuCgoMCgUEAAIDBRIDYQIICgwKBQQA
AgMBEgNhCQsKDAoFBAACAwMSA2EOEAqCAwoEBAACBBIDaAIoGvQCIEEgbGlzdCBvZiBBUEkg
aW50ZXJmYWNlcyBleHBvcnRlZCBieSB0aGlzIHNlcnZpY2UuIE9ubHkgdGhlIGBuYW1lYCBm
aWVsZAogb2YgdGhlIFtnb29nbGUucHJvdG9idWYuQXBpXVtnb29nbGUucHJvdG9idWYuQXBp
XSBuZWVkcyB0byBiZSBwcm92aWRlZCBieQogdGhlIGNvbmZpZ3VyYXRpb24gYXV0aG9yLCBh
cyB0aGUgcmVtYWluaW5nIGZpZWxkcyB3aWxsIGJlIGRlcml2ZWQgZnJvbSB0aGUKIElETCBk
dXJpbmcgdGhlIG5vcm1hbGl6YXRpb24gcHJvY2Vzcy4gSXQgaXMgYW4gZXJyb3IgdG8gc3Bl
Y2lmeSBhbiBBUEkKIGludGVyZmFjZSBoZXJlIHdoaWNoIGNhbm5vdCBiZSByZXNvbHZlZCBh
Z2FpbnN0IHRoZSBhc3NvY2lhdGVkIElETCBmaWxlcy4KCgwKBQQAAgQEEgNoAgoKDAoFBAAC
BAYSA2gLHgoMCgUEAAIEARIDaB8jCgwKBQQAAgQDEgNoJicKiQMKBAQAAgUSA3ICKhr7AiBB
IGxpc3Qgb2YgYWxsIHByb3RvIG1lc3NhZ2UgdHlwZXMgaW5jbHVkZWQgaW4gdGhpcyBBUEkg
c2VydmljZS4KIFR5cGVzIHJlZmVyZW5jZWQgZGlyZWN0bHkgb3IgaW5kaXJlY3RseSBieSB0
aGUgYGFwaXNgIGFyZSBhdXRvbWF0aWNhbGx5CiBpbmNsdWRlZC4gIE1lc3NhZ2VzIHdoaWNo
IGFyZSBub3QgcmVmZXJlbmNlZCBidXQgc2hhbGwgYmUgaW5jbHVkZWQsIHN1Y2ggYXMKIHR5
cGVzIHVzZWQgYnkgdGhlIGBnb29nbGUucHJvdG9idWYuQW55YCB0eXBlLCBzaG91bGQgYmUg
bGlzdGVkIGhlcmUgYnkKIG5hbWUgYnkgdGhlIGNvbmZpZ3VyYXRpb24gYXV0aG9yLiBFeGFt
cGxlOgoKICAgICB0eXBlczoKICAgICAtIG5hbWU6IGdvb2dsZS5wcm90b2J1Zi5JbnQzMgoK
DAoFBAACBQQSA3ICCgoMCgUEAAIFBhIDcgsfCgwKBQQAAgUBEgNyICUKDAoFBAACBQMSA3Io
KQrLAgoEBAACBhIDewIqGr0CIEEgbGlzdCBvZiBhbGwgZW51bSB0eXBlcyBpbmNsdWRlZCBp
biB0aGlzIEFQSSBzZXJ2aWNlLiAgRW51bXMgcmVmZXJlbmNlZAogZGlyZWN0bHkgb3IgaW5k
aXJlY3RseSBieSB0aGUgYGFwaXNgIGFyZSBhdXRvbWF0aWNhbGx5IGluY2x1ZGVkLiAgRW51
bXMKIHdoaWNoIGFyZSBub3QgcmVmZXJlbmNlZCBidXQgc2hhbGwgYmUgaW5jbHVkZWQgc2hv
dWxkIGJlIGxpc3RlZCBoZXJlIGJ5CiBuYW1lIGJ5IHRoZSBjb25maWd1cmF0aW9uIGF1dGhv
ci4gRXhhbXBsZToKCiAgICAgZW51bXM6CiAgICAgLSBuYW1lOiBnb29nbGUuc29tZWFwaS52
MS5Tb21lRW51bQoKDAoFBAACBgQSA3sCCgoMCgUEAAIGBhIDewsfCgwKBQQAAgYBEgN7ICUK
DAoFBAACBgMSA3soKQosCgQEAAIHEgN+AiIaHyBBZGRpdGlvbmFsIEFQSSBkb2N1bWVudGF0
aW9uLgoKDAoFBAACBwYSA34CDwoMCgUEAAIHARIDfhAdCgwKBQQAAgcDEgN+ICEKKgoEBAAC
CBIEgQECFhocIEFQSSBiYWNrZW5kIGNvbmZpZ3VyYXRpb24uCgoNCgUEAAIIBhIEgQECCQoN
CgUEAAIIARIEgQEKEQoNCgUEAAIIAxIEgQEUFQojCgQEAAIJEgSEAQIQGhUgSFRUUCBjb25m
aWd1cmF0aW9uLgoKDQoFBAACCQYSBIQBAgYKDQoFBAACCQESBIQBBwsKDQoFBAACCQMSBIQB
Dg8KJAoEBAACChIEhwECExoWIFF1b3RhIGNvbmZpZ3VyYXRpb24uCgoNCgUEAAIKBhIEhwEC
BwoNCgUEAAIKARIEhwEIDQoNCgUEAAIKAxIEhwEQEgojCgQEAAILEgSKAQIlGhUgQXV0aCBj
b25maWd1cmF0aW9uLgoKDQoFBAACCwYSBIoBAhAKDQoFBAACCwESBIoBER8KDQoFBAACCwMS
BIoBIiQKJgoEBAACDBIEjQECFxoYIENvbnRleHQgY29uZmlndXJhdGlvbi4KCg0KBQQAAgwG
EgSNAQIJCg0KBQQAAgwBEgSNAQoRCg0KBQQAAgwDEgSNARQWCkAKBAQAAg0SBJABAhMaMiBD
b25maWd1cmF0aW9uIGNvbnRyb2xsaW5nIHVzYWdlIG9mIHRoaXMgc2VydmljZS4KCg0KBQQA
Ag0GEgSQAQIHCg0KBQQAAg0BEgSQAQgNCg0KBQQAAg0DEgSQARASCrUBCgQEAAIOEgSVAQIj
GqYBIENvbmZpZ3VyYXRpb24gZm9yIG5ldHdvcmsgZW5kcG9pbnRzLiAgSWYgdGhpcyBpcyBl
bXB0eSwgdGhlbiBhbiBlbmRwb2ludAogd2l0aCB0aGUgc2FtZSBuYW1lIGFzIHRoZSBzZXJ2
aWNlIGlzIGF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIHRvIHNlcnZpY2UgYWxsCiBkZWZpbmVk
IEFQSXMuCgoNCgUEAAIOBBIElQECCgoNCgUEAAIOBhIElQELEwoNCgUEAAIOARIElQEUHQoN
CgUEAAIOAxIElQEgIgo8CgQEAAIPEgSYAQIXGi4gQ29uZmlndXJhdGlvbiBmb3IgdGhlIHNl
cnZpY2UgY29udHJvbCBwbGFuZS4KCg0KBQQAAg8GEgSYAQIJCg0KBQQAAg8BEgSYAQoRCg0K
BQQAAg8DEgSYARQWCjYKBAQAAhASBJsBAiMaKCBEZWZpbmVzIHRoZSBsb2dzIHVzZWQgYnkg
dGhpcyBzZXJ2aWNlLgoKDQoFBAACEAQSBJsBAgoKDQoFBAACEAYSBJsBCxgKDQoFBAACEAES
BJsBGR0KDQoFBAACEAMSBJsBICIKOQoEBAACERIEngECKRorIERlZmluZXMgdGhlIG1ldHJp
Y3MgdXNlZCBieSB0aGlzIHNlcnZpY2UuCgoNCgUEAAIRBBIEngECCgoNCgUEAAIRBhIEngEL
GwoNCgUEAAIRARIEngEcIwoNCgUEAAIRAxIEngEmKAqaAQoEBAACEhIEogECQBqLASBEZWZp
bmVzIHRoZSBtb25pdG9yZWQgcmVzb3VyY2VzIHVzZWQgYnkgdGhpcyBzZXJ2aWNlLiBUaGlz
IGlzIHJlcXVpcmVkCiBieSB0aGUgYFNlcnZpY2UubW9uaXRvcmluZ2AgYW5kIGBTZXJ2aWNl
LmxvZ2dpbmdgIGNvbmZpZ3VyYXRpb25zLgoKDQoFBAACEgQSBKIBAgoKDQoFBAACEgYSBKIB
CyYKDQoFBAACEgESBKIBJzoKDQoFBAACEgMSBKIBPT8KJgoEBAACExIEpQECFxoYIEJpbGxp
bmcgY29uZmlndXJhdGlvbi4KCg0KBQQAAhMGEgSlAQIJCg0KBQQAAhMBEgSlAQoRCg0KBQQA
AhMDEgSlARQWCiYKBAQAAhQSBKgBAhcaGCBMb2dnaW5nIGNvbmZpZ3VyYXRpb24uCgoNCgUE
AAIUBhIEqAECCQoNCgUEAAIUARIEqAEKEQoNCgUEAAIUAxIEqAEUFgopCgQEAAIVEgSrAQId
GhsgTW9uaXRvcmluZyBjb25maWd1cmF0aW9uLgoKDQoFBAACFQYSBKsBAgwKDQoFBAACFQES
BKsBDRcKDQoFBAACFQMSBKsBGhwKLwoEBAACFhIErgECKhohIFN5c3RlbSBwYXJhbWV0ZXIg
Y29uZmlndXJhdGlvbi4KCg0KBQQAAhYGEgSuAQISCg0KBQQAAhYBEgSuARMkCg0KBQQAAhYD
EgSuAScpClgKBAQAAhcSBLEBAh4aSiBPdXRwdXQgb25seS4gVGhlIHNvdXJjZSBpbmZvcm1h
dGlvbiBmb3IgdGhpcyBjb25maWd1cmF0aW9uIGlmIGF2YWlsYWJsZS4KCg0KBQQAAhcGEgSx
AQIMCg0KBQQAAhcBEgSxAQ0YCg0KBQQAAhcDEgSxARsdCqsBCgQEAAIYEgS2AQIdGpwBIFNl
dHRpbmdzIGZvciBbR29vZ2xlIENsb3VkIENsaWVudAogbGlicmFyaWVzXShodHRwczovL2Ns
b3VkLmdvb2dsZS5jb20vYXBpcy9kb2NzL2Nsb3VkLWNsaWVudC1saWJyYXJpZXMpCiBnZW5l
cmF0ZWQgZnJvbSBBUElzIGRlZmluZWQgYXMgcHJvdG9jb2wgYnVmZmVycy4KCg0KBQQAAhgG
EgS2AQIMCg0KBQQAAhgBEgS2AQ0XCg0KBQQAAhgDEgS2ARocCocBCgQEAAIZEgS8AQIyGnkg
T2Jzb2xldGUuIERvIG5vdCB1c2UuCgogVGhpcyBmaWVsZCBoYXMgbm8gc2VtYW50aWMgbWVh
bmluZy4gVGhlIHNlcnZpY2UgY29uZmlnIGNvbXBpbGVyIGFsd2F5cwogc2V0cyB0aGlzIGZp
ZWxkIHRvIGAzYC4KCg0KBQQAAhkGEgS8AQIdCg0KBQQAAhkBEgS8AR4sCg0KBQQAAhkDEgS8
AS8xYgZwcm90bzM=
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Service::Service ===
    # Fields for Service
    # Field: name Type: 9 ()
    # Field: title Type: 9 ()
    # Field: producer_project_id Type: 9 ()
    # Field: id Type: 9 ()
    # Field: apis Type: 11 (.google.protobuf.Api)
    # Field: types Type: 11 (.google.protobuf.Type)
    # Field: enums Type: 11 (.google.protobuf.Enum)
    # Field: documentation Type: 11 (.google.api.Documentation)
    # Field: backend Type: 11 (.google.api.Backend)
    # Field: http Type: 11 (.google.api.Http)
    # Field: quota Type: 11 (.google.api.Quota)
    # Field: authentication Type: 11 (.google.api.Authentication)
    # Field: context Type: 11 (.google.api.Context)
    # Field: usage Type: 11 (.google.api.Usage)
    # Field: endpoints Type: 11 (.google.api.Endpoint)
    # Field: control Type: 11 (.google.api.Control)
    # Field: logs Type: 11 (.google.api.LogDescriptor)
    # Field: metrics Type: 11 (.google.api.MetricDescriptor)
    # Field: monitored_resources Type: 11 (.google.api.MonitoredResourceDescriptor)
    # Field: billing Type: 11 (.google.api.Billing)
    # Field: logging Type: 11 (.google.api.Logging)
    # Field: monitoring Type: 11 (.google.api.Monitoring)
    # Field: system_parameters Type: 11 (.google.api.SystemParameters)
    # Field: source_info Type: 11 (.google.api.SourceInfo)
    # Field: publishing Type: 11 (.google.api.Publishing)
    # Field: config_version Type: 11 (.google.protobuf.UInt32Value)

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Service - Compiled Protocol Buffers messages for google/api/service.proto

=head1 SYNOPSIS

    use Google::Api::Service;

    my $msg = Google::Api::Service::Service->new({
        name => $name,
        title => $title,
        producer_project_id => $producer_project_id,
        id => $id,
    });

    # Read or update a field
    my $val = $msg->name();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Service::Service->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/service.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Service::Service

`Service` is the root object of Google API service configuration (service
config). It describes the basic information about a logical service,
such as the service name and the user-facing title, and delegates other
aspects to sub-sections. Each sub-section is either a proto message or a
repeated proto message that configures a specific aspect, such as auth.
For more information, see each proto message definition.

Example:

    type: google.api.Service
    name: calendar.googleapis.com
    title: Google Calendar API
    apis:
    - name: google.calendar.v3.Calendar

    visibility:
      rules:
      - selector: "google.calendar.v3.*"
        restriction: PREVIEW
    backend:
      rules:
      - selector: "google.calendar.v3.*"
        address: calendar.example.com

    authentication:
      providers:
      - id: google_calendar_auth
        jwks_uri: https://www.googleapis.com/oauth2/v1/certs
        issuer: https://securetoken.google.com
      rules:
      - selector: "*"
        requirements:
          provider_id: google_calendar_auth

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->name() >> / C<< $msg->name($value) >>

Type: C<String>

The service name, which is a DNS-like logical identifier for the
service, such as `calendar.googleapis.com`. The service name
typically goes through DNS verification to make sure the owner
of the service also owns the DNS name.

=item * C<< $msg->title() >> / C<< $msg->title($value) >>

Type: C<String>

The product title for this service, it is the name displayed in Google
Cloud Console.

=item * C<< $msg->producer_project_id() >> / C<< $msg->producer_project_id($value) >>

Type: C<String>

The Google project that owns this service.

=item * C<< $msg->id() >> / C<< $msg->id($value) >>

Type: C<String>

A unique ID for a specific instance of this message, typically assigned
by the client for tracking purpose. Must be no longer than 63 characters
and only lower case letters, digits, '.', '_' and '-' are allowed. If
empty, the server may choose to generate one instead.

=item * C<< $msg->apis() >> / C<< $msg->apis($value) >>

Type: C<Message> (L<Google::Protobuf::Api::Api>)

A list of API interfaces exported by this service. Only the `name` field
of the [google.protobuf.Api][google.protobuf.Api] needs to be provided by
the configuration author, as the remaining fields will be derived from the
IDL during the normalization process. It is an error to specify an API
interface here which cannot be resolved against the associated IDL files.

=item * C<< $msg->types() >> / C<< $msg->types($value) >>

Type: C<Message> (L<Google::Protobuf::Type::Type>)

A list of all proto message types included in this API service.
Types referenced directly or indirectly by the `apis` are automatically
included.  Messages which are not referenced but shall be included, such as
types used by the `google.protobuf.Any` type, should be listed here by
name by the configuration author. Example:

    types:
    - name: google.protobuf.Int32

=item * C<< $msg->enums() >> / C<< $msg->enums($value) >>

Type: C<Message> (L<Google::Protobuf::Type::Enum>)

A list of all enum types included in this API service.  Enums referenced
directly or indirectly by the `apis` are automatically included.  Enums
which are not referenced but shall be included should be listed here by
name by the configuration author. Example:

    enums:
    - name: google.someapi.v1.SomeEnum

=item * C<< $msg->documentation() >> / C<< $msg->documentation($value) >>

Type: C<Message> (L<Google::Api::Documentation::Documentation>)

Additional API documentation.

=item * C<< $msg->backend() >> / C<< $msg->backend($value) >>

Type: C<Message> (L<Google::Api::Backend::Backend>)

API backend configuration.

=item * C<< $msg->http() >> / C<< $msg->http($value) >>

Type: C<Message> (L<Google::Api::Http::Http>)

HTTP configuration.

=item * C<< $msg->quota() >> / C<< $msg->quota($value) >>

Type: C<Message> (L<Google::Api::Quota::Quota>)

Quota configuration.

=item * C<< $msg->authentication() >> / C<< $msg->authentication($value) >>

Type: C<Message> (L<Google::Api::Auth::Authentication>)

Auth configuration.

=item * C<< $msg->context() >> / C<< $msg->context($value) >>

Type: C<Message> (L<Google::Api::Context::Context>)

Context configuration.

=item * C<< $msg->usage() >> / C<< $msg->usage($value) >>

Type: C<Message> (L<Google::Api::Usage::Usage>)

Configuration controlling usage of this service.

=item * C<< $msg->endpoints() >> / C<< $msg->endpoints($value) >>

Type: C<Message> (L<Google::Api::Endpoint::Endpoint>)

Configuration for network endpoints.  If this is empty, then an endpoint
with the same name as the service is automatically generated to service all
defined APIs.

=item * C<< $msg->control() >> / C<< $msg->control($value) >>

Type: C<Message> (L<Google::Api::Control::Control>)

Configuration for the service control plane.

=item * C<< $msg->logs() >> / C<< $msg->logs($value) >>

Type: C<Message> (L<Google::Api::Log::LogDescriptor>)

Defines the logs used by this service.

=item * C<< $msg->metrics() >> / C<< $msg->metrics($value) >>

Type: C<Message> (L<Google::Api::Metric::MetricDescriptor>)

Defines the metrics used by this service.

=item * C<< $msg->monitored_resources() >> / C<< $msg->monitored_resources($value) >>

Type: C<Message> (L<Google::Api::MonitoredResource::MonitoredResourceDescriptor>)

Defines the monitored resources used by this service. This is required
by the `Service.monitoring` and `Service.logging` configurations.

=item * C<< $msg->billing() >> / C<< $msg->billing($value) >>

Type: C<Message> (L<Google::Api::Billing::Billing>)

Billing configuration.

=item * C<< $msg->logging() >> / C<< $msg->logging($value) >>

Type: C<Message> (L<Google::Api::Logging::Logging>)

Logging configuration.

=item * C<< $msg->monitoring() >> / C<< $msg->monitoring($value) >>

Type: C<Message> (L<Google::Api::Monitoring::Monitoring>)

Monitoring configuration.

=item * C<< $msg->system_parameters() >> / C<< $msg->system_parameters($value) >>

Type: C<Message> (L<Google::Api::SystemParameter::SystemParameters>)

System parameter configuration.

=item * C<< $msg->source_info() >> / C<< $msg->source_info($value) >>

Type: C<Message> (L<Google::Api::SourceInfo::SourceInfo>)

Output only. The source information for this configuration if available.

=item * C<< $msg->publishing() >> / C<< $msg->publishing($value) >>

Type: C<Message> (L<Google::Api::Client::Publishing>)

Settings for [Google Cloud Client
libraries](https://cloud.google.com/apis/docs/cloud-client-libraries)
generated from APIs defined as protocol buffers.

=item * C<< $msg->config_version() >> / C<< $msg->config_version($value) >>

Type: C<Message> (L<Google::Protobuf::Wrappers::UInt32Value>)

Obsolete. Do not use.

This field has no semantic meaning. The service config compiler always
sets this field to `3`.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Service::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

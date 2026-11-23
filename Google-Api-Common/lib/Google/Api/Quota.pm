package Google::Api::Quota;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
ChZnb29nbGUvYXBpL3F1b3RhLnByb3RvEgpnb29nbGUuYXBpInIKBVF1b3RhEi4KBmxpbWl0
cxgDIAMoCzIWLmdvb2dsZS5hcGkuUXVvdGFMaW1pdFIGbGltaXRzEjkKDG1ldHJpY19ydWxl
cxgEIAMoCzIWLmdvb2dsZS5hcGkuTWV0cmljUnVsZVILbWV0cmljUnVsZXMitAEKCk1ldHJp
Y1J1bGUSGgoIc2VsZWN0b3IYASABKAlSCHNlbGVjdG9yEkoKDG1ldHJpY19jb3N0cxgCIAMo
CzInLmdvb2dsZS5hcGkuTWV0cmljUnVsZS5NZXRyaWNDb3N0c0VudHJ5UgttZXRyaWNDb3N0
cxo+ChBNZXRyaWNDb3N0c0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgD
UgV2YWx1ZToCOAEigwMKClF1b3RhTGltaXQSEgoEbmFtZRgGIAEoCVIEbmFtZRIgCgtkZXNj
cmlwdGlvbhgCIAEoCVILZGVzY3JpcHRpb24SIwoNZGVmYXVsdF9saW1pdBgDIAEoA1IMZGVm
YXVsdExpbWl0EhsKCW1heF9saW1pdBgEIAEoA1IIbWF4TGltaXQSGwoJZnJlZV90aWVyGAcg
ASgDUghmcmVlVGllchIaCghkdXJhdGlvbhgFIAEoCVIIZHVyYXRpb24SFgoGbWV0cmljGAgg
ASgJUgZtZXRyaWMSEgoEdW5pdBgJIAEoCVIEdW5pdBI6CgZ2YWx1ZXMYCiADKAsyIi5nb29n
bGUuYXBpLlF1b3RhTGltaXQuVmFsdWVzRW50cnlSBnZhbHVlcxIhCgxkaXNwbGF5X25hbWUY
DCABKAlSC2Rpc3BsYXlOYW1lGjkKC1ZhbHVlc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQK
BXZhbHVlGAIgASgDUgV2YWx1ZToCOAFCbAoOY29tLmdvb2dsZS5hcGlCClF1b3RhUHJvdG9Q
AVpFZ29vZ2xlLmdvbGFuZy5vcmcvZ2VucHJvdG8vZ29vZ2xlYXBpcy9hcGkvc2VydmljZWNv
bmZpZztzZXJ2aWNlY29uZmlnogIER0FQSUrLNwoHEgUOALcBAQq8BAoBDBIDDgASMrEEIENv
cHlyaWdodCAyMDI2IEdvb2dsZSBMTEMKCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExp
Y2Vuc2UsIFZlcnNpb24gMi4wICh0aGUgIkxpY2Vuc2UiKTsKIHlvdSBtYXkgbm90IHVzZSB0
aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS4KIFlvdSBt
YXkgb2J0YWluIGEgY29weSBvZiB0aGUgTGljZW5zZSBhdAoKICAgICBodHRwOi8vd3d3LmFw
YWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAKCiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBw
bGljYWJsZSBsYXcgb3IgYWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlCiBkaXN0cmli
dXRlZCB1bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiAiQVMgSVMiIEJB
U0lTLAogV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVp
dGhlciBleHByZXNzIG9yIGltcGxpZWQuCiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVj
aWZpYyBsYW5ndWFnZSBnb3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kCiBsaW1pdGF0aW9ucyB1
bmRlciB0aGUgTGljZW5zZS4KCggKAQISAxAAEwoICgEIEgMSAFwKCQoCCAsSAxIAXAoICgEI
EgMTACIKCQoCCAoSAxMAIgoICgEIEgMUACsKCQoCCAgSAxQAKwoICgEIEgMVACcKCQoCCAES
AxUAJwoICgEIEgMWACIKCQoCCCQSAxYAIgqEDQoCBAASBEsAUgEa9wwgUXVvdGEgY29uZmln
dXJhdGlvbiBoZWxwcyB0byBhY2hpZXZlIGZhaXJuZXNzIGFuZCBidWRnZXRpbmcgaW4gc2Vy
dmljZQogdXNhZ2UuCgogVGhlIG1ldHJpYyBiYXNlZCBxdW90YSBjb25maWd1cmF0aW9uIHdv
cmtzIHRoaXMgd2F5OgogLSBUaGUgc2VydmljZSBjb25maWd1cmF0aW9uIGRlZmluZXMgYSBz
ZXQgb2YgbWV0cmljcy4KIC0gRm9yIEFQSSBjYWxscywgdGhlIHF1b3RhLm1ldHJpY19ydWxl
cyBtYXBzIG1ldGhvZHMgdG8gbWV0cmljcyB3aXRoCiAgIGNvcnJlc3BvbmRpbmcgY29zdHMu
CiAtIFRoZSBxdW90YS5saW1pdHMgZGVmaW5lcyBsaW1pdHMgb24gdGhlIG1ldHJpY3MsIHdo
aWNoIHdpbGwgYmUgdXNlZCBmb3IKICAgcXVvdGEgY2hlY2tzIGF0IHJ1bnRpbWUuCgogQW4g
ZXhhbXBsZSBxdW90YSBjb25maWd1cmF0aW9uIGluIHlhbWwgZm9ybWF0OgoKICAgIHF1b3Rh
OgogICAgICBsaW1pdHM6CgogICAgICAtIG5hbWU6IGFwaVdyaXRlUXBzUGVyUHJvamVjdAog
ICAgICAgIG1ldHJpYzogbGlicmFyeS5nb29nbGVhcGlzLmNvbS93cml0ZV9jYWxscwogICAg
ICAgIHVuaXQ6ICIxL21pbi97cHJvamVjdH0iICAjIHJhdGUgbGltaXQgZm9yIGNvbnN1bWVy
IHByb2plY3RzCiAgICAgICAgdmFsdWVzOgogICAgICAgICAgU1RBTkRBUkQ6IDEwMDAwCgoK
ICAgICAgKFRoZSBtZXRyaWMgcnVsZXMgYmluZCBhbGwgbWV0aG9kcyB0byB0aGUgcmVhZF9j
YWxscyBtZXRyaWMsCiAgICAgICBleGNlcHQgZm9yIHRoZSBVcGRhdGVCb29rIGFuZCBEZWxl
dGVCb29rIG1ldGhvZHMuIFRoZXNlIHR3byBtZXRob2RzCiAgICAgICBhcmUgbWFwcGVkIHRv
IHRoZSB3cml0ZV9jYWxscyBtZXRyaWMsIHdpdGggdGhlIFVwZGF0ZUJvb2sgbWV0aG9kCiAg
ICAgICBjb25zdW1pbmcgYXQgdHdpY2UgcmF0ZSBhcyB0aGUgRGVsZXRlQm9vayBtZXRob2Qu
KQogICAgICBtZXRyaWNfcnVsZXM6CiAgICAgIC0gc2VsZWN0b3I6ICIqIgogICAgICAgIG1l
dHJpY19jb3N0czoKICAgICAgICAgIGxpYnJhcnkuZ29vZ2xlYXBpcy5jb20vcmVhZF9jYWxs
czogMQogICAgICAtIHNlbGVjdG9yOiBnb29nbGUuZXhhbXBsZS5saWJyYXJ5LnYxLkxpYnJh
cnlTZXJ2aWNlLlVwZGF0ZUJvb2sKICAgICAgICBtZXRyaWNfY29zdHM6CiAgICAgICAgICBs
aWJyYXJ5Lmdvb2dsZWFwaXMuY29tL3dyaXRlX2NhbGxzOiAyCiAgICAgIC0gc2VsZWN0b3I6
IGdvb2dsZS5leGFtcGxlLmxpYnJhcnkudjEuTGlicmFyeVNlcnZpY2UuRGVsZXRlQm9vawog
ICAgICAgIG1ldHJpY19jb3N0czoKICAgICAgICAgIGxpYnJhcnkuZ29vZ2xlYXBpcy5jb20v
d3JpdGVfY2FsbHM6IDEKCiAgQ29ycmVzcG9uZGluZyBNZXRyaWMgZGVmaW5pdGlvbjoKCiAg
ICAgIG1ldHJpY3M6CiAgICAgIC0gbmFtZTogbGlicmFyeS5nb29nbGVhcGlzLmNvbS9yZWFk
X2NhbGxzCiAgICAgICAgZGlzcGxheV9uYW1lOiBSZWFkIHJlcXVlc3RzCiAgICAgICAgbWV0
cmljX2tpbmQ6IERFTFRBCiAgICAgICAgdmFsdWVfdHlwZTogSU5UNjQKCiAgICAgIC0gbmFt
ZTogbGlicmFyeS5nb29nbGVhcGlzLmNvbS93cml0ZV9jYWxscwogICAgICAgIGRpc3BsYXlf
bmFtZTogV3JpdGUgcmVxdWVzdHMKICAgICAgICBtZXRyaWNfa2luZDogREVMVEEKICAgICAg
ICB2YWx1ZV90eXBlOiBJTlQ2NAoKCgoKCgMEAAESA0sIDQo+CgQEAAIAEgNNAiEaMSBMaXN0
IG9mIFF1b3RhTGltaXQgZGVmaW5pdGlvbnMgZm9yIHRoZSBzZXJ2aWNlLgoKDAoFBAACAAQS
A00CCgoMCgUEAAIABhIDTQsVCgwKBQQAAgABEgNNFhwKDAoFBAACAAMSA00fIApqCgQEAAIB
EgNRAicaXSBMaXN0IG9mIE1ldHJpY1J1bGUgZGVmaW5pdGlvbnMsIGVhY2ggb25lIG1hcHBp
bmcgYSBzZWxlY3RlZCBtZXRob2QgdG8gb25lCiBvciBtb3JlIG1ldHJpY3MuCgoMCgUEAAIB
BBIDUQIKCgwKBQQAAgEGEgNRCxUKDAoFBAACAQESA1EWIgoMCgUEAAIBAxIDUSUmCpYBCgIE
ARIEVgBkARqJASBCaW5kIEFQSSBtZXRob2RzIHRvIG1ldHJpY3MuIEJpbmRpbmcgYSBtZXRo
b2QgdG8gYSBtZXRyaWMgY2F1c2VzIHRoYXQKIG1ldHJpYydzIGNvbmZpZ3VyZWQgcXVvdGEg
YmVoYXZpb3JzIHRvIGFwcGx5IHRvIHRoZSBtZXRob2QgY2FsbC4KCgoKAwQBARIDVggSCpEB
CgQEAQIAEgNbAhYagwEgU2VsZWN0cyB0aGUgbWV0aG9kcyB0byB3aGljaCB0aGlzIHJ1bGUg
YXBwbGllcy4KCiBSZWZlciB0byBbc2VsZWN0b3JdW2dvb2dsZS5hcGkuRG9jdW1lbnRhdGlv
blJ1bGUuc2VsZWN0b3JdIGZvciBzeW50YXgKIGRldGFpbHMuCgoMCgUEAQIABRIDWwIICgwK
BQQBAgABEgNbCREKDAoFBAECAAMSA1sUFQqmAgoEBAECARIDYwImGpgCIE1ldHJpY3MgdG8g
dXBkYXRlIHdoZW4gdGhlIHNlbGVjdGVkIG1ldGhvZHMgYXJlIGNhbGxlZCwgYW5kIHRoZSBh
c3NvY2lhdGVkCiBjb3N0IGFwcGxpZWQgdG8gZWFjaCBtZXRyaWMuCgogVGhlIGtleSBvZiB0
aGUgbWFwIGlzIHRoZSBtZXRyaWMgbmFtZSwgYW5kIHRoZSB2YWx1ZXMgYXJlIHRoZSBhbW91
bnQKIGluY3JlYXNlZCBmb3IgdGhlIG1ldHJpYyBhZ2FpbnN0IHdoaWNoIHRoZSBxdW90YSBs
aW1pdHMgYXJlIGRlZmluZWQuCiBUaGUgdmFsdWUgbXVzdCBub3QgYmUgbmVnYXRpdmUuCgoM
CgUEAQIBBhIDYwIUCgwKBQQBAgEBEgNjFSEKDAoFBAECAQMSA2MkJQrYAQoCBAISBWkAtwEB
GsoBIGBRdW90YUxpbWl0YCBkZWZpbmVzIGEgc3BlY2lmaWMgbGltaXQgdGhhdCBhcHBsaWVz
IG92ZXIgYSBzcGVjaWZpZWQgZHVyYXRpb24KIGZvciBhIGxpbWl0IHR5cGUuIFRoZXJlIGNh
biBiZSBhdCBtb3N0IG9uZSBsaW1pdCBmb3IgYSBkdXJhdGlvbiBhbmQgbGltaXQKIHR5cGUg
Y29tYmluYXRpb24gZGVmaW5lZCB3aXRoaW4gYSBgUXVvdGFHcm91cGAuCgoKCgMEAgESA2kI
EgrrAQoEBAICABIDcAISGt0BIE5hbWUgb2YgdGhlIHF1b3RhIGxpbWl0LgoKIFRoZSBuYW1l
IG11c3QgYmUgcHJvdmlkZWQsIGFuZCBpdCBtdXN0IGJlIHVuaXF1ZSB3aXRoaW4gdGhlIHNl
cnZpY2UuIFRoZQogbmFtZSBjYW4gb25seSBpbmNsdWRlIGFscGhhbnVtZXJpYyBjaGFyYWN0
ZXJzIGFzIHdlbGwgYXMgJy0nLgoKIFRoZSBtYXhpbXVtIGxlbmd0aCBvZiB0aGUgbGltaXQg
bmFtZSBpcyA2NCBjaGFyYWN0ZXJzLgoKDAoFBAICAAUSA3ACCAoMCgUEAgIAARIDcAkNCgwK
BQQCAgADEgNwEBEK3gEKBAQCAgESA3UCGRrQASBPcHRpb25hbC4gVXNlci12aXNpYmxlLCBl
eHRlbmRlZCBkZXNjcmlwdGlvbiBmb3IgdGhpcyBxdW90YSBsaW1pdC4KIFNob3VsZCBiZSB1
c2VkIG9ubHkgd2hlbiBtb3JlIGNvbnRleHQgaXMgbmVlZGVkIHRvIHVuZGVyc3RhbmQgdGhp
cyBsaW1pdAogdGhhbiBwcm92aWRlZCBieSB0aGUgbGltaXQncyBkaXNwbGF5IG5hbWUgKHNl
ZTogYGRpc3BsYXlfbmFtZWApLgoKDAoFBAICAQUSA3UCCAoMCgUEAgIBARIDdQkUCgwKBQQC
AgEDEgN1FxgK6AMKBAQCAgISBIEBAhoa2QMgRGVmYXVsdCBudW1iZXIgb2YgdG9rZW5zIHRo
YXQgY2FuIGJlIGNvbnN1bWVkIGR1cmluZyB0aGUgc3BlY2lmaWVkCiBkdXJhdGlvbi4gVGhp
cyBpcyB0aGUgbnVtYmVyIG9mIHRva2VucyBhc3NpZ25lZCB3aGVuIGEgY2xpZW50CiBhcHBs
aWNhdGlvbiBkZXZlbG9wZXIgYWN0aXZhdGVzIHRoZSBzZXJ2aWNlIGZvciBoaXMvaGVyIHBy
b2plY3QuCgogU3BlY2lmeWluZyBhIHZhbHVlIG9mIDAgd2lsbCBibG9jayBhbGwgcmVxdWVz
dHMuIFRoaXMgY2FuIGJlIHVzZWQgaWYgeW91CiBhcmUgcHJvdmlzaW9uaW5nIHF1b3RhIHRv
IHNlbGVjdGVkIGNvbnN1bWVycyBhbmQgYmxvY2tpbmcgb3RoZXJzLgogU2ltaWxhcmx5LCBh
IHZhbHVlIG9mIC0xIHdpbGwgaW5kaWNhdGUgYW4gdW5saW1pdGVkIHF1b3RhLiBObyBvdGhl
cgogbmVnYXRpdmUgdmFsdWVzIGFyZSBhbGxvd2VkLgoKIFVzZWQgYnkgZ3JvdXAtYmFzZWQg
cXVvdGFzIG9ubHkuCgoNCgUEAgICBRIEgQECBwoNCgUEAgICARIEgQEIFQoNCgUEAgICAxIE
gQEYGQrFAwoEBAICAxIEjAECFhq2AyBNYXhpbXVtIG51bWJlciBvZiB0b2tlbnMgdGhhdCBj
YW4gYmUgY29uc3VtZWQgZHVyaW5nIHRoZSBzcGVjaWZpZWQKIGR1cmF0aW9uLiBDbGllbnQg
YXBwbGljYXRpb24gZGV2ZWxvcGVycyBjYW4gb3ZlcnJpZGUgdGhlIGRlZmF1bHQgbGltaXQg
dXAKIHRvIHRoaXMgbWF4aW11bS4gSWYgc3BlY2lmaWVkLCB0aGlzIHZhbHVlIGNhbm5vdCBi
ZSBzZXQgdG8gYSB2YWx1ZSBsZXNzCiB0aGFuIHRoZSBkZWZhdWx0IGxpbWl0LiBJZiBub3Qg
c3BlY2lmaWVkLCBpdCBpcyBzZXQgdG8gdGhlIGRlZmF1bHQgbGltaXQuCgogVG8gYWxsb3cg
Y2xpZW50cyB0byBhcHBseSBvdmVycmlkZXMgd2l0aCBubyB1cHBlciBib3VuZCwgc2V0IHRo
aXMgdG8gLTEsCiBpbmRpY2F0aW5nIHVubGltaXRlZCBtYXhpbXVtIHF1b3RhLgoKIFVzZWQg
YnkgZ3JvdXAtYmFzZWQgcXVvdGFzIG9ubHkuCgoNCgUEAgIDBRIEjAECBwoNCgUEAgIDARIE
jAEIEQoNCgUEAgIDAxIEjAEUFQq/AwoEBAICBBIElgECFhqwAyBGcmVlIHRpZXIgdmFsdWUg
ZGlzcGxheWVkIGluIHRoZSBEZXZlbG9wZXJzIENvbnNvbGUgZm9yIHRoaXMgbGltaXQuCiBU
aGUgZnJlZSB0aWVyIGlzIHRoZSBudW1iZXIgb2YgdG9rZW5zIHRoYXQgd2lsbCBiZSBzdWJ0
cmFjdGVkIGZyb20gdGhlCiBiaWxsZWQgYW1vdW50IHdoZW4gYmlsbGluZyBpcyBlbmFibGVk
LgogVGhpcyBmaWVsZCBjYW4gb25seSBiZSBzZXQgb24gYSBsaW1pdCB3aXRoIGR1cmF0aW9u
ICIxZCIsIGluIGEgYmlsbGFibGUKIGdyb3VwOyBpdCBpcyBpbnZhbGlkIG9uIGFueSBvdGhl
ciBsaW1pdC4gSWYgdGhpcyBmaWVsZCBpcyBub3Qgc2V0LCBpdAogZGVmYXVsdHMgdG8gMCwg
aW5kaWNhdGluZyB0aGF0IHRoZXJlIGlzIG5vIGZyZWUgdGllciBmb3IgdGhpcyBzZXJ2aWNl
LgoKIFVzZWQgYnkgZ3JvdXAtYmFzZWQgcXVvdGFzIG9ubHkuCgoNCgUEAgIEBRIElgECBwoN
CgUEAgIEARIElgEIEQoNCgUEAgIEAxIElgEUFQp2CgQEAgIFEgSbAQIWGmggRHVyYXRpb24g
b2YgdGhpcyBsaW1pdCBpbiB0ZXh0dWFsIG5vdGF0aW9uLiBNdXN0IGJlICIxMDBzIiBvciAi
MWQiLgoKIFVzZWQgYnkgZ3JvdXAtYmFzZWQgcXVvdGFzIG9ubHkuCgoNCgUEAgIFBRIEmwEC
CAoNCgUEAgIFARIEmwEJEQoNCgUEAgIFAxIEmwEUFQrLAQoEBAICBhIEoAECFBq8ASBUaGUg
bmFtZSBvZiB0aGUgbWV0cmljIHRoaXMgcXVvdGEgbGltaXQgYXBwbGllcyB0by4gVGhlIHF1
b3RhIGxpbWl0cyB3aXRoCiB0aGUgc2FtZSBtZXRyaWMgd2lsbCBiZSBjaGVja2VkIHRvZ2V0
aGVyIGR1cmluZyBydW50aW1lLiBUaGUgbWV0cmljIG11c3QgYmUKIGRlZmluZWQgd2l0aGlu
IHRoZSBzZXJ2aWNlIGNvbmZpZy4KCg0KBQQCAgYFEgSgAQIICg0KBQQCAgYBEgSgAQkPCg0K
BQQCAgYDEgSgARITCqIDCgQEAgIHEgSrAQISGpMDIFNwZWNpZnkgdGhlIHVuaXQgb2YgdGhl
IHF1b3RhIGxpbWl0LiBJdCB1c2VzIHRoZSBzYW1lIHN5bnRheCBhcwogW01ldHJpY0Rlc2Ny
aXB0b3IudW5pdF1bZ29vZ2xlLmFwaS5NZXRyaWNEZXNjcmlwdG9yLnVuaXRdLiBUaGUgc3Vw
cG9ydGVkCiB1bml0IGtpbmRzIGFyZSBkZXRlcm1pbmVkIGJ5IHRoZSBxdW90YSBiYWNrZW5k
IHN5c3RlbS4KCiBIZXJlIGFyZSBzb21lIGV4YW1wbGVzOgogKiAiMS9taW4ve3Byb2plY3R9
IiBmb3IgcXVvdGEgcGVyIG1pbnV0ZSBwZXIgcHJvamVjdC4KCiBOb3RlOiB0aGUgb3JkZXIg
b2YgdW5pdCBjb21wb25lbnRzIGlzIGluc2lnbmlmaWNhbnQuCiBUaGUgIjEiIGF0IHRoZSBi
ZWdpbm5pbmcgaXMgcmVxdWlyZWQgdG8gZm9sbG93IHRoZSBtZXRyaWMgdW5pdCBzeW50YXgu
CgoNCgUEAgIHBRIEqwECCAoNCgUEAgIHARIEqwEJDQoNCgUEAgIHAxIEqwEQEQrVAQoEBAIC
CBIEsAECIRrGASBUaWVyZWQgbGltaXQgdmFsdWVzLiBZb3UgbXVzdCBzcGVjaWZ5IHRoaXMg
YXMgYSBrZXk6dmFsdWUgcGFpciwgd2l0aCBhbgogaW50ZWdlciB2YWx1ZSB0aGF0IGlzIHRo
ZSBtYXhpbXVtIG51bWJlciBvZiByZXF1ZXN0cyBhbGxvd2VkIGZvciB0aGUKIHNwZWNpZmll
ZCB1bml0LiBDdXJyZW50bHkgb25seSBTVEFOREFSRCBpcyBzdXBwb3J0ZWQuCgoNCgUEAgII
BhIEsAECFAoNCgUEAgIIARIEsAEVGwoNCgUEAgIIAxIEsAEeIAr+AQoEBAICCRIEtgECGxrv
ASBVc2VyLXZpc2libGUgZGlzcGxheSBuYW1lIGZvciB0aGlzIGxpbWl0LgogT3B0aW9uYWwu
IElmIG5vdCBzZXQsIHRoZSBVSSB3aWxsIHByb3ZpZGUgYSBkZWZhdWx0IGRpc3BsYXkgbmFt
ZSBiYXNlZCBvbgogdGhlIHF1b3RhIGNvbmZpZ3VyYXRpb24uIFRoaXMgZmllbGQgY2FuIGJl
IHVzZWQgdG8gb3ZlcnJpZGUgdGhlIGRlZmF1bHQKIGRpc3BsYXkgbmFtZSBnZW5lcmF0ZWQg
ZnJvbSB0aGUgY29uZmlndXJhdGlvbi4KCg0KBQQCAgkFEgS2AQIICg0KBQQCAgkBEgS2AQkV
Cg0KBQQCAgkDEgS2ARgaYgZwcm90bzM=
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Quota::Quota ===
    # Fields for Quota
    # Field: limits Type: 11 (.google.api.QuotaLimit)
    # Field: metric_rules Type: 11 (.google.api.MetricRule)

# === Message: Google::Api::Quota::MetricRule ===
    # Fields for MetricRule
    # Field: selector Type: 9 ()
    # Field: metric_costs Type: 11 (.google.api.MetricRule.MetricCostsEntry)

# === Message: Google::Api::Quota::QuotaLimit ===
    # Fields for QuotaLimit
    # Field: name Type: 9 ()
    # Field: description Type: 9 ()
    # Field: default_limit Type: 3 ()
    # Field: max_limit Type: 3 ()
    # Field: free_tier Type: 3 ()
    # Field: duration Type: 9 ()
    # Field: metric Type: 9 ()
    # Field: unit Type: 9 ()
    # Field: values Type: 11 (.google.api.QuotaLimit.ValuesEntry)
    # Field: display_name Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Quota - Compiled Protocol Buffers messages for google/api/quota.proto

=head1 SYNOPSIS

    use Google::Api::Quota;

    my $msg = Google::Api::Quota::Quota->new({
        limits => $limits,
        metric_rules => $metric_rules,
    });

    # Read or update a field
    my $val = $msg->limits();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Quota::Quota->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/quota.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Quota::Quota

Quota configuration helps to achieve fairness and budgeting in service
usage.

The metric based quota configuration works this way:
- The service configuration defines a set of metrics.
- For API calls, the quota.metric_rules maps methods to metrics with
  corresponding costs.
- The quota.limits defines limits on the metrics, which will be used for
  quota checks at runtime.

An example quota configuration in yaml format:

   quota:
     limits:

     - name: apiWriteQpsPerProject
       metric: library.googleapis.com/write_calls
       unit: "1/min/{project}"  # rate limit for consumer projects
       values:
         STANDARD: 10000


     (The metric rules bind all methods to the read_calls metric,
      except for the UpdateBook and DeleteBook methods. These two methods
      are mapped to the write_calls metric, with the UpdateBook method
      consuming at twice rate as the DeleteBook method.)
     metric_rules:
     - selector: "*"
       metric_costs:
         library.googleapis.com/read_calls: 1
     - selector: google.example.library.v1.LibraryService.UpdateBook
       metric_costs:
         library.googleapis.com/write_calls: 2
     - selector: google.example.library.v1.LibraryService.DeleteBook
       metric_costs:
         library.googleapis.com/write_calls: 1

 Corresponding Metric definition:

     metrics:
     - name: library.googleapis.com/read_calls
       display_name: Read requests
       metric_kind: DELTA
       value_type: INT64

     - name: library.googleapis.com/write_calls
       display_name: Write requests
       metric_kind: DELTA
       value_type: INT64



Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->limits() >> / C<< $msg->limits($value) >>

Type: C<Message> (L<Google::Api::Quota::QuotaLimit>)

List of QuotaLimit definitions for the service.

=item * C<< $msg->metric_rules() >> / C<< $msg->metric_rules($value) >>

Type: C<Message> (L<Google::Api::Quota::MetricRule>)

List of MetricRule definitions, each one mapping a selected method to one
or more metrics.

=back

=head2 Google::Api::Quota::MetricRule

Bind API methods to metrics. Binding a method to a metric causes that
metric's configured quota behaviors to apply to the method call.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->selector() >> / C<< $msg->selector($value) >>

Type: C<String>

Selects the methods to which this rule applies.

Refer to [selector][google.api.DocumentationRule.selector] for syntax
details.

=item * C<< $msg->metric_costs() >> / C<< $msg->metric_costs($value) >>

Type: C<Message> (L<Google::Api::Quota::MetricRule::MetricCostsEntry>)

Metrics to update when the selected methods are called, and the associated
cost applied to each metric.

The key of the map is the metric name, and the values are the amount
increased for the metric against which the quota limits are defined.
The value must not be negative.

=back

=head2 Google::Api::Quota::QuotaLimit

`QuotaLimit` defines a specific limit that applies over a specified duration
for a limit type. There can be at most one limit for a duration and limit
type combination defined within a `QuotaGroup`.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->name() >> / C<< $msg->name($value) >>

Type: C<String>

Name of the quota limit.

The name must be provided, and it must be unique within the service. The
name can only include alphanumeric characters as well as '-'.

The maximum length of the limit name is 64 characters.

=item * C<< $msg->description() >> / C<< $msg->description($value) >>

Type: C<String>

Optional. User-visible, extended description for this quota limit.
Should be used only when more context is needed to understand this limit
than provided by the limit's display name (see: `display_name`).

=item * C<< $msg->default_limit() >> / C<< $msg->default_limit($value) >>

Type: C<Int64>

Default number of tokens that can be consumed during the specified
duration. This is the number of tokens assigned when a client
application developer activates the service for his/her project.

Specifying a value of 0 will block all requests. This can be used if you
are provisioning quota to selected consumers and blocking others.
Similarly, a value of -1 will indicate an unlimited quota. No other
negative values are allowed.

Used by group-based quotas only.

=item * C<< $msg->max_limit() >> / C<< $msg->max_limit($value) >>

Type: C<Int64>

Maximum number of tokens that can be consumed during the specified
duration. Client application developers can override the default limit up
to this maximum. If specified, this value cannot be set to a value less
than the default limit. If not specified, it is set to the default limit.

To allow clients to apply overrides with no upper bound, set this to -1,
indicating unlimited maximum quota.

Used by group-based quotas only.

=item * C<< $msg->free_tier() >> / C<< $msg->free_tier($value) >>

Type: C<Int64>

Free tier value displayed in the Developers Console for this limit.
The free tier is the number of tokens that will be subtracted from the
billed amount when billing is enabled.
This field can only be set on a limit with duration "1d", in a billable
group; it is invalid on any other limit. If this field is not set, it
defaults to 0, indicating that there is no free tier for this service.

Used by group-based quotas only.

=item * C<< $msg->duration() >> / C<< $msg->duration($value) >>

Type: C<String>

Duration of this limit in textual notation. Must be "100s" or "1d".

Used by group-based quotas only.

=item * C<< $msg->metric() >> / C<< $msg->metric($value) >>

Type: C<String>

The name of the metric this quota limit applies to. The quota limits with
the same metric will be checked together during runtime. The metric must be
defined within the service config.

=item * C<< $msg->unit() >> / C<< $msg->unit($value) >>

Type: C<String>

Specify the unit of the quota limit. It uses the same syntax as
[MetricDescriptor.unit][google.api.MetricDescriptor.unit]. The supported
unit kinds are determined by the quota backend system.

Here are some examples:
* "1/min/{project}" for quota per minute per project.

Note: the order of unit components is insignificant.
The "1" at the beginning is required to follow the metric unit syntax.

=item * C<< $msg->values() >> / C<< $msg->values($value) >>

Type: C<Message> (L<Google::Api::Quota::QuotaLimit::ValuesEntry>)

Tiered limit values. You must specify this as a key:value pair, with an
integer value that is the maximum number of requests allowed for the
specified unit. Currently only STANDARD is supported.

=item * C<< $msg->display_name() >> / C<< $msg->display_name($value) >>

Type: C<String>

User-visible display name for this limit.
Optional. If not set, the UI will provide a default display name based on
the quota configuration. This field can be used to override the default
display name generated from the configuration.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Quota::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

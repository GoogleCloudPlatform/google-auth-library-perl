package Google::Rpc::ErrorDetails;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    eval { require Google::Protobuf::Duration };
    my $descriptor_b64 = <<'EOF';
Ch5nb29nbGUvcnBjL2Vycm9yX2RldGFpbHMucHJvdG8SCmdvb2dsZS5ycGMaHmdvb2dsZS9w
cm90b2J1Zi9kdXJhdGlvbi5wcm90byK5AQoJRXJyb3JJbmZvEhYKBnJlYXNvbhgBIAEoCVIG
cmVhc29uEhYKBmRvbWFpbhgCIAEoCVIGZG9tYWluEj8KCG1ldGFkYXRhGAMgAygLMiMuZ29v
Z2xlLnJwYy5FcnJvckluZm8uTWV0YWRhdGFFbnRyeVIIbWV0YWRhdGEaOwoNTWV0YWRhdGFF
bnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgBIkcKCVJl
dHJ5SW5mbxI6CgtyZXRyeV9kZWxheRgBIAEoCzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlv
blIKcmV0cnlEZWxheSJICglEZWJ1Z0luZm8SIwoNc3RhY2tfZW50cmllcxgBIAMoCVIMc3Rh
Y2tFbnRyaWVzEhYKBmRldGFpbBgCIAEoCVIGZGV0YWlsIo4ECgxRdW90YUZhaWx1cmUSQgoK
dmlvbGF0aW9ucxgBIAMoCzIiLmdvb2dsZS5ycGMuUXVvdGFGYWlsdXJlLlZpb2xhdGlvblIK
dmlvbGF0aW9ucxq5AwoJVmlvbGF0aW9uEhgKB3N1YmplY3QYASABKAlSB3N1YmplY3QSIAoL
ZGVzY3JpcHRpb24YAiABKAlSC2Rlc2NyaXB0aW9uEh8KC2FwaV9zZXJ2aWNlGAMgASgJUgph
cGlTZXJ2aWNlEiEKDHF1b3RhX21ldHJpYxgEIAEoCVILcXVvdGFNZXRyaWMSGQoIcXVvdGFf
aWQYBSABKAlSB3F1b3RhSWQSYgoQcXVvdGFfZGltZW5zaW9ucxgGIAMoCzI3Lmdvb2dsZS5y
cGMuUXVvdGFGYWlsdXJlLlZpb2xhdGlvbi5RdW90YURpbWVuc2lvbnNFbnRyeVIPcXVvdGFE
aW1lbnNpb25zEh8KC3F1b3RhX3ZhbHVlGAcgASgDUgpxdW90YVZhbHVlEjEKEmZ1dHVyZV9x
dW90YV92YWx1ZRgIIAEoA0gAUhBmdXR1cmVRdW90YVZhbHVliAEBGkIKFFF1b3RhRGltZW5z
aW9uc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAFC
FQoTX2Z1dHVyZV9xdW90YV92YWx1ZSK9AQoTUHJlY29uZGl0aW9uRmFpbHVyZRJJCgp2aW9s
YXRpb25zGAEgAygLMikuZ29vZ2xlLnJwYy5QcmVjb25kaXRpb25GYWlsdXJlLlZpb2xhdGlv
blIKdmlvbGF0aW9ucxpbCglWaW9sYXRpb24SEgoEdHlwZRgBIAEoCVIEdHlwZRIYCgdzdWJq
ZWN0GAIgASgJUgdzdWJqZWN0EiAKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbiKM
AgoKQmFkUmVxdWVzdBJQChBmaWVsZF92aW9sYXRpb25zGAEgAygLMiUuZ29vZ2xlLnJwYy5C
YWRSZXF1ZXN0LkZpZWxkVmlvbGF0aW9uUg9maWVsZFZpb2xhdGlvbnMaqwEKDkZpZWxkVmlv
bGF0aW9uEhQKBWZpZWxkGAEgASgJUgVmaWVsZBIgCgtkZXNjcmlwdGlvbhgCIAEoCVILZGVz
Y3JpcHRpb24SFgoGcmVhc29uGAMgASgJUgZyZWFzb24SSQoRbG9jYWxpemVkX21lc3NhZ2UY
BCABKAsyHC5nb29nbGUucnBjLkxvY2FsaXplZE1lc3NhZ2VSEGxvY2FsaXplZE1lc3NhZ2Ui
TwoLUmVxdWVzdEluZm8SHQoKcmVxdWVzdF9pZBgBIAEoCVIJcmVxdWVzdElkEiEKDHNlcnZp
bmdfZGF0YRgCIAEoCVILc2VydmluZ0RhdGEikAEKDFJlc291cmNlSW5mbxIjCg1yZXNvdXJj
ZV90eXBlGAEgASgJUgxyZXNvdXJjZVR5cGUSIwoNcmVzb3VyY2VfbmFtZRgCIAEoCVIMcmVz
b3VyY2VOYW1lEhQKBW93bmVyGAMgASgJUgVvd25lchIgCgtkZXNjcmlwdGlvbhgEIAEoCVIL
ZGVzY3JpcHRpb24ibwoESGVscBIrCgVsaW5rcxgBIAMoCzIVLmdvb2dsZS5ycGMuSGVscC5M
aW5rUgVsaW5rcxo6CgRMaW5rEiAKC2Rlc2NyaXB0aW9uGAEgASgJUgtkZXNjcmlwdGlvbhIQ
CgN1cmwYAiABKAlSA3VybCJEChBMb2NhbGl6ZWRNZXNzYWdlEhYKBmxvY2FsZRgBIAEoCVIG
bG9jYWxlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2VCbAoOY29tLmdvb2dsZS5ycGNCEUVy
cm9yRGV0YWlsc1Byb3RvUAFaP2dvb2dsZS5nb2xhbmcub3JnL2dlbnByb3RvL2dvb2dsZWFw
aXMvcnBjL2VycmRldGFpbHM7ZXJyZGV0YWlsc6ICA1JQQ0qHcwoHEgUOAOoCAQq8BAoBDBID
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
dGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS4KCggKAQISAxAAEwoJCgIDABIDEgAoCggKAQgS
AxQAVgoJCgIICxIDFABWCggKAQgSAxUAIgoJCgIIChIDFQAiCggKAQgSAxYAMgoJCgIICBID
FgAyCggKAQgSAxcAJwoJCgIIARIDFwAnCggKAQgSAxgAIQoJCgIIJBIDGAAhCsUFCgIEABIE
MgBMARq4BSBEZXNjcmliZXMgdGhlIGNhdXNlIG9mIHRoZSBlcnJvciB3aXRoIHN0cnVjdHVy
ZWQgZGV0YWlscy4KCiBFeGFtcGxlIG9mIGFuIGVycm9yIHdoZW4gY29udGFjdGluZyB0aGUg
InB1YnN1Yi5nb29nbGVhcGlzLmNvbSIgQVBJIHdoZW4gaXQKIGlzIG5vdCBlbmFibGVkOgoK
ICAgICB7ICJyZWFzb24iOiAiQVBJX0RJU0FCTEVEIgogICAgICAgImRvbWFpbiI6ICJnb29n
bGVhcGlzLmNvbSIKICAgICAgICJtZXRhZGF0YSI6IHsKICAgICAgICAgInJlc291cmNlIjog
InByb2plY3RzLzEyMyIsCiAgICAgICAgICJzZXJ2aWNlIjogInB1YnN1Yi5nb29nbGVhcGlz
LmNvbSIKICAgICAgIH0KICAgICB9CgogVGhpcyByZXNwb25zZSBpbmRpY2F0ZXMgdGhhdCB0
aGUgcHVic3ViLmdvb2dsZWFwaXMuY29tIEFQSSBpcyBub3QgZW5hYmxlZC4KCiBFeGFtcGxl
IG9mIGFuIGVycm9yIHRoYXQgaXMgcmV0dXJuZWQgd2hlbiBhdHRlbXB0aW5nIHRvIGNyZWF0
ZSBhIFNwYW5uZXIKIGluc3RhbmNlIGluIGEgcmVnaW9uIHRoYXQgaXMgb3V0IG9mIHN0b2Nr
OgoKICAgICB7ICJyZWFzb24iOiAiU1RPQ0tPVVQiCiAgICAgICAiZG9tYWluIjogInNwYW5u
ZXIuZ29vZ2xlYXBpcy5jb20iLAogICAgICAgIm1ldGFkYXRhIjogewogICAgICAgICAiYXZh
aWxhYmxlUmVnaW9ucyI6ICJ1cy1jZW50cmFsMSx1cy1lYXN0MiIKICAgICAgIH0KICAgICB9
CgoKCgMEAAESAzIIEQq7AgoEBAACABIDOAIUGq0CIFRoZSByZWFzb24gb2YgdGhlIGVycm9y
LiBUaGlzIGlzIGEgY29uc3RhbnQgdmFsdWUgdGhhdCBpZGVudGlmaWVzIHRoZQogcHJveGlt
YXRlIGNhdXNlIG9mIHRoZSBlcnJvci4gRXJyb3IgcmVhc29ucyBhcmUgdW5pcXVlIHdpdGhp
biBhIHBhcnRpY3VsYXIKIGRvbWFpbiBvZiBlcnJvcnMuIFRoaXMgc2hvdWxkIGJlIGF0IG1v
c3QgNjMgY2hhcmFjdGVycyBhbmQgbWF0Y2ggYQogcmVndWxhciBleHByZXNzaW9uIG9mIGBb
QS1aXVtBLVowLTlfXStbQS1aMC05XWAsIHdoaWNoIHJlcHJlc2VudHMKIFVQUEVSX1NOQUtF
X0NBU0UuCgoMCgUEAAIABRIDOAIICgwKBQQAAgABEgM4CQ8KDAoFBAACAAMSAzgSEwqoAwoE
BAACARIDQAIUGpoDIFRoZSBsb2dpY2FsIGdyb3VwaW5nIHRvIHdoaWNoIHRoZSAicmVhc29u
IiBiZWxvbmdzLiBUaGUgZXJyb3IgZG9tYWluCiBpcyB0eXBpY2FsbHkgdGhlIHJlZ2lzdGVy
ZWQgc2VydmljZSBuYW1lIG9mIHRoZSB0b29sIG9yIHByb2R1Y3QgdGhhdAogZ2VuZXJhdGVz
IHRoZSBlcnJvci4gRXhhbXBsZTogInB1YnN1Yi5nb29nbGVhcGlzLmNvbSIuIElmIHRoZSBl
cnJvciBpcwogZ2VuZXJhdGVkIGJ5IHNvbWUgY29tbW9uIGluZnJhc3RydWN0dXJlLCB0aGUg
ZXJyb3IgZG9tYWluIG11c3QgYmUgYQogZ2xvYmFsbHkgdW5pcXVlIHZhbHVlIHRoYXQgaWRl
bnRpZmllcyB0aGUgaW5mcmFzdHJ1Y3R1cmUuIEZvciBHb29nbGUgQVBJCiBpbmZyYXN0cnVj
dHVyZSwgdGhlIGVycm9yIGRvbWFpbiBpcyAiZ29vZ2xlYXBpcy5jb20iLgoKDAoFBAACAQUS
A0ACCAoMCgUEAAIBARIDQAkPCgwKBQQAAgEDEgNAEhMKrgQKBAQAAgISA0sCIxqgBCBBZGRp
dGlvbmFsIHN0cnVjdHVyZWQgZGV0YWlscyBhYm91dCB0aGlzIGVycm9yLgoKIEtleXMgbXVz
dCBtYXRjaCBhIHJlZ3VsYXIgZXhwcmVzc2lvbiBvZiBgW2Etel1bYS16QS1aMC05LV9dK2Ag
YnV0IHNob3VsZAogaWRlYWxseSBiZSBsb3dlckNhbWVsQ2FzZS4gQWxzbywgdGhleSBtdXN0
IGJlIGxpbWl0ZWQgdG8gNjQgY2hhcmFjdGVycyBpbgogbGVuZ3RoLiBXaGVuIGlkZW50aWZ5
aW5nIHRoZSBjdXJyZW50IHZhbHVlIG9mIGFuIGV4Y2VlZGVkIGxpbWl0LCB0aGUgdW5pdHMK
IHNob3VsZCBiZSBjb250YWluZWQgaW4gdGhlIGtleSwgbm90IHRoZSB2YWx1ZS4gIEZvciBl
eGFtcGxlLCByYXRoZXIgdGhhbgogYHsiaW5zdGFuY2VMaW1pdCI6ICIxMDAvcmVxdWVzdCJ9
YCwgc2hvdWxkIGJlIHJldHVybmVkIGFzLAogYHsiaW5zdGFuY2VMaW1pdFBlclJlcXVlc3Qi
OiAiMTAwIn1gLCBpZiB0aGUgY2xpZW50IGV4Y2VlZHMgdGhlIG51bWJlciBvZgogaW5zdGFu
Y2VzIHRoYXQgY2FuIGJlIGNyZWF0ZWQgaW4gYSBzaW5nbGUgKGJhdGNoKSByZXF1ZXN0LgoK
DAoFBAACAgYSA0sCFQoMCgUEAAICARIDSxYeCgwKBQQAAgIDEgNLISIKiwUKAgQBEgRbAF4B
Gv4EIERlc2NyaWJlcyB3aGVuIHRoZSBjbGllbnRzIGNhbiByZXRyeSBhIGZhaWxlZCByZXF1
ZXN0LiBDbGllbnRzIGNvdWxkIGlnbm9yZQogdGhlIHJlY29tbWVuZGF0aW9uIGhlcmUgb3Ig
cmV0cnkgd2hlbiB0aGlzIGluZm9ybWF0aW9uIGlzIG1pc3NpbmcgZnJvbSBlcnJvcgogcmVz
cG9uc2VzLgoKIEl0J3MgYWx3YXlzIHJlY29tbWVuZGVkIHRoYXQgY2xpZW50cyBzaG91bGQg
dXNlIGV4cG9uZW50aWFsIGJhY2tvZmYgd2hlbgogcmV0cnlpbmcuCgogQ2xpZW50cyBzaG91
bGQgd2FpdCB1bnRpbCBgcmV0cnlfZGVsYXlgIGFtb3VudCBvZiB0aW1lIGhhcyBwYXNzZWQg
c2luY2UKIHJlY2VpdmluZyB0aGUgZXJyb3IgcmVzcG9uc2UgYmVmb3JlIHJldHJ5aW5nLiAg
SWYgcmV0cnlpbmcgcmVxdWVzdHMgYWxzbwogZmFpbCwgY2xpZW50cyBzaG91bGQgdXNlIGFu
IGV4cG9uZW50aWFsIGJhY2tvZmYgc2NoZW1lIHRvIGdyYWR1YWxseSBpbmNyZWFzZQogdGhl
IGRlbGF5IGJldHdlZW4gcmV0cmllcyBiYXNlZCBvbiBgcmV0cnlfZGVsYXlgLCB1bnRpbCBl
aXRoZXIgYSBtYXhpbXVtCiBudW1iZXIgb2YgcmV0cmllcyBoYXZlIGJlZW4gcmVhY2hlZCBv
ciBhIG1heGltdW0gcmV0cnkgZGVsYXkgY2FwIGhhcyBiZWVuCiByZWFjaGVkLgoKCgoDBAEB
EgNbCBEKWAoEBAECABIDXQIrGksgQ2xpZW50cyBzaG91bGQgd2FpdCBhdCBsZWFzdCB0aGlz
IGxvbmcgYmV0d2VlbiByZXRyeWluZyB0aGUgc2FtZSByZXF1ZXN0LgoKDAoFBAECAAYSA10C
GgoMCgUEAQIAARIDXRsmCgwKBQQBAgADEgNdKSoKMgoCBAISBGEAZwEaJiBEZXNjcmliZXMg
YWRkaXRpb25hbCBkZWJ1Z2dpbmcgaW5mby4KCgoKAwQCARIDYQgRCksKBAQCAgASA2MCJBo+
IFRoZSBzdGFjayB0cmFjZSBlbnRyaWVzIGluZGljYXRpbmcgd2hlcmUgdGhlIGVycm9yIG9j
Y3VycmVkLgoKDAoFBAICAAQSA2MCCgoMCgUEAgIABRIDYwsRCgwKBQQCAgABEgNjEh8KDAoF
BAICAAMSA2MiIwpHCgQEAgIBEgNmAhQaOiBBZGRpdGlvbmFsIGRlYnVnZ2luZyBpbmZvcm1h
dGlvbiBwcm92aWRlZCBieSB0aGUgc2VydmVyLgoKDAoFBAICAQUSA2YCCAoMCgUEAgIBARID
ZgkPCgwKBQQCAgEDEgNmEhMK/QMKAgQDEgV0AMoBARrvAyBEZXNjcmliZXMgaG93IGEgcXVv
dGEgY2hlY2sgZmFpbGVkLgoKIEZvciBleGFtcGxlIGlmIGEgZGFpbHkgbGltaXQgd2FzIGV4
Y2VlZGVkIGZvciB0aGUgY2FsbGluZyBwcm9qZWN0LAogYSBzZXJ2aWNlIGNvdWxkIHJlc3Bv
bmQgd2l0aCBhIFF1b3RhRmFpbHVyZSBkZXRhaWwgY29udGFpbmluZyB0aGUgcHJvamVjdAog
aWQgYW5kIHRoZSBkZXNjcmlwdGlvbiBvZiB0aGUgcXVvdGEgbGltaXQgdGhhdCB3YXMgZXhj
ZWVkZWQuICBJZiB0aGUKIGNhbGxpbmcgcHJvamVjdCBoYXNuJ3QgZW5hYmxlZCB0aGUgc2Vy
dmljZSBpbiB0aGUgZGV2ZWxvcGVyIGNvbnNvbGUsIHRoZW4KIGEgc2VydmljZSBjb3VsZCBy
ZXNwb25kIHdpdGggdGhlIHByb2plY3QgaWQgYW5kIHNldCBgc2VydmljZV9kaXNhYmxlZGAK
IHRvIHRydWUuCgogQWxzbyBzZWUgUmV0cnlJbmZvIGFuZCBIZWxwIHR5cGVzIGZvciBvdGhl
ciBkZXRhaWxzIGFib3V0IGhhbmRsaW5nIGEKIHF1b3RhIGZhaWx1cmUuCgoKCgMEAwESA3QI
FAqMAQoEBAMDABIFdwLGAQMafSBBIG1lc3NhZ2UgdHlwZSB1c2VkIHRvIGRlc2NyaWJlIGEg
c2luZ2xlIHF1b3RhIHZpb2xhdGlvbi4gIEZvciBleGFtcGxlLCBhCiBkYWlseSBxdW90YSBv
ciBhIGN1c3RvbSBxdW90YSB0aGF0IHdhcyBleGNlZWRlZC4KCgwKBQQDAwABEgN3ChMKmwEK
BgQDAwACABIDewQXGosBIFRoZSBzdWJqZWN0IG9uIHdoaWNoIHRoZSBxdW90YSBjaGVjayBm
YWlsZWQuCiBGb3IgZXhhbXBsZSwgImNsaWVudGlwOjxpcCBhZGRyZXNzIG9mIGNsaWVudD4i
IG9yICJwcm9qZWN0OjxHb29nbGUKIGRldmVsb3BlciBwcm9qZWN0IGlkPiIuCgoOCgcEAwMA
AgAFEgN7BAoKDgoHBAMDAAIAARIDewsSCg4KBwQDAwACAAMSA3sVFgrNAgoGBAMDAAIBEgSE
AQQbGrwCIEEgZGVzY3JpcHRpb24gb2YgaG93IHRoZSBxdW90YSBjaGVjayBmYWlsZWQuIENs
aWVudHMgY2FuIHVzZSB0aGlzCiBkZXNjcmlwdGlvbiB0byBmaW5kIG1vcmUgYWJvdXQgdGhl
IHF1b3RhIGNvbmZpZ3VyYXRpb24gaW4gdGhlIHNlcnZpY2UncwogcHVibGljIGRvY3VtZW50
YXRpb24sIG9yIGZpbmQgdGhlIHJlbGV2YW50IHF1b3RhIGxpbWl0IHRvIGFkanVzdCB0aHJv
dWdoCiBkZXZlbG9wZXIgY29uc29sZS4KCiBGb3IgZXhhbXBsZTogIlNlcnZpY2UgZGlzYWJs
ZWQiIG9yICJEYWlseSBMaW1pdCBmb3IgcmVhZCBvcGVyYXRpb25zCiBleGNlZWRlZCIuCgoP
CgcEAwMAAgEFEgSEAQQKCg8KBwQDAwACAQESBIQBCxYKDwoHBAMDAAIBAxIEhAEZGgrfBQoG
BAMDAAICEgSTAQQbGs4FIFRoZSBBUEkgU2VydmljZSBmcm9tIHdoaWNoIHRoZSBgUXVvdGFG
YWlsdXJlLlZpb2xhdGlvbmAgb3JnaW5hdGVzLiBJbgogc29tZSBjYXNlcywgUXVvdGEgaXNz
dWVzIG9yaWdpbmF0ZSBmcm9tIGFuIEFQSSBTZXJ2aWNlIG90aGVyIHRoYW4gdGhlIG9uZQog
dGhhdCB3YXMgY2FsbGVkLiBJbiBvdGhlciB3b3JkcywgYSBkZXBlbmRlbmN5IG9mIHRoZSBj
YWxsZWQgQVBJIFNlcnZpY2UKIGNvdWxkIGJlIHRoZSBjYXVzZSBvZiB0aGUgYFF1b3RhRmFp
bHVyZWAsIGFuZCB0aGlzIGZpZWxkIHdvdWxkIGhhdmUgdGhlCiBkZXBlbmRlbmN5IEFQSSBz
ZXJ2aWNlIG5hbWUuCgogRm9yIGV4YW1wbGUsIGlmIHRoZSBjYWxsZWQgQVBJIGlzIEt1YmVy
bmV0ZXMgRW5naW5lIEFQSQogKGNvbnRhaW5lci5nb29nbGVhcGlzLmNvbSksIGFuZCBhIHF1
b3RhIHZpb2xhdGlvbiBvY2N1cnMgaW4gdGhlCiBLdWJlcm5ldGVzIEVuZ2luZSBBUEkgaXRz
ZWxmLCB0aGlzIGZpZWxkIHdvdWxkIGJlCiAiY29udGFpbmVyLmdvb2dsZWFwaXMuY29tIi4g
T24gdGhlIG90aGVyIGhhbmQsIGlmIHRoZSBxdW90YSB2aW9sYXRpb24KIG9jY3VycyB3aGVu
IHRoZSBLdWJlcm5ldGVzIEVuZ2luZSBBUEkgY3JlYXRlcyBWTXMgaW4gdGhlIENvbXB1dGUg
RW5naW5lCiBBUEkgKGNvbXB1dGUuZ29vZ2xlYXBpcy5jb20pLCB0aGlzIGZpZWxkIHdvdWxk
IGJlCiAiY29tcHV0ZS5nb29nbGVhcGlzLmNvbSIuCgoPCgcEAwMAAgIFEgSTAQQKCg8KBwQD
AwACAgESBJMBCxYKDwoHBAMDAAICAxIEkwEZGgrvAgoGBAMDAAIDEgScAQQcGt4CIFRoZSBt
ZXRyaWMgb2YgdGhlIHZpb2xhdGVkIHF1b3RhLiBBIHF1b3RhIG1ldHJpYyBpcyBhIG5hbWVk
IGNvdW50ZXIgdG8KIG1lYXN1cmUgdXNhZ2UsIHN1Y2ggYXMgQVBJIHJlcXVlc3RzIG9yIENQ
VXMuIFdoZW4gYW4gYWN0aXZpdHkgb2NjdXJzIGluIGEKIHNlcnZpY2UsIHN1Y2ggYXMgVmly
dHVhbCBNYWNoaW5lIGFsbG9jYXRpb24sIG9uZSBvciBtb3JlIHF1b3RhIG1ldHJpY3MKIG1h
eSBiZSBhZmZlY3RlZC4KCiBGb3IgZXhhbXBsZSwgImNvbXB1dGUuZ29vZ2xlYXBpcy5jb20v
Y3B1c19wZXJfdm1fZmFtaWx5IiwKICJzdG9yYWdlLmdvb2dsZWFwaXMuY29tL2ludGVybmV0
X2VncmVzc19iYW5kd2lkdGgiLgoKDwoHBAMDAAIDBRIEnAEECgoPCgcEAwMAAgMBEgScAQsX
Cg8KBwQDAwACAwMSBJwBGhsKzwEKBgQDAwACBBIEogEEGBq+ASBUaGUgaWQgb2YgdGhlIHZp
b2xhdGVkIHF1b3RhLiBBbHNvIGtub3cgYXMgImxpbWl0IG5hbWUiLCB0aGlzIGlzIHRoZQog
dW5pcXVlIGlkZW50aWZpZXIgb2YgYSBxdW90YSBpbiB0aGUgY29udGV4dCBvZiBhbiBBUEkg
c2VydmljZS4KCiBGb3IgZXhhbXBsZSwgIkNQVVMtUEVSLVZNLUZBTUlMWS1wZXItcHJvamVj
dC1yZWdpb24iLgoKDwoHBAMDAAIEBRIEogEECgoPCgcEAwMAAgQBEgSiAQsTCg8KBwQDAwAC
BAMSBKIBFhcKjwUKBgQDAwACBRIEtAEELRr+BCBUaGUgZGltZW5zaW9ucyBvZiB0aGUgdmlv
bGF0ZWQgcXVvdGEuIEV2ZXJ5IG5vbi1nbG9iYWwgcXVvdGEgaXMgZW5mb3JjZWQKIG9uIGEg
c2V0IG9mIGRpbWVuc2lvbnMuIFdoaWxlIHF1b3RhIG1ldHJpYyBkZWZpbmVzIHdoYXQgdG8g
Y291bnQsIHRoZQogZGltZW5zaW9ucyBzcGVjaWZ5IGZvciB3aGF0IGFzcGVjdHMgdGhlIGNv
dW50ZXIgc2hvdWxkIGJlIGluY3JlYXNlZC4KCiBGb3IgZXhhbXBsZSwgdGhlIHF1b3RhICJD
UFVzIHBlciByZWdpb24gcGVyIFZNIGZhbWlseSIgZW5mb3JjZXMgYSBsaW1pdAogb24gdGhl
IG1ldHJpYyAiY29tcHV0ZS5nb29nbGVhcGlzLmNvbS9jcHVzX3Blcl92bV9mYW1pbHkiIG9u
IGRpbWVuc2lvbnMKICJyZWdpb24iIGFuZCAidm1fZmFtaWx5Ii4gQW5kIGlmIHRoZSB2aW9s
YXRpb24gb2NjdXJyZWQgaW4gcmVnaW9uCiAidXMtY2VudHJhbDEiIGFuZCBmb3IgVk0gZmFt
aWx5ICJuMSIsIHRoZSBxdW90YV9kaW1lbnNpb25zIHdvdWxkIGJlLAoKIHsKICAgInJlZ2lv
biI6ICJ1cy1jZW50cmFsMSIsCiAgICJ2bV9mYW1pbHkiOiAibjEiLAogfQoKIFdoZW4gYSBx
dW90YSBpcyBlbmZvcmNlZCBnbG9iYWxseSwgdGhlIHF1b3RhX2RpbWVuc2lvbnMgd291bGQg
YWx3YXlzIGJlCiBlbXB0eS4KCg8KBwQDAwACBQYSBLQBBBcKDwoHBAMDAAIFARIEtAEYKAoP
CgcEAwMAAgUDEgS0ASssCvYBCgYEAwMAAgYSBLsBBBoa5QEgVGhlIGVuZm9yY2VkIHF1b3Rh
IHZhbHVlIGF0IHRoZSB0aW1lIG9mIHRoZSBgUXVvdGFGYWlsdXJlYC4KCiBGb3IgZXhhbXBs
ZSwgaWYgdGhlIGVuZm9yY2VkIHF1b3RhIHZhbHVlIGF0IHRoZSB0aW1lIG9mIHRoZQogYFF1
b3RhRmFpbHVyZWAgb24gdGhlIG51bWJlciBvZiBDUFVzIGlzICIxMCIsIHRoZW4gdGhlIHZh
bHVlIG9mIHRoaXMKIGZpZWxkIHdvdWxkIHJlZmxlY3QgdGhpcyBxdWFudGl0eS4KCg8KBwQD
AwACBgUSBLsBBAkKDwoHBAMDAAIGARIEuwEKFQoPCgcEAwMAAgYDEgS7ARgZCqEDCgYEAwMA
AgcSBMUBBCoakAMgVGhlIG5ldyBxdW90YSB2YWx1ZSBiZWluZyByb2xsZWQgb3V0IGF0IHRo
ZSB0aW1lIG9mIHRoZSB2aW9sYXRpb24uIEF0IHRoZQogY29tcGxldGlvbiBvZiB0aGUgcm9s
bG91dCwgdGhpcyB2YWx1ZSB3aWxsIGJlIGVuZm9yY2VkIGluIHBsYWNlIG9mCiBxdW90YV92
YWx1ZS4gSWYgbm8gcm9sbG91dCBpcyBpbiBwcm9ncmVzcyBhdCB0aGUgdGltZSBvZiB0aGUg
dmlvbGF0aW9uLAogdGhpcyBmaWVsZCBpcyBub3Qgc2V0LgoKIEZvciBleGFtcGxlLCBpZiBh
dCB0aGUgdGltZSBvZiB0aGUgdmlvbGF0aW9uIGEgcm9sbG91dCBpcyBpbiBwcm9ncmVzcwog
Y2hhbmdpbmcgdGhlIG51bWJlciBvZiBDUFVzIHF1b3RhIGZyb20gMTAgdG8gMjAsIDIwIHdv
dWxkIGJlIHRoZSB2YWx1ZSBvZgogdGhpcyBmaWVsZC4KCg8KBwQDAwACBwQSBMUBBAwKDwoH
BAMDAAIHBRIExQENEgoPCgcEAwMAAgcBEgTFARMlCg8KBwQDAwACBwMSBMUBKCkKLwoEBAMC
ABIEyQECJBohIERlc2NyaWJlcyBhbGwgcXVvdGEgdmlvbGF0aW9ucy4KCg0KBQQDAgAEEgTJ
AQIKCg0KBQQDAgAGEgTJAQsUCg0KBQQDAgABEgTJARUfCg0KBQQDAgADEgTJASIjCuoBCgIE
BBIG0QEA5wEBGtsBIERlc2NyaWJlcyB3aGF0IHByZWNvbmRpdGlvbnMgaGF2ZSBmYWlsZWQu
CgogRm9yIGV4YW1wbGUsIGlmIGFuIFJQQyBmYWlsZWQgYmVjYXVzZSBpdCByZXF1aXJlZCB0
aGUgVGVybXMgb2YgU2VydmljZSB0byBiZQogYWNrbm93bGVkZ2VkLCBpdCBjb3VsZCBsaXN0
IHRoZSB0ZXJtcyBvZiBzZXJ2aWNlIHZpb2xhdGlvbiBpbiB0aGUKIFByZWNvbmRpdGlvbkZh
aWx1cmUgbWVzc2FnZS4KCgsKAwQEARIE0QEIGwpQCgQEBAMAEgbTAQLjAQMaQCBBIG1lc3Nh
Z2UgdHlwZSB1c2VkIHRvIGRlc2NyaWJlIGEgc2luZ2xlIHByZWNvbmRpdGlvbiBmYWlsdXJl
LgoKDQoFBAQDAAESBNMBChMK0wEKBgQEAwACABIE1wEEFBrCASBUaGUgdHlwZSBvZiBQcmVj
b25kaXRpb25GYWlsdXJlLiBXZSByZWNvbW1lbmQgdXNpbmcgYSBzZXJ2aWNlLXNwZWNpZmlj
CiBlbnVtIHR5cGUgdG8gZGVmaW5lIHRoZSBzdXBwb3J0ZWQgcHJlY29uZGl0aW9uIHZpb2xh
dGlvbiBzdWJqZWN0cy4gRm9yCiBleGFtcGxlLCAiVE9TIiBmb3IgIlRlcm1zIG9mIFNlcnZp
Y2UgdmlvbGF0aW9uIi4KCg8KBwQEAwACAAUSBNcBBAoKDwoHBAQDAAIAARIE1wELDwoPCgcE
BAMAAgADEgTXARITCroBCgYEBAMAAgESBNwBBBcaqQEgVGhlIHN1YmplY3QsIHJlbGF0aXZl
IHRvIHRoZSB0eXBlLCB0aGF0IGZhaWxlZC4KIEZvciBleGFtcGxlLCAiZ29vZ2xlLmNvbS9j
bG91ZCIgcmVsYXRpdmUgdG8gdGhlICJUT1MiIHR5cGUgd291bGQgaW5kaWNhdGUKIHdoaWNo
IHRlcm1zIG9mIHNlcnZpY2UgaXMgYmVpbmcgcmVmZXJlbmNlZC4KCg8KBwQEAwACAQUSBNwB
BAoKDwoHBAQDAAIBARIE3AELEgoPCgcEBAMAAgEDEgTcARUWCrsBCgYEBAMAAgISBOIBBBsa
qgEgQSBkZXNjcmlwdGlvbiBvZiBob3cgdGhlIHByZWNvbmRpdGlvbiBmYWlsZWQuIERldmVs
b3BlcnMgY2FuIHVzZSB0aGlzCiBkZXNjcmlwdGlvbiB0byB1bmRlcnN0YW5kIGhvdyB0byBm
aXggdGhlIGZhaWx1cmUuCgogRm9yIGV4YW1wbGU6ICJUZXJtcyBvZiBzZXJ2aWNlIG5vdCBh
Y2NlcHRlZCIuCgoPCgcEBAMAAgIFEgTiAQQKCg8KBwQEAwACAgESBOIBCxYKDwoHBAQDAAIC
AxIE4gEZGgo2CgQEBAIAEgTmAQIkGiggRGVzY3JpYmVzIGFsbCBwcmVjb25kaXRpb24gdmlv
bGF0aW9ucy4KCg0KBQQEAgAEEgTmAQIKCg0KBQQEAgAGEgTmAQsUCg0KBQQEAgABEgTmARUf
Cg0KBQQEAgADEgTmASIjCnsKAgQFEgbrAQCnAgEabSBEZXNjcmliZXMgdmlvbGF0aW9ucyBp
biBhIGNsaWVudCByZXF1ZXN0LiBUaGlzIGVycm9yIHR5cGUgZm9jdXNlcyBvbiB0aGUKIHN5
bnRhY3RpYyBhc3BlY3RzIG9mIHRoZSByZXF1ZXN0LgoKCwoDBAUBEgTrAQgSCk0KBAQFAwAS
Bu0BAqMCAxo9IEEgbWVzc2FnZSB0eXBlIHVzZWQgdG8gZGVzY3JpYmUgYSBzaW5nbGUgYmFk
IHJlcXVlc3QgZmllbGQuCgoNCgUEBQMAARIE7QEKGArHCQoGBAUDAAIAEgSTAgQVGrYJIEEg
cGF0aCB0aGF0IGxlYWRzIHRvIGEgZmllbGQgaW4gdGhlIHJlcXVlc3QgYm9keS4gVGhlIHZh
bHVlIHdpbGwgYmUgYQogc2VxdWVuY2Ugb2YgZG90LXNlcGFyYXRlZCBpZGVudGlmaWVycyB0
aGF0IGlkZW50aWZ5IGEgcHJvdG9jb2wgYnVmZmVyCiBmaWVsZC4KCiBDb25zaWRlciB0aGUg
Zm9sbG93aW5nOgoKICAgICBtZXNzYWdlIENyZWF0ZUNvbnRhY3RSZXF1ZXN0IHsKICAgICAg
IG1lc3NhZ2UgRW1haWxBZGRyZXNzIHsKICAgICAgICAgZW51bSBUeXBlIHsKICAgICAgICAg
ICBUWVBFX1VOU1BFQ0lGSUVEID0gMDsKICAgICAgICAgICBIT01FID0gMTsKICAgICAgICAg
ICBXT1JLID0gMjsKICAgICAgICAgfQoKICAgICAgICAgb3B0aW9uYWwgc3RyaW5nIGVtYWls
ID0gMTsKICAgICAgICAgcmVwZWF0ZWQgRW1haWxUeXBlIHR5cGUgPSAyOwogICAgICAgfQoK
ICAgICAgIHN0cmluZyBmdWxsX25hbWUgPSAxOwogICAgICAgcmVwZWF0ZWQgRW1haWxBZGRy
ZXNzIGVtYWlsX2FkZHJlc3NlcyA9IDI7CiAgICAgfQoKIEluIHRoaXMgZXhhbXBsZSwgaW4g
cHJvdG8gYGZpZWxkYCBjb3VsZCB0YWtlIG9uZSBvZiB0aGUgZm9sbG93aW5nIHZhbHVlczoK
CiAqIGBmdWxsX25hbWVgIGZvciBhIHZpb2xhdGlvbiBpbiB0aGUgYGZ1bGxfbmFtZWAgdmFs
dWUKICogYGVtYWlsX2FkZHJlc3Nlc1swXS5lbWFpbGAgZm9yIGEgdmlvbGF0aW9uIGluIHRo
ZSBgZW1haWxgIGZpZWxkIG9mIHRoZQogICBmaXJzdCBgZW1haWxfYWRkcmVzc2VzYCBtZXNz
YWdlCiAqIGBlbWFpbF9hZGRyZXNzZXNbMl0udHlwZVsxXWAgZm9yIGEgdmlvbGF0aW9uIGlu
IHRoZSBzZWNvbmQgYHR5cGVgCiAgIHZhbHVlIGluIHRoZSB0aGlyZCBgZW1haWxfYWRkcmVz
c2VzYCBtZXNzYWdlLgoKIEluIEpTT04sIHRoZSBzYW1lIHZhbHVlcyBhcmUgcmVwcmVzZW50
ZWQgYXM6CgogKiBgZnVsbE5hbWVgIGZvciBhIHZpb2xhdGlvbiBpbiB0aGUgYGZ1bGxOYW1l
YCB2YWx1ZQogKiBgZW1haWxBZGRyZXNzZXNbMF0uZW1haWxgIGZvciBhIHZpb2xhdGlvbiBp
biB0aGUgYGVtYWlsYCBmaWVsZCBvZiB0aGUKICAgZmlyc3QgYGVtYWlsQWRkcmVzc2VzYCBt
ZXNzYWdlCiAqIGBlbWFpbEFkZHJlc3Nlc1syXS50eXBlWzFdYCBmb3IgYSB2aW9sYXRpb24g
aW4gdGhlIHNlY29uZCBgdHlwZWAKICAgdmFsdWUgaW4gdGhlIHRoaXJkIGBlbWFpbEFkZHJl
c3Nlc2AgbWVzc2FnZS4KCg8KBwQFAwACAAUSBJMCBAoKDwoHBAUDAAIAARIEkwILEAoPCgcE
BQMAAgADEgSTAhMUCkIKBgQFAwACARIElgIEGxoyIEEgZGVzY3JpcHRpb24gb2Ygd2h5IHRo
ZSByZXF1ZXN0IGVsZW1lbnQgaXMgYmFkLgoKDwoHBAUDAAIBBRIElgIECgoPCgcEBQMAAgEB
EgSWAgsWCg8KBwQFAwACAQMSBJYCGRoKiAMKBgQFAwACAhIEngIEFhr3AiBUaGUgcmVhc29u
IG9mIHRoZSBmaWVsZC1sZXZlbCBlcnJvci4gVGhpcyBpcyBhIGNvbnN0YW50IHZhbHVlIHRo
YXQKIGlkZW50aWZpZXMgdGhlIHByb3hpbWF0ZSBjYXVzZSBvZiB0aGUgZmllbGQtbGV2ZWwg
ZXJyb3IuIEl0IHNob3VsZAogdW5pcXVlbHkgaWRlbnRpZnkgdGhlIHR5cGUgb2YgdGhlIEZp
ZWxkVmlvbGF0aW9uIHdpdGhpbiB0aGUgc2NvcGUgb2YgdGhlCiBnb29nbGUucnBjLkVycm9y
SW5mby5kb21haW4uIFRoaXMgc2hvdWxkIGJlIGF0IG1vc3QgNjMKIGNoYXJhY3RlcnMgYW5k
IG1hdGNoIGEgcmVndWxhciBleHByZXNzaW9uIG9mIGBbQS1aXVtBLVowLTlfXStbQS1aMC05
XWAsCiB3aGljaCByZXByZXNlbnRzIFVQUEVSX1NOQUtFX0NBU0UuCgoPCgcEBQMAAgIFEgSe
AgQKCg8KBwQFAwACAgESBJ4CCxEKDwoHBAUDAAICAxIEngIUFQp4CgYEBQMAAgMSBKICBCsa
aCBQcm92aWRlcyBhIGxvY2FsaXplZCBlcnJvciBtZXNzYWdlIGZvciBmaWVsZC1sZXZlbCBl
cnJvcnMgdGhhdCBpcyBzYWZlIHRvCiByZXR1cm4gdG8gdGhlIEFQSSBjb25zdW1lci4KCg8K
BwQFAwACAwYSBKICBBQKDwoHBAUDAAIDARIEogIVJgoPCgcEBQMAAgMDEgSiAikqCj0KBAQF
AgASBKYCAi8aLyBEZXNjcmliZXMgYWxsIHZpb2xhdGlvbnMgaW4gYSBjbGllbnQgcmVxdWVz
dC4KCg0KBQQFAgAEEgSmAgIKCg0KBQQFAgAGEgSmAgsZCg0KBQQFAgABEgSmAhoqCg0KBQQF
AgADEgSmAi0uCoQBCgIEBhIGqwIAswIBGnYgQ29udGFpbnMgbWV0YWRhdGEgYWJvdXQgdGhl
IHJlcXVlc3QgdGhhdCBjbGllbnRzIGNhbiBhdHRhY2ggd2hlbiBmaWxpbmcgYSBidWcKIG9y
IHByb3ZpZGluZyBvdGhlciBmb3JtcyBvZiBmZWVkYmFjay4KCgsKAwQGARIEqwIIEwqoAQoE
BAYCABIErgICGBqZASBBbiBvcGFxdWUgc3RyaW5nIHRoYXQgc2hvdWxkIG9ubHkgYmUgaW50
ZXJwcmV0ZWQgYnkgdGhlIHNlcnZpY2UgZ2VuZXJhdGluZwogaXQuIEZvciBleGFtcGxlLCBp
dCBjYW4gYmUgdXNlZCB0byBpZGVudGlmeSByZXF1ZXN0cyBpbiB0aGUgc2VydmljZSdzIGxv
Z3MuCgoNCgUEBgIABRIErgICCAoNCgUEBgIAARIErgIJEwoNCgUEBgIAAxIErgIWFwqiAQoE
BAYCARIEsgICGhqTASBBbnkgZGF0YSB0aGF0IHdhcyB1c2VkIHRvIHNlcnZlIHRoaXMgcmVx
dWVzdC4gRm9yIGV4YW1wbGUsIGFuIGVuY3J5cHRlZAogc3RhY2sgdHJhY2UgdGhhdCBjYW4g
YmUgc2VudCBiYWNrIHRvIHRoZSBzZXJ2aWNlIHByb3ZpZGVyIGZvciBkZWJ1Z2dpbmcuCgoN
CgUEBgIBBRIEsgICCAoNCgUEBgIBARIEsgIJFQoNCgUEBgIBAxIEsgIYGQo+CgIEBxIGtgIA
ywIBGjAgRGVzY3JpYmVzIHRoZSByZXNvdXJjZSB0aGF0IGlzIGJlaW5nIGFjY2Vzc2VkLgoK
CwoDBAcBEgS2AggUCtsBCgQEBwIAEgS6AgIbGswBIEEgbmFtZSBmb3IgdGhlIHR5cGUgb2Yg
cmVzb3VyY2UgYmVpbmcgYWNjZXNzZWQsIGUuZy4gInNxbCB0YWJsZSIsCiAiY2xvdWQgc3Rv
cmFnZSBidWNrZXQiLCAiZmlsZSIsICJHb29nbGUgY2FsZW5kYXIiOyBvciB0aGUgdHlwZSBV
UkwKIG9mIHRoZSByZXNvdXJjZTogZS5nLiAidHlwZS5nb29nbGVhcGlzLmNvbS9nb29nbGUu
cHVic3ViLnYxLlRvcGljIi4KCg0KBQQHAgAFEgS6AgIICg0KBQQHAgABEgS6AgkWCg0KBQQH
AgADEgS6AhkaCvcBCgQEBwIBEgTAAgIbGugBIFRoZSBuYW1lIG9mIHRoZSByZXNvdXJjZSBi
ZWluZyBhY2Nlc3NlZC4gIEZvciBleGFtcGxlLCBhIHNoYXJlZCBjYWxlbmRhcgogbmFtZTog
ImV4YW1wbGUuY29tXzRmZ2hkaGdzcmdoQGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20iLCBp
ZiB0aGUgY3VycmVudAogZXJyb3IgaXMKIFtnb29nbGUucnBjLkNvZGUuUEVSTUlTU0lPTl9E
RU5JRURdW2dvb2dsZS5ycGMuQ29kZS5QRVJNSVNTSU9OX0RFTklFRF0uCgoNCgUEBwIBBRIE
wAICCAoNCgUEBwIBARIEwAIJFgoNCgUEBwIBAxIEwAIZGgqFAQoEBAcCAhIExQICExp3IFRo
ZSBvd25lciBvZiB0aGUgcmVzb3VyY2UgKG9wdGlvbmFsKS4KIEZvciBleGFtcGxlLCAidXNl
cjo8b3duZXIgZW1haWw+IiBvciAicHJvamVjdDo8R29vZ2xlIGRldmVsb3BlciBwcm9qZWN0
CiBpZD4iLgoKDQoFBAcCAgUSBMUCAggKDQoFBAcCAgESBMUCCQ4KDQoFBAcCAgMSBMUCERIK
wAEKBAQHAgMSBMoCAhkasQEgRGVzY3JpYmVzIHdoYXQgZXJyb3IgaXMgZW5jb3VudGVyZWQg
d2hlbiBhY2Nlc3NpbmcgdGhpcyByZXNvdXJjZS4KIEZvciBleGFtcGxlLCB1cGRhdGluZyBh
IGNsb3VkIHByb2plY3QgbWF5IHJlcXVpcmUgdGhlIGB3cml0ZXJgIHBlcm1pc3Npb24KIG9u
IHRoZSBkZXZlbG9wZXIgY29uc29sZSBwcm9qZWN0LgoKDQoFBAcCAwUSBMoCAggKDQoFBAcC
AwESBMoCCRQKDQoFBAcCAwMSBMoCFxgKugIKAgQIEgbSAgDeAgEaqwIgUHJvdmlkZXMgbGlu
a3MgdG8gZG9jdW1lbnRhdGlvbiBvciBmb3IgcGVyZm9ybWluZyBhbiBvdXQgb2YgYmFuZCBh
Y3Rpb24uCgogRm9yIGV4YW1wbGUsIGlmIGEgcXVvdGEgY2hlY2sgZmFpbGVkIHdpdGggYW4g
ZXJyb3IgaW5kaWNhdGluZyB0aGUgY2FsbGluZwogcHJvamVjdCBoYXNuJ3QgZW5hYmxlZCB0
aGUgYWNjZXNzZWQgc2VydmljZSwgdGhpcyBjYW4gY29udGFpbiBhIFVSTCBwb2ludGluZwog
ZGlyZWN0bHkgdG8gdGhlIHJpZ2h0IHBsYWNlIGluIHRoZSBkZXZlbG9wZXIgY29uc29sZSB0
byBmbGlwIHRoZSBiaXQuCgoLCgMECAESBNICCAwKJwoEBAgDABIG1AIC2gIDGhcgRGVzY3Jp
YmVzIGEgVVJMIGxpbmsuCgoNCgUECAMAARIE1AIKDgoxCgYECAMAAgASBNYCBBsaISBEZXNj
cmliZXMgd2hhdCB0aGUgbGluayBvZmZlcnMuCgoPCgcECAMAAgAFEgTWAgQKCg8KBwQIAwAC
AAESBNYCCxYKDwoHBAgDAAIAAxIE1gIZGgomCgYECAMAAgESBNkCBBMaFiBUaGUgVVJMIG9m
IHRoZSBsaW5rLgoKDwoHBAgDAAIBBRIE2QIECgoPCgcECAMAAgEBEgTZAgsOCg8KBwQIAwAC
AQMSBNkCERIKWAoEBAgCABIE3QICGhpKIFVSTChzKSBwb2ludGluZyB0byBhZGRpdGlvbmFs
IGluZm9ybWF0aW9uIG9uIGhhbmRsaW5nIHRoZSBjdXJyZW50IGVycm9yLgoKDQoFBAgCAAQS
BN0CAgoKDQoFBAgCAAYSBN0CCw8KDQoFBAgCAAESBN0CEBUKDQoFBAgCAAMSBN0CGBkKfQoC
BAkSBuICAOoCARpvIFByb3ZpZGVzIGEgbG9jYWxpemVkIGVycm9yIG1lc3NhZ2UgdGhhdCBp
cyBzYWZlIHRvIHJldHVybiB0byB0aGUgdXNlcgogd2hpY2ggY2FuIGJlIGF0dGFjaGVkIHRv
IGFuIFJQQyBlcnJvci4KCgsKAwQJARIE4gIIGAqfAQoEBAkCABIE5gICFBqQASBUaGUgbG9j
YWxlIHVzZWQgZm9sbG93aW5nIHRoZSBzcGVjaWZpY2F0aW9uIGRlZmluZWQgYXQKIGh0dHBz
Oi8vd3d3LnJmYy1lZGl0b3Iub3JnL3JmYy9iY3AvYmNwNDcudHh0LgogRXhhbXBsZXMgYXJl
OiAiZW4tVVMiLCAiZnItQ0giLCAiZXMtTVgiCgoNCgUECQIABRIE5gICCAoNCgUECQIAARIE
5gIJDwoNCgUECQIAAxIE5gISEwpACgQECQIBEgTpAgIVGjIgVGhlIGxvY2FsaXplZCBlcnJv
ciBtZXNzYWdlIGluIHRoZSBhYm92ZSBsb2NhbGUuCgoNCgUECQIBBRIE6QICCAoNCgUECQIB
ARIE6QIJEAoNCgUECQIBAxIE6QITFGIGcHJvdG8z
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Rpc::ErrorDetails::ErrorInfo ===
    # Fields for ErrorInfo
    # Field: reason Type: 9 ()
    # Field: domain Type: 9 ()
    # Field: metadata Type: 11 (.google.rpc.ErrorInfo.MetadataEntry)

# === Message: Google::Rpc::ErrorDetails::RetryInfo ===
    # Fields for RetryInfo
    # Field: retry_delay Type: 11 (.google.protobuf.Duration)

# === Message: Google::Rpc::ErrorDetails::DebugInfo ===
    # Fields for DebugInfo
    # Field: stack_entries Type: 9 ()
    # Field: detail Type: 9 ()

# === Message: Google::Rpc::ErrorDetails::QuotaFailure ===
    # Fields for QuotaFailure
    # Field: violations Type: 11 (.google.rpc.QuotaFailure.Violation)

# === Message: Google::Rpc::ErrorDetails::PreconditionFailure ===
    # Fields for PreconditionFailure
    # Field: violations Type: 11 (.google.rpc.PreconditionFailure.Violation)

# === Message: Google::Rpc::ErrorDetails::BadRequest ===
    # Fields for BadRequest
    # Field: field_violations Type: 11 (.google.rpc.BadRequest.FieldViolation)

# === Message: Google::Rpc::ErrorDetails::RequestInfo ===
    # Fields for RequestInfo
    # Field: request_id Type: 9 ()
    # Field: serving_data Type: 9 ()

# === Message: Google::Rpc::ErrorDetails::ResourceInfo ===
    # Fields for ResourceInfo
    # Field: resource_type Type: 9 ()
    # Field: resource_name Type: 9 ()
    # Field: owner Type: 9 ()
    # Field: description Type: 9 ()

# === Message: Google::Rpc::ErrorDetails::Help ===
    # Fields for Help
    # Field: links Type: 11 (.google.rpc.Help.Link)

# === Message: Google::Rpc::ErrorDetails::LocalizedMessage ===
    # Fields for LocalizedMessage
    # Field: locale Type: 9 ()
    # Field: message Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Rpc::ErrorDetails - Compiled Protocol Buffers messages for google/rpc/error_details.proto

=head1 SYNOPSIS

    use Google::Rpc::ErrorDetails;

    my $msg = Google::Rpc::ErrorDetails::ErrorInfo->new({
        reason => $reason,
        domain => $domain,
        metadata => $metadata,
    });

    # Read or update a field
    my $val = $msg->reason();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Rpc::ErrorDetails::ErrorInfo->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/rpc/error_details.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Rpc::ErrorDetails::ErrorInfo

Describes the cause of the error with structured details.

Example of an error when contacting the "pubsub.googleapis.com" API when it
is not enabled:

    { "reason": "API_DISABLED"
      "domain": "googleapis.com"
      "metadata": {
        "resource": "projects/123",
        "service": "pubsub.googleapis.com"
      }
    }

This response indicates that the pubsub.googleapis.com API is not enabled.

Example of an error that is returned when attempting to create a Spanner
instance in a region that is out of stock:

    { "reason": "STOCKOUT"
      "domain": "spanner.googleapis.com",
      "metadata": {
        "availableRegions": "us-central1,us-east2"
      }
    }

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->reason() >> / C<< $msg->reason($value) >>

Type: C<String>

The reason of the error. This is a constant value that identifies the
proximate cause of the error. Error reasons are unique within a particular
domain of errors. This should be at most 63 characters and match a
regular expression of `[A-Z][A-Z0-9_]+[A-Z0-9]`, which represents
UPPER_SNAKE_CASE.

=item * C<< $msg->domain() >> / C<< $msg->domain($value) >>

Type: C<String>

The logical grouping to which the "reason" belongs. The error domain
is typically the registered service name of the tool or product that
generates the error. Example: "pubsub.googleapis.com". If the error is
generated by some common infrastructure, the error domain must be a
globally unique value that identifies the infrastructure. For Google API
infrastructure, the error domain is "googleapis.com".

=item * C<< $msg->metadata() >> / C<< $msg->metadata($value) >>

Type: C<Message> (L<Google::Rpc::ErrorDetails::ErrorInfo::MetadataEntry>)

Additional structured details about this error.

Keys must match a regular expression of `[a-z][a-zA-Z0-9-_]+` but should
ideally be lowerCamelCase. Also, they must be limited to 64 characters in
length. When identifying the current value of an exceeded limit, the units
should be contained in the key, not the value.  For example, rather than
`{"instanceLimit": "100/request"}`, should be returned as,
`{"instanceLimitPerRequest": "100"}`, if the client exceeds the number of
instances that can be created in a single (batch) request.

=back

=head2 Google::Rpc::ErrorDetails::RetryInfo

Describes when the clients can retry a failed request. Clients could ignore
the recommendation here or retry when this information is missing from error
responses.

It's always recommended that clients should use exponential backoff when
retrying.

Clients should wait until `retry_delay` amount of time has passed since
receiving the error response before retrying.  If retrying requests also
fail, clients should use an exponential backoff scheme to gradually increase
the delay between retries based on `retry_delay`, until either a maximum
number of retries have been reached or a maximum retry delay cap has been
reached.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->retry_delay() >> / C<< $msg->retry_delay($value) >>

Type: C<Message> (L<Google::Protobuf::Duration::Duration>)

Clients should wait at least this long between retrying the same request.

=back

=head2 Google::Rpc::ErrorDetails::DebugInfo

Describes additional debugging info.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->stack_entries() >> / C<< $msg->stack_entries($value) >>

Type: C<String>

The stack trace entries indicating where the error occurred.

=item * C<< $msg->detail() >> / C<< $msg->detail($value) >>

Type: C<String>

Additional debugging information provided by the server.

=back

=head2 Google::Rpc::ErrorDetails::QuotaFailure

Describes how a quota check failed.

For example if a daily limit was exceeded for the calling project,
a service could respond with a QuotaFailure detail containing the project
id and the description of the quota limit that was exceeded.  If the
calling project hasn't enabled the service in the developer console, then
a service could respond with the project id and set `service_disabled`
to true.

Also see RetryInfo and Help types for other details about handling a
quota failure.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->violations() >> / C<< $msg->violations($value) >>

Type: C<Message> (L<Google::Rpc::ErrorDetails::QuotaFailure::Violation>)

Describes all quota violations.

=back

=head2 Google::Rpc::ErrorDetails::PreconditionFailure

Describes what preconditions have failed.

For example, if an RPC failed because it required the Terms of Service to be
acknowledged, it could list the terms of service violation in the
PreconditionFailure message.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->violations() >> / C<< $msg->violations($value) >>

Type: C<Message> (L<Google::Rpc::ErrorDetails::PreconditionFailure::Violation>)

Describes all precondition violations.

=back

=head2 Google::Rpc::ErrorDetails::BadRequest

Describes violations in a client request. This error type focuses on the
syntactic aspects of the request.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->field_violations() >> / C<< $msg->field_violations($value) >>

Type: C<Message> (L<Google::Rpc::ErrorDetails::BadRequest::FieldViolation>)

Describes all violations in a client request.

=back

=head2 Google::Rpc::ErrorDetails::RequestInfo

Contains metadata about the request that clients can attach when filing a bug
or providing other forms of feedback.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->request_id() >> / C<< $msg->request_id($value) >>

Type: C<String>

An opaque string that should only be interpreted by the service generating
it. For example, it can be used to identify requests in the service's logs.

=item * C<< $msg->serving_data() >> / C<< $msg->serving_data($value) >>

Type: C<String>

Any data that was used to serve this request. For example, an encrypted
stack trace that can be sent back to the service provider for debugging.

=back

=head2 Google::Rpc::ErrorDetails::ResourceInfo

Describes the resource that is being accessed.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->resource_type() >> / C<< $msg->resource_type($value) >>

Type: C<String>

A name for the type of resource being accessed, e.g. "sql table",
"cloud storage bucket", "file", "Google calendar"; or the type URL
of the resource: e.g. "type.googleapis.com/google.pubsub.v1.Topic".

=item * C<< $msg->resource_name() >> / C<< $msg->resource_name($value) >>

Type: C<String>

The name of the resource being accessed.  For example, a shared calendar
name: "example.com_4fghdhgsrgh@group.calendar.google.com", if the current
error is
[google.rpc.Code.PERMISSION_DENIED][google.rpc.Code.PERMISSION_DENIED].

=item * C<< $msg->owner() >> / C<< $msg->owner($value) >>

Type: C<String>

The owner of the resource (optional).
For example, "user:<owner email>" or "project:<Google developer project
id>".

=item * C<< $msg->description() >> / C<< $msg->description($value) >>

Type: C<String>

Describes what error is encountered when accessing this resource.
For example, updating a cloud project may require the `writer` permission
on the developer console project.

=back

=head2 Google::Rpc::ErrorDetails::Help

Provides links to documentation or for performing an out of band action.

For example, if a quota check failed with an error indicating the calling
project hasn't enabled the accessed service, this can contain a URL pointing
directly to the right place in the developer console to flip the bit.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->links() >> / C<< $msg->links($value) >>

Type: C<Message> (L<Google::Rpc::ErrorDetails::Help::Link>)

URL(s) pointing to additional information on handling the current error.

=back

=head2 Google::Rpc::ErrorDetails::LocalizedMessage

Provides a localized error message that is safe to return to the user
which can be attached to an RPC error.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->locale() >> / C<< $msg->locale($value) >>

Type: C<String>

The locale used following the specification defined at
https://www.rfc-editor.org/rfc/bcp/bcp47.txt.
Examples are: "en-US", "fr-CH", "es-MX"

=item * C<< $msg->message() >> / C<< $msg->message($value) >>

Type: C<String>

The localized error message in the above locale.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Rpc::ErrorDetails::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

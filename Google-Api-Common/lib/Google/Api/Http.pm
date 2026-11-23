package Google::Api::Http;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
ChVnb29nbGUvYXBpL2h0dHAucHJvdG8SCmdvb2dsZS5hcGkieQoESHR0cBIqCgVydWxlcxgB
IAMoCzIULmdvb2dsZS5hcGkuSHR0cFJ1bGVSBXJ1bGVzEkUKH2Z1bGx5X2RlY29kZV9yZXNl
cnZlZF9leHBhbnNpb24YAiABKAhSHGZ1bGx5RGVjb2RlUmVzZXJ2ZWRFeHBhbnNpb24i2gIK
CEh0dHBSdWxlEhoKCHNlbGVjdG9yGAEgASgJUghzZWxlY3RvchISCgNnZXQYAiABKAlIAFID
Z2V0EhIKA3B1dBgDIAEoCUgAUgNwdXQSFAoEcG9zdBgEIAEoCUgAUgRwb3N0EhgKBmRlbGV0
ZRgFIAEoCUgAUgZkZWxldGUSFgoFcGF0Y2gYBiABKAlIAFIFcGF0Y2gSNwoGY3VzdG9tGAgg
ASgLMh0uZ29vZ2xlLmFwaS5DdXN0b21IdHRwUGF0dGVybkgAUgZjdXN0b20SEgoEYm9keRgH
IAEoCVIEYm9keRIjCg1yZXNwb25zZV9ib2R5GAwgASgJUgxyZXNwb25zZUJvZHkSRQoTYWRk
aXRpb25hbF9iaW5kaW5ncxgLIAMoCzIULmdvb2dsZS5hcGkuSHR0cFJ1bGVSEmFkZGl0aW9u
YWxCaW5kaW5nc0IJCgdwYXR0ZXJuIjsKEUN1c3RvbUh0dHBQYXR0ZXJuEhIKBGtpbmQYASAB
KAlSBGtpbmQSEgoEcGF0aBgCIAEoCVIEcGF0aEJnCg5jb20uZ29vZ2xlLmFwaUIJSHR0cFBy
b3RvUAFaQWdvb2dsZS5nb2xhbmcub3JnL2dlbnByb3RvL2dvb2dsZWFwaXMvYXBpL2Fubm90
YXRpb25zO2Fubm90YXRpb25zogIER0FQSUrpcgoHEgUOAPECAQq8BAoBDBIDDgASMrEEIENv
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
bmRlciB0aGUgTGljZW5zZS4KCggKAQISAxAAEwoICgEIEgMSAFgKCQoCCAsSAxIAWAoICgEI
EgMTACIKCQoCCAoSAxMAIgoICgEIEgMUACoKCQoCCAgSAxQAKgoICgEIEgMVACcKCQoCCAES
AxUAJwoICgEIEgMWACIKCQoCCCQSAxYAIgrNAQoCBAASBBsAKAEawAEgRGVmaW5lcyB0aGUg
SFRUUCBjb25maWd1cmF0aW9uIGZvciBhbiBBUEkgc2VydmljZS4gSXQgY29udGFpbnMgYSBs
aXN0IG9mCiBbSHR0cFJ1bGVdW2dvb2dsZS5hcGkuSHR0cFJ1bGVdLCBlYWNoIHNwZWNpZnlp
bmcgdGhlIG1hcHBpbmcgb2YgYW4gUlBDIG1ldGhvZAogdG8gb25lIG9yIG1vcmUgSFRUUCBS
RVNUIEFQSSBtZXRob2RzLgoKCgoDBAABEgMbCAwKogEKBAQAAgASAx8CHhqUASBBIGxpc3Qg
b2YgSFRUUCBjb25maWd1cmF0aW9uIHJ1bGVzIHRoYXQgYXBwbHkgdG8gaW5kaXZpZHVhbCBB
UEkgbWV0aG9kcy4KCiAqKk5PVEU6KiogQWxsIHNlcnZpY2UgY29uZmlndXJhdGlvbiBydWxl
cyBmb2xsb3cgImxhc3Qgb25lIHdpbnMiIG9yZGVyLgoKDAoFBAACAAQSAx8CCgoMCgUEAAIA
BhIDHwsTCgwKBQQAAgABEgMfFBkKDAoFBAACAAMSAx8cHQqUAgoEBAACARIDJwIrGoYCIFdo
ZW4gc2V0IHRvIHRydWUsIFVSTCBwYXRoIHBhcmFtZXRlcnMgd2lsbCBiZSBmdWxseSBVUkkt
ZGVjb2RlZCBleGNlcHQgaW4KIGNhc2VzIG9mIHNpbmdsZSBzZWdtZW50IG1hdGNoZXMgaW4g
cmVzZXJ2ZWQgZXhwYW5zaW9uLCB3aGVyZSAiJTJGIiB3aWxsIGJlCiBsZWZ0IGVuY29kZWQu
CgogVGhlIGRlZmF1bHQgYmVoYXZpb3IgaXMgdG8gbm90IGRlY29kZSBSRkMgNjU3MCByZXNl
cnZlZCBjaGFyYWN0ZXJzIGluIG11bHRpCiBzZWdtZW50IG1hdGNoZXMuCgoMCgUEAAIBBRID
JwIGCgwKBQQAAgEBEgMnByYKDAoFBAACAQMSAycpKgqHUwoCBAESBrICAOgCARr4UiBnUlBD
IFRyYW5zY29kaW5nCgogZ1JQQyBUcmFuc2NvZGluZyBpcyBhIGZlYXR1cmUgZm9yIG1hcHBp
bmcgYmV0d2VlbiBhIGdSUEMgbWV0aG9kIGFuZCBvbmUgb3IKIG1vcmUgSFRUUCBSRVNUIGVu
ZHBvaW50cy4gSXQgYWxsb3dzIGRldmVsb3BlcnMgdG8gYnVpbGQgYSBzaW5nbGUgQVBJIHNl
cnZpY2UKIHRoYXQgc3VwcG9ydHMgYm90aCBnUlBDIEFQSXMgYW5kIFJFU1QgQVBJcy4gTWFu
eSBzeXN0ZW1zLCBpbmNsdWRpbmcgW0dvb2dsZQogQVBJc10oaHR0cHM6Ly9naXRodWIuY29t
L2dvb2dsZWFwaXMvZ29vZ2xlYXBpcyksCiBbQ2xvdWQgRW5kcG9pbnRzXShodHRwczovL2Ns
b3VkLmdvb2dsZS5jb20vZW5kcG9pbnRzKSwgW2dSUEMKIEdhdGV3YXldKGh0dHBzOi8vZ2l0
aHViLmNvbS9ncnBjLWVjb3N5c3RlbS9ncnBjLWdhdGV3YXkpLAogYW5kIFtFbnZveV0oaHR0
cHM6Ly9naXRodWIuY29tL2Vudm95cHJveHkvZW52b3kpIHByb3h5IHN1cHBvcnQgdGhpcyBm
ZWF0dXJlCiBhbmQgdXNlIGl0IGZvciBsYXJnZSBzY2FsZSBwcm9kdWN0aW9uIHNlcnZpY2Vz
LgoKIGBIdHRwUnVsZWAgZGVmaW5lcyB0aGUgc2NoZW1hIG9mIHRoZSBnUlBDL1JFU1QgbWFw
cGluZy4gVGhlIG1hcHBpbmcgc3BlY2lmaWVzCiBob3cgZGlmZmVyZW50IHBvcnRpb25zIG9m
IHRoZSBnUlBDIHJlcXVlc3QgbWVzc2FnZSBhcmUgbWFwcGVkIHRvIHRoZSBVUkwKIHBhdGgs
IFVSTCBxdWVyeSBwYXJhbWV0ZXJzLCBhbmQgSFRUUCByZXF1ZXN0IGJvZHkuIEl0IGFsc28g
Y29udHJvbHMgaG93IHRoZQogZ1JQQyByZXNwb25zZSBtZXNzYWdlIGlzIG1hcHBlZCB0byB0
aGUgSFRUUCByZXNwb25zZSBib2R5LiBgSHR0cFJ1bGVgIGlzCiB0eXBpY2FsbHkgc3BlY2lm
aWVkIGFzIGFuIGBnb29nbGUuYXBpLmh0dHBgIGFubm90YXRpb24gb24gdGhlIGdSUEMgbWV0
aG9kLgoKIEVhY2ggbWFwcGluZyBzcGVjaWZpZXMgYSBVUkwgcGF0aCB0ZW1wbGF0ZSBhbmQg
YW4gSFRUUCBtZXRob2QuIFRoZSBwYXRoCiB0ZW1wbGF0ZSBtYXkgcmVmZXIgdG8gb25lIG9y
IG1vcmUgZmllbGRzIGluIHRoZSBnUlBDIHJlcXVlc3QgbWVzc2FnZSwgYXMgbG9uZwogYXMg
ZWFjaCBmaWVsZCBpcyBhIG5vbi1yZXBlYXRlZCBmaWVsZCB3aXRoIGEgcHJpbWl0aXZlIChu
b24tbWVzc2FnZSkgdHlwZS4KIFRoZSBwYXRoIHRlbXBsYXRlIGNvbnRyb2xzIGhvdyBmaWVs
ZHMgb2YgdGhlIHJlcXVlc3QgbWVzc2FnZSBhcmUgbWFwcGVkIHRvCiB0aGUgVVJMIHBhdGgu
CgogRXhhbXBsZToKCiAgICAgc2VydmljZSBNZXNzYWdpbmcgewogICAgICAgcnBjIEdldE1l
c3NhZ2UoR2V0TWVzc2FnZVJlcXVlc3QpIHJldHVybnMgKE1lc3NhZ2UpIHsKICAgICAgICAg
b3B0aW9uIChnb29nbGUuYXBpLmh0dHApID0gewogICAgICAgICAgICAgZ2V0OiAiL3YxL3tu
YW1lPW1lc3NhZ2VzLyp9IgogICAgICAgICB9OwogICAgICAgfQogICAgIH0KICAgICBtZXNz
YWdlIEdldE1lc3NhZ2VSZXF1ZXN0IHsKICAgICAgIHN0cmluZyBuYW1lID0gMTsgLy8gTWFw
cGVkIHRvIFVSTCBwYXRoLgogICAgIH0KICAgICBtZXNzYWdlIE1lc3NhZ2UgewogICAgICAg
c3RyaW5nIHRleHQgPSAxOyAvLyBUaGUgcmVzb3VyY2UgY29udGVudC4KICAgICB9CgogVGhp
cyBlbmFibGVzIGFuIEhUVFAgUkVTVCB0byBnUlBDIG1hcHBpbmcgYXMgYmVsb3c6CgogLSBI
VFRQOiBgR0VUIC92MS9tZXNzYWdlcy8xMjM0NTZgCiAtIGdSUEM6IGBHZXRNZXNzYWdlKG5h
bWU6ICJtZXNzYWdlcy8xMjM0NTYiKWAKCiBBbnkgZmllbGRzIGluIHRoZSByZXF1ZXN0IG1l
c3NhZ2Ugd2hpY2ggYXJlIG5vdCBib3VuZCBieSB0aGUgcGF0aCB0ZW1wbGF0ZQogYXV0b21h
dGljYWxseSBiZWNvbWUgSFRUUCBxdWVyeSBwYXJhbWV0ZXJzIGlmIHRoZXJlIGlzIG5vIEhU
VFAgcmVxdWVzdCBib2R5LgogRm9yIGV4YW1wbGU6CgogICAgIHNlcnZpY2UgTWVzc2FnaW5n
IHsKICAgICAgIHJwYyBHZXRNZXNzYWdlKEdldE1lc3NhZ2VSZXF1ZXN0KSByZXR1cm5zIChN
ZXNzYWdlKSB7CiAgICAgICAgIG9wdGlvbiAoZ29vZ2xlLmFwaS5odHRwKSA9IHsKICAgICAg
ICAgICAgIGdldDoiL3YxL21lc3NhZ2VzL3ttZXNzYWdlX2lkfSIKICAgICAgICAgfTsKICAg
ICAgIH0KICAgICB9CiAgICAgbWVzc2FnZSBHZXRNZXNzYWdlUmVxdWVzdCB7CiAgICAgICBt
ZXNzYWdlIFN1Yk1lc3NhZ2UgewogICAgICAgICBzdHJpbmcgc3ViZmllbGQgPSAxOwogICAg
ICAgfQogICAgICAgc3RyaW5nIG1lc3NhZ2VfaWQgPSAxOyAvLyBNYXBwZWQgdG8gVVJMIHBh
dGguCiAgICAgICBpbnQ2NCByZXZpc2lvbiA9IDI7ICAgIC8vIE1hcHBlZCB0byBVUkwgcXVl
cnkgcGFyYW1ldGVyIGByZXZpc2lvbmAuCiAgICAgICBTdWJNZXNzYWdlIHN1YiA9IDM7ICAg
IC8vIE1hcHBlZCB0byBVUkwgcXVlcnkgcGFyYW1ldGVyIGBzdWIuc3ViZmllbGRgLgogICAg
IH0KCiBUaGlzIGVuYWJsZXMgYSBIVFRQIEpTT04gdG8gUlBDIG1hcHBpbmcgYXMgYmVsb3c6
CgogLSBIVFRQOiBgR0VUIC92MS9tZXNzYWdlcy8xMjM0NTY/cmV2aXNpb249MiZzdWIuc3Vi
ZmllbGQ9Zm9vYAogLSBnUlBDOiBgR2V0TWVzc2FnZShtZXNzYWdlX2lkOiAiMTIzNDU2IiBy
ZXZpc2lvbjogMiBzdWI6CiBTdWJNZXNzYWdlKHN1YmZpZWxkOiAiZm9vIikpYAoKIE5vdGUg
dGhhdCBmaWVsZHMgd2hpY2ggYXJlIG1hcHBlZCB0byBVUkwgcXVlcnkgcGFyYW1ldGVycyBt
dXN0IGhhdmUgYQogcHJpbWl0aXZlIHR5cGUgb3IgYSByZXBlYXRlZCBwcmltaXRpdmUgdHlw
ZSBvciBhIG5vbi1yZXBlYXRlZCBtZXNzYWdlIHR5cGUuCiBJbiB0aGUgY2FzZSBvZiBhIHJl
cGVhdGVkIHR5cGUsIHRoZSBwYXJhbWV0ZXIgY2FuIGJlIHJlcGVhdGVkIGluIHRoZSBVUkwK
IGFzIGAuLi4/cGFyYW09QSZwYXJhbT1CYC4gSW4gdGhlIGNhc2Ugb2YgYSBtZXNzYWdlIHR5
cGUsIGVhY2ggZmllbGQgb2YgdGhlCiBtZXNzYWdlIGlzIG1hcHBlZCB0byBhIHNlcGFyYXRl
IHBhcmFtZXRlciwgc3VjaCBhcwogYC4uLj9mb28uYT1BJmZvby5iPUImZm9vLmM9Q2AuCgog
Rm9yIEhUVFAgbWV0aG9kcyB0aGF0IGFsbG93IGEgcmVxdWVzdCBib2R5LCB0aGUgYGJvZHlg
IGZpZWxkCiBzcGVjaWZpZXMgdGhlIG1hcHBpbmcuIENvbnNpZGVyIGEgUkVTVCB1cGRhdGUg
bWV0aG9kIG9uIHRoZQogbWVzc2FnZSByZXNvdXJjZSBjb2xsZWN0aW9uOgoKICAgICBzZXJ2
aWNlIE1lc3NhZ2luZyB7CiAgICAgICBycGMgVXBkYXRlTWVzc2FnZShVcGRhdGVNZXNzYWdl
UmVxdWVzdCkgcmV0dXJucyAoTWVzc2FnZSkgewogICAgICAgICBvcHRpb24gKGdvb2dsZS5h
cGkuaHR0cCkgPSB7CiAgICAgICAgICAgcGF0Y2g6ICIvdjEvbWVzc2FnZXMve21lc3NhZ2Vf
aWR9IgogICAgICAgICAgIGJvZHk6ICJtZXNzYWdlIgogICAgICAgICB9OwogICAgICAgfQog
ICAgIH0KICAgICBtZXNzYWdlIFVwZGF0ZU1lc3NhZ2VSZXF1ZXN0IHsKICAgICAgIHN0cmlu
ZyBtZXNzYWdlX2lkID0gMTsgLy8gbWFwcGVkIHRvIHRoZSBVUkwKICAgICAgIE1lc3NhZ2Ug
bWVzc2FnZSA9IDI7ICAgLy8gbWFwcGVkIHRvIHRoZSBib2R5CiAgICAgfQoKIFRoZSBmb2xs
b3dpbmcgSFRUUCBKU09OIHRvIFJQQyBtYXBwaW5nIGlzIGVuYWJsZWQsIHdoZXJlIHRoZQog
cmVwcmVzZW50YXRpb24gb2YgdGhlIEpTT04gaW4gdGhlIHJlcXVlc3QgYm9keSBpcyBkZXRl
cm1pbmVkIGJ5CiBwcm90b3MgSlNPTiBlbmNvZGluZzoKCiAtIEhUVFA6IGBQQVRDSCAvdjEv
bWVzc2FnZXMvMTIzNDU2IHsgInRleHQiOiAiSGkhIiB9YAogLSBnUlBDOiBgVXBkYXRlTWVz
c2FnZShtZXNzYWdlX2lkOiAiMTIzNDU2IiBtZXNzYWdlIHsgdGV4dDogIkhpISIgfSlgCgog
VGhlIHNwZWNpYWwgbmFtZSBgKmAgY2FuIGJlIHVzZWQgaW4gdGhlIGJvZHkgbWFwcGluZyB0
byBkZWZpbmUgdGhhdAogZXZlcnkgZmllbGQgbm90IGJvdW5kIGJ5IHRoZSBwYXRoIHRlbXBs
YXRlIHNob3VsZCBiZSBtYXBwZWQgdG8gdGhlCiByZXF1ZXN0IGJvZHkuICBUaGlzIGVuYWJs
ZXMgdGhlIGZvbGxvd2luZyBhbHRlcm5hdGl2ZSBkZWZpbml0aW9uIG9mCiB0aGUgdXBkYXRl
IG1ldGhvZDoKCiAgICAgc2VydmljZSBNZXNzYWdpbmcgewogICAgICAgcnBjIFVwZGF0ZU1l
c3NhZ2UoTWVzc2FnZSkgcmV0dXJucyAoTWVzc2FnZSkgewogICAgICAgICBvcHRpb24gKGdv
b2dsZS5hcGkuaHR0cCkgPSB7CiAgICAgICAgICAgcGF0Y2g6ICIvdjEvbWVzc2FnZXMve21l
c3NhZ2VfaWR9IgogICAgICAgICAgIGJvZHk6ICIqIgogICAgICAgICB9OwogICAgICAgfQog
ICAgIH0KICAgICBtZXNzYWdlIE1lc3NhZ2UgewogICAgICAgc3RyaW5nIG1lc3NhZ2VfaWQg
PSAxOwogICAgICAgc3RyaW5nIHRleHQgPSAyOwogICAgIH0KCgogVGhlIGZvbGxvd2luZyBI
VFRQIEpTT04gdG8gUlBDIG1hcHBpbmcgaXMgZW5hYmxlZDoKCiAtIEhUVFA6IGBQQVRDSCAv
djEvbWVzc2FnZXMvMTIzNDU2IHsgInRleHQiOiAiSGkhIiB9YAogLSBnUlBDOiBgVXBkYXRl
TWVzc2FnZShtZXNzYWdlX2lkOiAiMTIzNDU2IiB0ZXh0OiAiSGkhIilgCgogTm90ZSB0aGF0
IHdoZW4gdXNpbmcgYCpgIGluIHRoZSBib2R5IG1hcHBpbmcsIGl0IGlzIG5vdCBwb3NzaWJs
ZSB0bwogaGF2ZSBIVFRQIHBhcmFtZXRlcnMsIGFzIGFsbCBmaWVsZHMgbm90IGJvdW5kIGJ5
IHRoZSBwYXRoIGVuZCBpbgogdGhlIGJvZHkuIFRoaXMgbWFrZXMgdGhpcyBvcHRpb24gbW9y
ZSByYXJlbHkgdXNlZCBpbiBwcmFjdGljZSB3aGVuCiBkZWZpbmluZyBSRVNUIEFQSXMuIFRo
ZSBjb21tb24gdXNhZ2Ugb2YgYCpgIGlzIGluIGN1c3RvbSBtZXRob2RzCiB3aGljaCBkb24n
dCB1c2UgdGhlIFVSTCBhdCBhbGwgZm9yIHRyYW5zZmVycmluZyBkYXRhLgoKIEl0IGlzIHBv
c3NpYmxlIHRvIGRlZmluZSBtdWx0aXBsZSBIVFRQIG1ldGhvZHMgZm9yIG9uZSBSUEMgYnkg
dXNpbmcKIHRoZSBgYWRkaXRpb25hbF9iaW5kaW5nc2Agb3B0aW9uLiBFeGFtcGxlOgoKICAg
ICBzZXJ2aWNlIE1lc3NhZ2luZyB7CiAgICAgICBycGMgR2V0TWVzc2FnZShHZXRNZXNzYWdl
UmVxdWVzdCkgcmV0dXJucyAoTWVzc2FnZSkgewogICAgICAgICBvcHRpb24gKGdvb2dsZS5h
cGkuaHR0cCkgPSB7CiAgICAgICAgICAgZ2V0OiAiL3YxL21lc3NhZ2VzL3ttZXNzYWdlX2lk
fSIKICAgICAgICAgICBhZGRpdGlvbmFsX2JpbmRpbmdzIHsKICAgICAgICAgICAgIGdldDog
Ii92MS91c2Vycy97dXNlcl9pZH0vbWVzc2FnZXMve21lc3NhZ2VfaWR9IgogICAgICAgICAg
IH0KICAgICAgICAgfTsKICAgICAgIH0KICAgICB9CiAgICAgbWVzc2FnZSBHZXRNZXNzYWdl
UmVxdWVzdCB7CiAgICAgICBzdHJpbmcgbWVzc2FnZV9pZCA9IDE7CiAgICAgICBzdHJpbmcg
dXNlcl9pZCA9IDI7CiAgICAgfQoKIFRoaXMgZW5hYmxlcyB0aGUgZm9sbG93aW5nIHR3byBh
bHRlcm5hdGl2ZSBIVFRQIEpTT04gdG8gUlBDIG1hcHBpbmdzOgoKIC0gSFRUUDogYEdFVCAv
djEvbWVzc2FnZXMvMTIzNDU2YAogLSBnUlBDOiBgR2V0TWVzc2FnZShtZXNzYWdlX2lkOiAi
MTIzNDU2IilgCgogLSBIVFRQOiBgR0VUIC92MS91c2Vycy9tZS9tZXNzYWdlcy8xMjM0NTZg
CiAtIGdSUEM6IGBHZXRNZXNzYWdlKHVzZXJfaWQ6ICJtZSIgbWVzc2FnZV9pZDogIjEyMzQ1
NiIpYAoKIFJ1bGVzIGZvciBIVFRQIG1hcHBpbmcKCiAxLiBMZWFmIHJlcXVlc3QgZmllbGRz
IChyZWN1cnNpdmUgZXhwYW5zaW9uIG5lc3RlZCBtZXNzYWdlcyBpbiB0aGUgcmVxdWVzdAog
ICAgbWVzc2FnZSkgYXJlIGNsYXNzaWZpZWQgaW50byB0aHJlZSBjYXRlZ29yaWVzOgogICAg
LSBGaWVsZHMgcmVmZXJyZWQgYnkgdGhlIHBhdGggdGVtcGxhdGUuIFRoZXkgYXJlIHBhc3Nl
ZCB2aWEgdGhlIFVSTCBwYXRoLgogICAgLSBGaWVsZHMgcmVmZXJyZWQgYnkgdGhlIFtIdHRw
UnVsZS5ib2R5XVtnb29nbGUuYXBpLkh0dHBSdWxlLmJvZHldLiBUaGV5CiAgICBhcmUgcGFz
c2VkIHZpYSB0aGUgSFRUUAogICAgICByZXF1ZXN0IGJvZHkuCiAgICAtIEFsbCBvdGhlciBm
aWVsZHMgYXJlIHBhc3NlZCB2aWEgdGhlIFVSTCBxdWVyeSBwYXJhbWV0ZXJzLCBhbmQgdGhl
CiAgICAgIHBhcmFtZXRlciBuYW1lIGlzIHRoZSBmaWVsZCBwYXRoIGluIHRoZSByZXF1ZXN0
IG1lc3NhZ2UuIEEgcmVwZWF0ZWQKICAgICAgZmllbGQgY2FuIGJlIHJlcHJlc2VudGVkIGFz
IG11bHRpcGxlIHF1ZXJ5IHBhcmFtZXRlcnMgdW5kZXIgdGhlIHNhbWUKICAgICAgbmFtZS4K
ICAyLiBJZiBbSHR0cFJ1bGUuYm9keV1bZ29vZ2xlLmFwaS5IdHRwUnVsZS5ib2R5XSBpcyAi
KiIsIHRoZXJlIGlzIG5vIFVSTAogIHF1ZXJ5IHBhcmFtZXRlciwgYWxsIGZpZWxkcwogICAg
IGFyZSBwYXNzZWQgdmlhIFVSTCBwYXRoIGFuZCBIVFRQIHJlcXVlc3QgYm9keS4KICAzLiBJ
ZiBbSHR0cFJ1bGUuYm9keV1bZ29vZ2xlLmFwaS5IdHRwUnVsZS5ib2R5XSBpcyBvbWl0dGVk
LCB0aGVyZSBpcyBubyBIVFRQCiAgcmVxdWVzdCBib2R5LCBhbGwKICAgICBmaWVsZHMgYXJl
IHBhc3NlZCB2aWEgVVJMIHBhdGggYW5kIFVSTCBxdWVyeSBwYXJhbWV0ZXJzLgoKIFBhdGgg
dGVtcGxhdGUgc3ludGF4CgogICAgIFRlbXBsYXRlID0gIi8iIFNlZ21lbnRzIFsgVmVyYiBd
IDsKICAgICBTZWdtZW50cyA9IFNlZ21lbnQgeyAiLyIgU2VnbWVudCB9IDsKICAgICBTZWdt
ZW50ICA9ICIqIiB8ICIqKiIgfCBMSVRFUkFMIHwgVmFyaWFibGUgOwogICAgIFZhcmlhYmxl
ID0gInsiIEZpZWxkUGF0aCBbICI9IiBTZWdtZW50cyBdICJ9IiA7CiAgICAgRmllbGRQYXRo
ID0gSURFTlQgeyAiLiIgSURFTlQgfSA7CiAgICAgVmVyYiAgICAgPSAiOiIgTElURVJBTCA7
CgogVGhlIHN5bnRheCBgKmAgbWF0Y2hlcyBhIHNpbmdsZSBVUkwgcGF0aCBzZWdtZW50LiBU
aGUgc3ludGF4IGAqKmAgbWF0Y2hlcwogemVybyBvciBtb3JlIFVSTCBwYXRoIHNlZ21lbnRz
LCB3aGljaCBtdXN0IGJlIHRoZSBsYXN0IHBhcnQgb2YgdGhlIFVSTCBwYXRoCiBleGNlcHQg
dGhlIGBWZXJiYC4KCiBUaGUgc3ludGF4IGBWYXJpYWJsZWAgbWF0Y2hlcyBwYXJ0IG9mIHRo
ZSBVUkwgcGF0aCBhcyBzcGVjaWZpZWQgYnkgaXRzCiB0ZW1wbGF0ZS4gQSB2YXJpYWJsZSB0
ZW1wbGF0ZSBtdXN0IG5vdCBjb250YWluIG90aGVyIHZhcmlhYmxlcy4gSWYgYSB2YXJpYWJs
ZQogbWF0Y2hlcyBhIHNpbmdsZSBwYXRoIHNlZ21lbnQsIGl0cyB0ZW1wbGF0ZSBtYXkgYmUg
b21pdHRlZCwgZS5nLiBge3Zhcn1gCiBpcyBlcXVpdmFsZW50IHRvIGB7dmFyPSp9YC4KCiBU
aGUgc3ludGF4IGBMSVRFUkFMYCBtYXRjaGVzIGxpdGVyYWwgdGV4dCBpbiB0aGUgVVJMIHBh
dGguIElmIHRoZSBgTElURVJBTGAKIGNvbnRhaW5zIGFueSByZXNlcnZlZCBjaGFyYWN0ZXIs
IHN1Y2ggY2hhcmFjdGVycyBzaG91bGQgYmUgcGVyY2VudC1lbmNvZGVkCiBiZWZvcmUgdGhl
IG1hdGNoaW5nLgoKIElmIGEgdmFyaWFibGUgY29udGFpbnMgZXhhY3RseSBvbmUgcGF0aCBz
ZWdtZW50LCBzdWNoIGFzIGAie3Zhcn0iYCBvcgogYCJ7dmFyPSp9ImAsIHdoZW4gc3VjaCBh
IHZhcmlhYmxlIGlzIGV4cGFuZGVkIGludG8gYSBVUkwgcGF0aCBvbiB0aGUgY2xpZW50CiBz
aWRlLCBhbGwgY2hhcmFjdGVycyBleGNlcHQgYFstXy5+MC05YS16QS1aXWAgYXJlIHBlcmNl
bnQtZW5jb2RlZC4gVGhlCiBzZXJ2ZXIgc2lkZSBkb2VzIHRoZSByZXZlcnNlIGRlY29kaW5n
LiBTdWNoIHZhcmlhYmxlcyBzaG93IHVwIGluIHRoZQogW0Rpc2NvdmVyeQogRG9jdW1lbnRd
KGh0dHBzOi8vZGV2ZWxvcGVycy5nb29nbGUuY29tL2Rpc2NvdmVyeS92MS9yZWZlcmVuY2Uv
YXBpcykgYXMKIGB7dmFyfWAuCgogSWYgYSB2YXJpYWJsZSBjb250YWlucyBtdWx0aXBsZSBw
YXRoIHNlZ21lbnRzLCBzdWNoIGFzIGAie3Zhcj1mb28vKn0iYAogb3IgYCJ7dmFyPSoqfSJg
LCB3aGVuIHN1Y2ggYSB2YXJpYWJsZSBpcyBleHBhbmRlZCBpbnRvIGEgVVJMIHBhdGggb24g
dGhlCiBjbGllbnQgc2lkZSwgYWxsIGNoYXJhY3RlcnMgZXhjZXB0IGBbLV8ufi8wLTlhLXpB
LVpdYCBhcmUgcGVyY2VudC1lbmNvZGVkLgogVGhlIHNlcnZlciBzaWRlIGRvZXMgdGhlIHJl
dmVyc2UgZGVjb2RpbmcsIGV4Y2VwdCAiJTJGIiBhbmQgIiUyZiIgYXJlIGxlZnQKIHVuY2hh
bmdlZC4gU3VjaCB2YXJpYWJsZXMgc2hvdyB1cCBpbiB0aGUKIFtEaXNjb3ZlcnkKIERvY3Vt
ZW50XShodHRwczovL2RldmVsb3BlcnMuZ29vZ2xlLmNvbS9kaXNjb3ZlcnkvdjEvcmVmZXJl
bmNlL2FwaXMpIGFzCiBgeyt2YXJ9YC4KCiBVc2luZyBnUlBDIEFQSSBTZXJ2aWNlIENvbmZp
Z3VyYXRpb24KCiBnUlBDIEFQSSBTZXJ2aWNlIENvbmZpZ3VyYXRpb24gKHNlcnZpY2UgY29u
ZmlnKSBpcyBhIGNvbmZpZ3VyYXRpb24gbGFuZ3VhZ2UKIGZvciBjb25maWd1cmluZyBhIGdS
UEMgc2VydmljZSB0byBiZWNvbWUgYSB1c2VyLWZhY2luZyBwcm9kdWN0LiBUaGUKIHNlcnZp
Y2UgY29uZmlnIGlzIHNpbXBseSB0aGUgWUFNTCByZXByZXNlbnRhdGlvbiBvZiB0aGUgYGdv
b2dsZS5hcGkuU2VydmljZWAKIHByb3RvIG1lc3NhZ2UuCgogQXMgYW4gYWx0ZXJuYXRpdmUg
dG8gYW5ub3RhdGluZyB5b3VyIHByb3RvIGZpbGUsIHlvdSBjYW4gY29uZmlndXJlIGdSUEMK
IHRyYW5zY29kaW5nIGluIHlvdXIgc2VydmljZSBjb25maWcgWUFNTCBmaWxlcy4gWW91IGRv
IHRoaXMgYnkgc3BlY2lmeWluZyBhCiBgSHR0cFJ1bGVgIHRoYXQgbWFwcyB0aGUgZ1JQQyBt
ZXRob2QgdG8gYSBSRVNUIGVuZHBvaW50LCBhY2hpZXZpbmcgdGhlIHNhbWUKIGVmZmVjdCBh
cyB0aGUgcHJvdG8gYW5ub3RhdGlvbi4gVGhpcyBjYW4gYmUgcGFydGljdWxhcmx5IHVzZWZ1
bCBpZiB5b3UKIGhhdmUgYSBwcm90byB0aGF0IGlzIHJldXNlZCBpbiBtdWx0aXBsZSBzZXJ2
aWNlcy4gTm90ZSB0aGF0IGFueSB0cmFuc2NvZGluZwogc3BlY2lmaWVkIGluIHRoZSBzZXJ2
aWNlIGNvbmZpZyB3aWxsIG92ZXJyaWRlIGFueSBtYXRjaGluZyB0cmFuc2NvZGluZwogY29u
ZmlndXJhdGlvbiBpbiB0aGUgcHJvdG8uCgogVGhlIGZvbGxvd2luZyBleGFtcGxlIHNlbGVj
dHMgYSBnUlBDIG1ldGhvZCBhbmQgYXBwbGllcyBhbiBgSHR0cFJ1bGVgIHRvIGl0OgoKICAg
ICBodHRwOgogICAgICAgcnVsZXM6CiAgICAgICAgIC0gc2VsZWN0b3I6IGV4YW1wbGUudjEu
TWVzc2FnaW5nLkdldE1lc3NhZ2UKICAgICAgICAgICBnZXQ6IC92MS9tZXNzYWdlcy97bWVz
c2FnZV9pZH0ve3N1Yi5zdWJmaWVsZH0KCiBTcGVjaWFsIG5vdGVzCgogV2hlbiBnUlBDIFRy
YW5zY29kaW5nIGlzIHVzZWQgdG8gbWFwIGEgZ1JQQyB0byBKU09OIFJFU1QgZW5kcG9pbnRz
LCB0aGUKIHByb3RvIHRvIEpTT04gY29udmVyc2lvbiBtdXN0IGZvbGxvdyB0aGUgW3Byb3Rv
Mwogc3BlY2lmaWNhdGlvbl0oaHR0cHM6Ly9kZXZlbG9wZXJzLmdvb2dsZS5jb20vcHJvdG9j
b2wtYnVmZmVycy9kb2NzL3Byb3RvMyNqc29uKS4KCiBXaGlsZSB0aGUgc2luZ2xlIHNlZ21l
bnQgdmFyaWFibGUgZm9sbG93cyB0aGUgc2VtYW50aWNzIG9mCiBbUkZDIDY1NzBdKGh0dHBz
Oi8vdG9vbHMuaWV0Zi5vcmcvaHRtbC9yZmM2NTcwKSBTZWN0aW9uIDMuMi4yIFNpbXBsZSBT
dHJpbmcKIEV4cGFuc2lvbiwgdGhlIG11bHRpIHNlZ21lbnQgdmFyaWFibGUgKipkb2VzIG5v
dCoqIGZvbGxvdyBSRkMgNjU3MCBTZWN0aW9uCiAzLjIuMyBSZXNlcnZlZCBFeHBhbnNpb24u
IFRoZSByZWFzb24gaXMgdGhhdCB0aGUgUmVzZXJ2ZWQgRXhwYW5zaW9uCiBkb2VzIG5vdCBl
eHBhbmQgc3BlY2lhbCBjaGFyYWN0ZXJzIGxpa2UgYD9gIGFuZCBgI2AsIHdoaWNoIHdvdWxk
IGxlYWQKIHRvIGludmFsaWQgVVJMcy4gQXMgdGhlIHJlc3VsdCwgZ1JQQyBUcmFuc2NvZGlu
ZyB1c2VzIGEgY3VzdG9tIGVuY29kaW5nCiBmb3IgbXVsdGkgc2VnbWVudCB2YXJpYWJsZXMu
CgogVGhlIHBhdGggdmFyaWFibGVzICoqbXVzdCBub3QqKiByZWZlciB0byBhbnkgcmVwZWF0
ZWQgb3IgbWFwcGVkIGZpZWxkLAogYmVjYXVzZSBjbGllbnQgbGlicmFyaWVzIGFyZSBub3Qg
Y2FwYWJsZSBvZiBoYW5kbGluZyBzdWNoIHZhcmlhYmxlIGV4cGFuc2lvbi4KCiBUaGUgcGF0
aCB2YXJpYWJsZXMgKiptdXN0IG5vdCoqIGNhcHR1cmUgdGhlIGxlYWRpbmcgIi8iIGNoYXJh
Y3Rlci4gVGhlIHJlYXNvbgogaXMgdGhhdCB0aGUgbW9zdCBjb21tb24gdXNlIGNhc2UgInt2
YXJ9IiBkb2VzIG5vdCBjYXB0dXJlIHRoZSBsZWFkaW5nICIvIgogY2hhcmFjdGVyLiBGb3Ig
Y29uc2lzdGVuY3ksIGFsbCBwYXRoIHZhcmlhYmxlcyBtdXN0IHNoYXJlIHRoZSBzYW1lIGJl
aGF2aW9yLgoKIFJlcGVhdGVkIG1lc3NhZ2UgZmllbGRzIG11c3Qgbm90IGJlIG1hcHBlZCB0
byBVUkwgcXVlcnkgcGFyYW1ldGVycywgYmVjYXVzZQogbm8gY2xpZW50IGxpYnJhcnkgY2Fu
IHN1cHBvcnQgc3VjaCBjb21wbGljYXRlZCBtYXBwaW5nLgoKIElmIGFuIEFQSSBuZWVkcyB0
byB1c2UgYSBKU09OIGFycmF5IGZvciByZXF1ZXN0IG9yIHJlc3BvbnNlIGJvZHksIGl0IGNh
biBtYXAKIHRoZSByZXF1ZXN0IG9yIHJlc3BvbnNlIGJvZHkgdG8gYSByZXBlYXRlZCBmaWVs
ZC4gSG93ZXZlciwgc29tZSBnUlBDCiBUcmFuc2NvZGluZyBpbXBsZW1lbnRhdGlvbnMgbWF5
IG5vdCBzdXBwb3J0IHRoaXMgZmVhdHVyZS4KCgsKAwQBARIEsgIIEAqPAQoEBAECABIEtwIC
FhqAASBTZWxlY3RzIGEgbWV0aG9kIHRvIHdoaWNoIHRoaXMgcnVsZSBhcHBsaWVzLgoKIFJl
ZmVyIHRvIFtzZWxlY3Rvcl1bZ29vZ2xlLmFwaS5Eb2N1bWVudGF0aW9uUnVsZS5zZWxlY3Rv
cl0gZm9yIHN5bnRheAogZGV0YWlscy4KCg0KBQQBAgAFEgS3AgIICg0KBQQBAgABEgS3AgkR
Cg0KBQQBAgADEgS3AhQVCtABCgQEAQgAEga8AgLSAgMavwEgRGV0ZXJtaW5lcyB0aGUgVVJM
IHBhdHRlcm4gaXMgbWF0Y2hlZCBieSB0aGlzIHJ1bGVzLiBUaGlzIHBhdHRlcm4gY2FuIGJl
CiB1c2VkIHdpdGggYW55IG9mIHRoZSB7Z2V0fHB1dHxwb3N0fGRlbGV0ZXxwYXRjaH0gbWV0
aG9kcy4gQSBjdXN0b20gbWV0aG9kCiBjYW4gYmUgZGVmaW5lZCB1c2luZyB0aGUgJ2N1c3Rv
bScgZmllbGQuCgoNCgUEAQgAARIEvAIIDwpcCgQEAQIBEgS/AgQTGk4gTWFwcyB0byBIVFRQ
IEdFVC4gVXNlZCBmb3IgbGlzdGluZyBhbmQgZ2V0dGluZyBpbmZvcm1hdGlvbiBhYm91dAog
cmVzb3VyY2VzLgoKDQoFBAECAQUSBL8CBAoKDQoFBAECAQESBL8CCw4KDQoFBAECAQMSBL8C
ERIKQAoEBAECAhIEwgIEExoyIE1hcHMgdG8gSFRUUCBQVVQuIFVzZWQgZm9yIHJlcGxhY2lu
ZyBhIHJlc291cmNlLgoKDQoFBAECAgUSBMICBAoKDQoFBAECAgESBMICCw4KDQoFBAECAgMS
BMICERIKWAoEBAECAxIExQIEFBpKIE1hcHMgdG8gSFRUUCBQT1NULiBVc2VkIGZvciBjcmVh
dGluZyBhIHJlc291cmNlIG9yIHBlcmZvcm1pbmcgYW4gYWN0aW9uLgoKDQoFBAECAwUSBMUC
BAoKDQoFBAECAwESBMUCCw8KDQoFBAECAwMSBMUCEhMKQgoEBAECBBIEyAIEFho0IE1hcHMg
dG8gSFRUUCBERUxFVEUuIFVzZWQgZm9yIGRlbGV0aW5nIGEgcmVzb3VyY2UuCgoNCgUEAQIE
BRIEyAIECgoNCgUEAQIEARIEyAILEQoNCgUEAQIEAxIEyAIUFQpBCgQEAQIFEgTLAgQVGjMg
TWFwcyB0byBIVFRQIFBBVENILiBVc2VkIGZvciB1cGRhdGluZyBhIHJlc291cmNlLgoKDQoF
BAECBQUSBMsCBAoKDQoFBAECBQESBMsCCxAKDQoFBAECBQMSBMsCExQKmAIKBAQBAgYSBNEC
BCEaiQIgVGhlIGN1c3RvbSBwYXR0ZXJuIGlzIHVzZWQgZm9yIHNwZWNpZnlpbmcgYW4gSFRU
UCBtZXRob2QgdGhhdCBpcyBub3QKIGluY2x1ZGVkIGluIHRoZSBgcGF0dGVybmAgZmllbGQs
IHN1Y2ggYXMgSEVBRCwgb3IgIioiIHRvIGxlYXZlIHRoZQogSFRUUCBtZXRob2QgdW5zcGVj
aWZpZWQgZm9yIHRoaXMgcnVsZS4gVGhlIHdpbGQtY2FyZCBydWxlIGlzIHVzZWZ1bAogZm9y
IHNlcnZpY2VzIHRoYXQgcHJvdmlkZSBjb250ZW50IHRvIFdlYiAoSFRNTCkgY2xpZW50cy4K
Cg0KBQQBAgYGEgTRAgQVCg0KBQQBAgYBEgTRAhYcCg0KBQQBAgYDEgTRAh8gCsQCCgQEAQIH
EgTaAgISGrUCIFRoZSBuYW1lIG9mIHRoZSByZXF1ZXN0IGZpZWxkIHdob3NlIHZhbHVlIGlz
IG1hcHBlZCB0byB0aGUgSFRUUCByZXF1ZXN0CiBib2R5LCBvciBgKmAgZm9yIG1hcHBpbmcg
YWxsIHJlcXVlc3QgZmllbGRzIG5vdCBjYXB0dXJlZCBieSB0aGUgcGF0aAogcGF0dGVybiB0
byB0aGUgSFRUUCBib2R5LCBvciBvbWl0dGVkIGZvciBub3QgaGF2aW5nIGFueSBIVFRQIHJl
cXVlc3QgYm9keS4KCiBOT1RFOiB0aGUgcmVmZXJyZWQgZmllbGQgbXVzdCBiZSBwcmVzZW50
IGF0IHRoZSB0b3AtbGV2ZWwgb2YgdGhlIHJlcXVlc3QKIG1lc3NhZ2UgdHlwZS4KCg0KBQQB
AgcFEgTaAgIICg0KBQQBAgcBEgTaAgkNCg0KBQQBAgcDEgTaAhARCpkCCgQEAQIIEgTiAgIc
GooCIE9wdGlvbmFsLiBUaGUgbmFtZSBvZiB0aGUgcmVzcG9uc2UgZmllbGQgd2hvc2UgdmFs
dWUgaXMgbWFwcGVkIHRvIHRoZSBIVFRQCiByZXNwb25zZSBib2R5LiBXaGVuIG9taXR0ZWQs
IHRoZSBlbnRpcmUgcmVzcG9uc2UgbWVzc2FnZSB3aWxsIGJlIHVzZWQKIGFzIHRoZSBIVFRQ
IHJlc3BvbnNlIGJvZHkuCgogTk9URTogVGhlIHJlZmVycmVkIGZpZWxkIG11c3QgYmUgcHJl
c2VudCBhdCB0aGUgdG9wLWxldmVsIG9mIHRoZSByZXNwb25zZQogbWVzc2FnZSB0eXBlLgoK
DQoFBAECCAUSBOICAggKDQoFBAECCAESBOICCRYKDQoFBAECCAMSBOICGRsKuwEKBAQBAgkS
BOcCAi0arAEgQWRkaXRpb25hbCBIVFRQIGJpbmRpbmdzIGZvciB0aGUgc2VsZWN0b3IuIE5l
c3RlZCBiaW5kaW5ncyBtdXN0CiBub3QgY29udGFpbiBhbiBgYWRkaXRpb25hbF9iaW5kaW5n
c2AgZmllbGQgdGhlbXNlbHZlcyAodGhhdCBpcywKIHRoZSBuZXN0aW5nIG1heSBvbmx5IGJl
IG9uZSBsZXZlbCBkZWVwKS4KCg0KBQQBAgkEEgTnAgIKCg0KBQQBAgkGEgTnAgsTCg0KBQQB
AgkBEgTnAhQnCg0KBQQBAgkDEgTnAiosCkcKAgQCEgbrAgDxAgEaOSBBIGN1c3RvbSBwYXR0
ZXJuIGlzIHVzZWQgZm9yIGRlZmluaW5nIGN1c3RvbSBIVFRQIHZlcmIuCgoLCgMEAgESBOsC
CBkKMgoEBAICABIE7QICEhokIFRoZSBuYW1lIG9mIHRoaXMgY3VzdG9tIEhUVFAgdmVyYi4K
Cg0KBQQCAgAFEgTtAgIICg0KBQQCAgABEgTtAgkNCg0KBQQCAgADEgTtAhARCjUKBAQCAgES
BPACAhIaJyBUaGUgcGF0aCBtYXRjaGVkIGJ5IHRoaXMgY3VzdG9tIHZlcmIuCgoNCgUEAgIB
BRIE8AICCAoNCgUEAgIBARIE8AIJDQoNCgUEAgIBAxIE8AIQEWIGcHJvdG8z
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Http::Http ===
    # Fields for Http
    # Field: rules Type: 11 (.google.api.HttpRule)
    # Field: fully_decode_reserved_expansion Type: 8 ()

# === Message: Google::Api::Http::HttpRule ===
    # Fields for HttpRule
    # Field: selector Type: 9 ()
    # Field: get Type: 9 ()
    # Field: put Type: 9 ()
    # Field: post Type: 9 ()
    # Field: delete Type: 9 ()
    # Field: patch Type: 9 ()
    # Field: custom Type: 11 (.google.api.CustomHttpPattern)
    # Field: body Type: 9 ()
    # Field: response_body Type: 9 ()
    # Field: additional_bindings Type: 11 (.google.api.HttpRule)

# === Message: Google::Api::Http::CustomHttpPattern ===
    # Fields for CustomHttpPattern
    # Field: kind Type: 9 ()
    # Field: path Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Http - Compiled Protocol Buffers messages for google/api/http.proto

=head1 SYNOPSIS

    use Google::Api::Http;

    my $msg = Google::Api::Http::Http->new({
        rules => $rules,
        fully_decode_reserved_expansion => $fully_decode_reserved_expansion,
    });

    # Read or update a field
    my $val = $msg->rules();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Http::Http->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/http.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Http::Http

Defines the HTTP configuration for an API service. It contains a list of
[HttpRule][google.api.HttpRule], each specifying the mapping of an RPC method
to one or more HTTP REST API methods.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->rules() >> / C<< $msg->rules($value) >>

Type: C<Message> (L<Google::Api::Http::HttpRule>)

A list of HTTP configuration rules that apply to individual API methods.

B<NOTE:> All service configuration rules follow "last one wins" order.

=item * C<< $msg->fully_decode_reserved_expansion() >> / C<< $msg->fully_decode_reserved_expansion($value) >>

Type: C<Bool>

When set to true, URL path parameters will be fully URI-decoded except in
cases of single segment matches in reserved expansion, where "%2F" will be
left encoded.

The default behavior is to not decode RFC 6570 reserved characters in multi
segment matches.

=back

=head2 Google::Api::Http::HttpRule

gRPC Transcoding

gRPC Transcoding is a feature for mapping between a gRPC method and one or
more HTTP REST endpoints. It allows developers to build a single API service
that supports both gRPC APIs and REST APIs. Many systems, including [Google
APIs](https://github.com/googleapis/googleapis),
[Cloud Endpoints](https://cloud.google.com/endpoints), [gRPC
Gateway](https://github.com/grpc-ecosystem/grpc-gateway),
and [Envoy](https://github.com/envoyproxy/envoy) proxy support this feature
and use it for large scale production services.

`HttpRule` defines the schema of the gRPC/REST mapping. The mapping specifies
how different portions of the gRPC request message are mapped to the URL
path, URL query parameters, and HTTP request body. It also controls how the
gRPC response message is mapped to the HTTP response body. `HttpRule` is
typically specified as an `google.api.http` annotation on the gRPC method.

Each mapping specifies a URL path template and an HTTP method. The path
template may refer to one or more fields in the gRPC request message, as long
as each field is a non-repeated field with a primitive (non-message) type.
The path template controls how fields of the request message are mapped to
the URL path.

Example:

    service Messaging {
      rpc GetMessage(GetMessageRequest) returns (Message) {
        option (google.api.http) = {
            get: "/v1/{name=messages/*}"
        };
      }
    }
    message GetMessageRequest {
      string name = 1; // Mapped to URL path.
    }
    message Message {
      string text = 1; // The resource content.
    }

This enables an HTTP REST to gRPC mapping as below:

- HTTP: `GET /v1/messages/123456`
- gRPC: `GetMessage(name: "messages/123456")`

Any fields in the request message which are not bound by the path template
automatically become HTTP query parameters if there is no HTTP request body.
For example:

    service Messaging {
      rpc GetMessage(GetMessageRequest) returns (Message) {
        option (google.api.http) = {
            get:"/v1/messages/{message_id}"
        };
      }
    }
    message GetMessageRequest {
      message SubMessage {
        string subfield = 1;
      }
      string message_id = 1; // Mapped to URL path.
      int64 revision = 2;    // Mapped to URL query parameter `revision`.
      SubMessage sub = 3;    // Mapped to URL query parameter `sub.subfield`.
    }

This enables a HTTP JSON to RPC mapping as below:

- HTTP: `GET /v1/messages/123456?revision=2&sub.subfield=foo`
- gRPC: `GetMessage(message_id: "123456" revision: 2 sub:
SubMessage(subfield: "foo"))`

Note that fields which are mapped to URL query parameters must have a
primitive type or a repeated primitive type or a non-repeated message type.
In the case of a repeated type, the parameter can be repeated in the URL
as `...?param=A&param=B`. In the case of a message type, each field of the
message is mapped to a separate parameter, such as
`...?foo.a=A&foo.b=B&foo.c=C`.

For HTTP methods that allow a request body, the `body` field
specifies the mapping. Consider a REST update method on the
message resource collection:

    service Messaging {
      rpc UpdateMessage(UpdateMessageRequest) returns (Message) {
        option (google.api.http) = {
          patch: "/v1/messages/{message_id}"
          body: "message"
        };
      }
    }
    message UpdateMessageRequest {
      string message_id = 1; // mapped to the URL
      Message message = 2;   // mapped to the body
    }

The following HTTP JSON to RPC mapping is enabled, where the
representation of the JSON in the request body is determined by
protos JSON encoding:

- HTTP: `PATCH /v1/messages/123456 { "text": "Hi!" }`
- gRPC: `UpdateMessage(message_id: "123456" message { text: "Hi!" })`

The special name `*` can be used in the body mapping to define that
every field not bound by the path template should be mapped to the
request body.  This enables the following alternative definition of
the update method:

    service Messaging {
      rpc UpdateMessage(Message) returns (Message) {
        option (google.api.http) = {
          patch: "/v1/messages/{message_id}"
          body: "*"
        };
      }
    }
    message Message {
      string message_id = 1;
      string text = 2;
    }


The following HTTP JSON to RPC mapping is enabled:

- HTTP: `PATCH /v1/messages/123456 { "text": "Hi!" }`
- gRPC: `UpdateMessage(message_id: "123456" text: "Hi!")`

Note that when using `*` in the body mapping, it is not possible to
have HTTP parameters, as all fields not bound by the path end in
the body. This makes this option more rarely used in practice when
defining REST APIs. The common usage of `*` is in custom methods
which don't use the URL at all for transferring data.

It is possible to define multiple HTTP methods for one RPC by using
the `additional_bindings` option. Example:

    service Messaging {
      rpc GetMessage(GetMessageRequest) returns (Message) {
        option (google.api.http) = {
          get: "/v1/messages/{message_id}"
          additional_bindings {
            get: "/v1/users/{user_id}/messages/{message_id}"
          }
        };
      }
    }
    message GetMessageRequest {
      string message_id = 1;
      string user_id = 2;
    }

This enables the following two alternative HTTP JSON to RPC mappings:

- HTTP: `GET /v1/messages/123456`
- gRPC: `GetMessage(message_id: "123456")`

- HTTP: `GET /v1/users/me/messages/123456`
- gRPC: `GetMessage(user_id: "me" message_id: "123456")`

Rules for HTTP mapping

1. Leaf request fields (recursive expansion nested messages in the request
   message) are classified into three categories:
   - Fields referred by the path template. They are passed via the URL path.
   - Fields referred by the [HttpRule.body][google.api.HttpRule.body]. They
   are passed via the HTTP
     request body.
   - All other fields are passed via the URL query parameters, and the
     parameter name is the field path in the request message. A repeated
     field can be represented as multiple query parameters under the same
     name.
 2. If [HttpRule.body][google.api.HttpRule.body] is "*", there is no URL
 query parameter, all fields
    are passed via URL path and HTTP request body.
 3. If [HttpRule.body][google.api.HttpRule.body] is omitted, there is no HTTP
 request body, all
    fields are passed via URL path and URL query parameters.

Path template syntax

    Template = "/" Segments [ Verb ] ;
    Segments = Segment { "/" Segment } ;
    Segment  = "*" | "**" | LITERAL | Variable ;
    Variable = "{" FieldPath [ "=" Segments ] "}" ;
    FieldPath = IDENT { "." IDENT } ;
    Verb     = ":" LITERAL ;

The syntax `*` matches a single URL path segment. The syntax `**` matches
zero or more URL path segments, which must be the last part of the URL path
except the `Verb`.

The syntax `Variable` matches part of the URL path as specified by its
template. A variable template must not contain other variables. If a variable
matches a single path segment, its template may be omitted, e.g. `{var}`
is equivalent to `{var=*}`.

The syntax `LITERAL` matches literal text in the URL path. If the `LITERAL`
contains any reserved character, such characters should be percent-encoded
before the matching.

If a variable contains exactly one path segment, such as `"{var}"` or
`"{var=*}"`, when such a variable is expanded into a URL path on the client
side, all characters except `[-_.~0-9a-zA-Z]` are percent-encoded. The
server side does the reverse decoding. Such variables show up in the
[Discovery
Document](https://developers.google.com/discovery/v1/reference/apis) as
`{var}`.

If a variable contains multiple path segments, such as `"{var=foo/*}"`
or `"{var=**}"`, when such a variable is expanded into a URL path on the
client side, all characters except `[-_.~/0-9a-zA-Z]` are percent-encoded.
The server side does the reverse decoding, except "%2F" and "%2f" are left
unchanged. Such variables show up in the
[Discovery
Document](https://developers.google.com/discovery/v1/reference/apis) as
`{+var}`.

Using gRPC API Service Configuration

gRPC API Service Configuration (service config) is a configuration language
for configuring a gRPC service to become a user-facing product. The
service config is simply the YAML representation of the `google.api.Service`
proto message.

As an alternative to annotating your proto file, you can configure gRPC
transcoding in your service config YAML files. You do this by specifying a
`HttpRule` that maps the gRPC method to a REST endpoint, achieving the same
effect as the proto annotation. This can be particularly useful if you
have a proto that is reused in multiple services. Note that any transcoding
specified in the service config will override any matching transcoding
configuration in the proto.

The following example selects a gRPC method and applies an `HttpRule` to it:

    http:
      rules:
        - selector: example.v1.Messaging.GetMessage
          get: /v1/messages/{message_id}/{sub.subfield}

Special notes

When gRPC Transcoding is used to map a gRPC to JSON REST endpoints, the
proto to JSON conversion must follow the [proto3
specification](https://developers.google.com/protocol-buffers/docs/proto3#json).

While the single segment variable follows the semantics of
[RFC 6570](https://tools.ietf.org/html/rfc6570) Section 3.2.2 Simple String
Expansion, the multi segment variable B<does not> follow RFC 6570 Section
3.2.3 Reserved Expansion. The reason is that the Reserved Expansion
does not expand special characters like `?` and `#`, which would lead
to invalid URLs. As the result, gRPC Transcoding uses a custom encoding
for multi segment variables.

The path variables B<must not> refer to any repeated or mapped field,
because client libraries are not capable of handling such variable expansion.

The path variables B<must not> capture the leading "/" character. The reason
is that the most common use case "{var}" does not capture the leading "/"
character. For consistency, all path variables must share the same behavior.

Repeated message fields must not be mapped to URL query parameters, because
no client library can support such complicated mapping.

If an API needs to use a JSON array for request or response body, it can map
the request or response body to a repeated field. However, some gRPC
Transcoding implementations may not support this feature.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->selector() >> / C<< $msg->selector($value) >>

Type: C<String>

Selects a method to which this rule applies.

Refer to [selector][google.api.DocumentationRule.selector] for syntax
details.

=item * C<< $msg->get() >> / C<< $msg->get($value) >>

Type: C<String>

Maps to HTTP GET. Used for listing and getting information about
resources.

=item * C<< $msg->put() >> / C<< $msg->put($value) >>

Type: C<String>

Maps to HTTP PUT. Used for replacing a resource.

=item * C<< $msg->post() >> / C<< $msg->post($value) >>

Type: C<String>

Maps to HTTP POST. Used for creating a resource or performing an action.

=item * C<< $msg->delete() >> / C<< $msg->delete($value) >>

Type: C<String>

Maps to HTTP DELETE. Used for deleting a resource.

=item * C<< $msg->patch() >> / C<< $msg->patch($value) >>

Type: C<String>

Maps to HTTP PATCH. Used for updating a resource.

=item * C<< $msg->custom() >> / C<< $msg->custom($value) >>

Type: C<Message> (L<Google::Api::Http::CustomHttpPattern>)

The custom pattern is used for specifying an HTTP method that is not
included in the `pattern` field, such as HEAD, or "*" to leave the
HTTP method unspecified for this rule. The wild-card rule is useful
for services that provide content to Web (HTML) clients.

=item * C<< $msg->body() >> / C<< $msg->body($value) >>

Type: C<String>

The name of the request field whose value is mapped to the HTTP request
body, or `*` for mapping all request fields not captured by the path
pattern to the HTTP body, or omitted for not having any HTTP request body.

NOTE: the referred field must be present at the top-level of the request
message type.

=item * C<< $msg->response_body() >> / C<< $msg->response_body($value) >>

Type: C<String>

Optional. The name of the response field whose value is mapped to the HTTP
response body. When omitted, the entire response message will be used
as the HTTP response body.

NOTE: The referred field must be present at the top-level of the response
message type.

=item * C<< $msg->additional_bindings() >> / C<< $msg->additional_bindings($value) >>

Type: C<Message> (L<Google::Api::Http::HttpRule>)

Additional HTTP bindings for the selector. Nested bindings must
not contain an `additional_bindings` field themselves (that is,
the nesting may only be one level deep).

=back

=head2 Google::Api::Http::CustomHttpPattern

A custom pattern is used for defining custom HTTP verb.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->kind() >> / C<< $msg->kind($value) >>

Type: C<String>

The name of this custom HTTP verb.

=item * C<< $msg->path() >> / C<< $msg->path($value) >>

Type: C<String>

The path matched by this custom verb.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Http::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

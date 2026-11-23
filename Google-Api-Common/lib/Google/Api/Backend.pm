package Google::Api::Backend;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
Chhnb29nbGUvYXBpL2JhY2tlbmQucHJvdG8SCmdvb2dsZS5hcGkiOAoHQmFja2VuZBItCgVy
dWxlcxgBIAMoCzIXLmdvb2dsZS5hcGkuQmFja2VuZFJ1bGVSBXJ1bGVzIoAGCgtCYWNrZW5k
UnVsZRIaCghzZWxlY3RvchgBIAEoCVIIc2VsZWN0b3ISGAoHYWRkcmVzcxgCIAEoCVIHYWRk
cmVzcxIaCghkZWFkbGluZRgDIAEoAVIIZGVhZGxpbmUSJQoMbWluX2RlYWRsaW5lGAQgASgB
QgIYAVILbWluRGVhZGxpbmUSLQoSb3BlcmF0aW9uX2RlYWRsaW5lGAUgASgBUhFvcGVyYXRp
b25EZWFkbGluZRJSChBwYXRoX3RyYW5zbGF0aW9uGAYgASgOMicuZ29vZ2xlLmFwaS5CYWNr
ZW5kUnVsZS5QYXRoVHJhbnNsYXRpb25SD3BhdGhUcmFuc2xhdGlvbhIjCgxqd3RfYXVkaWVu
Y2UYByABKAlIAFILand0QXVkaWVuY2USIwoMZGlzYWJsZV9hdXRoGAggASgISABSC2Rpc2Fi
bGVBdXRoEhoKCHByb3RvY29sGAkgASgJUghwcm90b2NvbBJ6Ch1vdmVycmlkZXNfYnlfcmVx
dWVzdF9wcm90b2NvbBgKIAMoCzI3Lmdvb2dsZS5hcGkuQmFja2VuZFJ1bGUuT3ZlcnJpZGVz
QnlSZXF1ZXN0UHJvdG9jb2xFbnRyeVIab3ZlcnJpZGVzQnlSZXF1ZXN0UHJvdG9jb2wSMgoV
bG9hZF9iYWxhbmNpbmdfcG9saWN5GAsgASgJUhNsb2FkQmFsYW5jaW5nUG9saWN5GmYKH092
ZXJyaWRlc0J5UmVxdWVzdFByb3RvY29sRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSLQoFdmFs
dWUYAiABKAsyFy5nb29nbGUuYXBpLkJhY2tlbmRSdWxlUgV2YWx1ZToCOAEiZQoPUGF0aFRy
YW5zbGF0aW9uEiAKHFBBVEhfVFJBTlNMQVRJT05fVU5TUEVDSUZJRUQQABIUChBDT05TVEFO
VF9BRERSRVNTEAESGgoWQVBQRU5EX1BBVEhfVE9fQUREUkVTUxACQhAKDmF1dGhlbnRpY2F0
aW9uQm4KDmNvbS5nb29nbGUuYXBpQgxCYWNrZW5kUHJvdG9QAVpFZ29vZ2xlLmdvbGFuZy5v
cmcvZ2VucHJvdG8vZ29vZ2xlYXBpcy9hcGkvc2VydmljZWNvbmZpZztzZXJ2aWNlY29uZmln
ogIER0FQSUq4OAoHEgUOAMMBAQq8BAoBDBIDDgASMrEEIENvcHlyaWdodCAyMDI2IEdvb2ds
ZSBMTEMKCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4w
ICh0aGUgIkxpY2Vuc2UiKTsKIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGlu
IGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS4KIFlvdSBtYXkgb2J0YWluIGEgY29weSBv
ZiB0aGUgTGljZW5zZSBhdAoKICAgICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMv
TElDRU5TRS0yLjAKCiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3IgYWdy
ZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlCiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGlj
ZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiAiQVMgSVMiIEJBU0lTLAogV0lUSE9VVCBXQVJS
QU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGlt
cGxpZWQuCiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBnb3Zl
cm5pbmcgcGVybWlzc2lvbnMgYW5kCiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5zZS4K
CggKAQISAxAAEwoICgEIEgMSAFwKCQoCCAsSAxIAXAoICgEIEgMTACIKCQoCCAoSAxMAIgoI
CgEIEgMUAC0KCQoCCAgSAxQALQoICgEIEgMVACcKCQoCCAESAxUAJwoICgEIEgMWACIKCQoC
CCQSAxYAIgpICgIEABIEGQAeARo8IGBCYWNrZW5kYCBkZWZpbmVzIHRoZSBiYWNrZW5kIGNv
bmZpZ3VyYXRpb24gZm9yIGEgc2VydmljZS4KCgoKAwQAARIDGQgPCpsBCgQEAAIAEgMdAiEa
jQEgQSBsaXN0IG9mIEFQSSBiYWNrZW5kIHJ1bGVzIHRoYXQgYXBwbHkgdG8gaW5kaXZpZHVh
bCBBUEkgbWV0aG9kcy4KCiAqKk5PVEU6KiogQWxsIHNlcnZpY2UgY29uZmlndXJhdGlvbiBy
dWxlcyBmb2xsb3cgImxhc3Qgb25lIHdpbnMiIG9yZGVyLgoKDAoFBAACAAQSAx0CCgoMCgUE
AAIABhIDHQsWCgwKBQQAAgABEgMdFxwKDAoFBAACAAMSAx0fIApTCgIEARIFIQDDAQEaRiBB
IGJhY2tlbmQgcnVsZSBwcm92aWRlcyBjb25maWd1cmF0aW9uIGZvciBhbiBpbmRpdmlkdWFs
IEFQSSBlbGVtZW50LgoKCgoDBAEBEgMhCBMKzQIKBAQBBAASBCkCWQMavgIgUGF0aCBUcmFu
c2xhdGlvbiBzcGVjaWZpZXMgaG93IHRvIGNvbWJpbmUgdGhlIGJhY2tlbmQgYWRkcmVzcyB3
aXRoIHRoZQogcmVxdWVzdCBwYXRoIGluIG9yZGVyIHRvIHByb2R1Y2UgdGhlIGFwcHJvcHJp
YXRlIGZvcndhcmRpbmcgVVJMIGZvciB0aGUKIHJlcXVlc3QuCgogUGF0aCBUcmFuc2xhdGlv
biBpcyBhcHBsaWNhYmxlIG9ubHkgdG8gSFRUUC1iYXNlZCBiYWNrZW5kcy4gQmFja2VuZHMg
d2hpY2gKIGRvIG5vdCBhY2NlcHQgcmVxdWVzdHMgb3ZlciBIVFRQL0hUVFBTIHNob3VsZCBs
ZWF2ZSBgcGF0aF90cmFuc2xhdGlvbmAKIHVuc3BlY2lmaWVkLgoKDAoFBAEEAAESAykHFgoN
CgYEAQQAAgASAyoEJQoOCgcEAQQAAgABEgMqBCAKDgoHBAEEAAIAAhIDKiMkCpUHCgYEAQQA
AgESA0MEGRqFByBVc2UgdGhlIGJhY2tlbmQgYWRkcmVzcyBhcy1pcywgd2l0aCBubyBtb2Rp
ZmljYXRpb24gdG8gdGhlIHBhdGguIElmIHRoZQogVVJMIHBhdHRlcm4gY29udGFpbnMgdmFy
aWFibGVzLCB0aGUgdmFyaWFibGUgbmFtZXMgYW5kIHZhbHVlcyB3aWxsIGJlCiBhcHBlbmRl
ZCB0byB0aGUgcXVlcnkgc3RyaW5nLiBJZiBhIHF1ZXJ5IHN0cmluZyBwYXJhbWV0ZXIgYW5k
IGEgVVJMCiBwYXR0ZXJuIHZhcmlhYmxlIGhhdmUgdGhlIHNhbWUgbmFtZSwgdGhpcyBtYXkg
cmVzdWx0IGluIGR1cGxpY2F0ZSBrZXlzIGluCiB0aGUgcXVlcnkgc3RyaW5nLgoKICMgRXhh
bXBsZXMKCiBHaXZlbiB0aGUgZm9sbG93aW5nIG9wZXJhdGlvbiBjb25maWc6CgogICAgIE1l
dGhvZCBwYXRoOiAgICAgICAgL2FwaS9jb21wYW55L3tjaWR9L3VzZXIve3VpZH0KICAgICBC
YWNrZW5kIGFkZHJlc3M6ICAgIGh0dHBzOi8vZXhhbXBsZS5jbG91ZGZ1bmN0aW9ucy5uZXQv
Z2V0VXNlcgoKIFJlcXVlc3RzIHRvIHRoZSBmb2xsb3dpbmcgcmVxdWVzdCBwYXRocyB3aWxs
IGNhbGwgdGhlIGJhY2tlbmQgYXQgdGhlCiB0cmFuc2xhdGVkIHBhdGg6CgogICAgIFJlcXVl
c3QgcGF0aDogL2FwaS9jb21wYW55L3dpZGdldHdvcmtzL3VzZXIvam9obmRvZQogICAgIFRy
YW5zbGF0ZWQ6CiAgICAgaHR0cHM6Ly9leGFtcGxlLmNsb3VkZnVuY3Rpb25zLm5ldC9nZXRV
c2VyP2NpZD13aWRnZXR3b3JrcyZ1aWQ9am9obmRvZQoKICAgICBSZXF1ZXN0IHBhdGg6IC9h
cGkvY29tcGFueS93aWRnZXR3b3Jrcy91c2VyL2pvaG5kb2U/dGltZXpvbmU9RVNUCiAgICAg
VHJhbnNsYXRlZDoKICAgICBodHRwczovL2V4YW1wbGUuY2xvdWRmdW5jdGlvbnMubmV0L2dl
dFVzZXI/dGltZXpvbmU9RVNUJmNpZD13aWRnZXR3b3JrcyZ1aWQ9am9obmRvZQoKDgoHBAEE
AAIBARIDQwQUCg4KBwQBBAACAQISA0MXGAqCBQoGBAEEAAICEgNYBB8a8gQgVGhlIHJlcXVl
c3QgcGF0aCB3aWxsIGJlIGFwcGVuZGVkIHRvIHRoZSBiYWNrZW5kIGFkZHJlc3MuCgogIyBF
eGFtcGxlcwoKIEdpdmVuIHRoZSBmb2xsb3dpbmcgb3BlcmF0aW9uIGNvbmZpZzoKCiAgICAg
TWV0aG9kIHBhdGg6ICAgICAgICAvYXBpL2NvbXBhbnkve2NpZH0vdXNlci97dWlkfQogICAg
IEJhY2tlbmQgYWRkcmVzczogICAgaHR0cHM6Ly9leGFtcGxlLmFwcHNwb3QuY29tCgogUmVx
dWVzdHMgdG8gdGhlIGZvbGxvd2luZyByZXF1ZXN0IHBhdGhzIHdpbGwgY2FsbCB0aGUgYmFj
a2VuZCBhdCB0aGUKIHRyYW5zbGF0ZWQgcGF0aDoKCiAgICAgUmVxdWVzdCBwYXRoOiAvYXBp
L2NvbXBhbnkvd2lkZ2V0d29ya3MvdXNlci9qb2huZG9lCiAgICAgVHJhbnNsYXRlZDoKICAg
ICBodHRwczovL2V4YW1wbGUuYXBwc3BvdC5jb20vYXBpL2NvbXBhbnkvd2lkZ2V0d29ya3Mv
dXNlci9qb2huZG9lCgogICAgIFJlcXVlc3QgcGF0aDogL2FwaS9jb21wYW55L3dpZGdldHdv
cmtzL3VzZXIvam9obmRvZT90aW1lem9uZT1FU1QKICAgICBUcmFuc2xhdGVkOgogICAgIGh0
dHBzOi8vZXhhbXBsZS5hcHBzcG90LmNvbS9hcGkvY29tcGFueS93aWRnZXR3b3Jrcy91c2Vy
L2pvaG5kb2U/dGltZXpvbmU9RVNUCgoOCgcEAQQAAgIBEgNYBBoKDgoHBAEEAAICAhIDWB0e
CpEBCgQEAQIAEgNfAhYagwEgU2VsZWN0cyB0aGUgbWV0aG9kcyB0byB3aGljaCB0aGlzIHJ1
bGUgYXBwbGllcy4KCiBSZWZlciB0byBbc2VsZWN0b3JdW2dvb2dsZS5hcGkuRG9jdW1lbnRh
dGlvblJ1bGUuc2VsZWN0b3JdIGZvciBzeW50YXgKIGRldGFpbHMuCgoMCgUEAQIABRIDXwII
CgwKBQQBAgABEgNfCREKDAoFBAECAAMSA18UFQqZBQoEBAECARIDdQIVGosFIFRoZSBhZGRy
ZXNzIG9mIHRoZSBBUEkgYmFja2VuZC4KCiBUaGUgc2NoZW1lIGlzIHVzZWQgdG8gZGV0ZXJt
aW5lIHRoZSBiYWNrZW5kIHByb3RvY29sIGFuZCBzZWN1cml0eS4KIFRoZSBmb2xsb3dpbmcg
c2NoZW1lcyBhcmUgYWNjZXB0ZWQ6CgogICAgU0NIRU1FICAgICAgICBQUk9UT0NPTCAgICBT
RUNVUklUWQogICAgaHR0cDovLyAgICAgICBIVFRQICAgICAgICBOb25lCiAgICBodHRwczov
LyAgICAgIEhUVFAgICAgICAgIFRMUwogICAgZ3JwYzovLyAgICAgICBnUlBDICAgICAgICBO
b25lCiAgICBncnBjczovLyAgICAgIGdSUEMgICAgICAgIFRMUwoKIEl0IGlzIHJlY29tbWVu
ZGVkIHRvIGV4cGxpY2l0bHkgaW5jbHVkZSBhIHNjaGVtZS4gTGVhdmluZyBvdXQgdGhlIHNj
aGVtZQogbWF5IGNhdXNlIGNvbnN0cmFzdGluZyBiZWhhdmlvcnMgYWNyb3NzIHBsYXRmb3Jt
cy4KCiBJZiB0aGUgcG9ydCBpcyB1bnNwZWNpZmllZCwgdGhlIGRlZmF1bHQgaXM6CiAtIDgw
IGZvciBzY2hlbWVzIHdpdGhvdXQgVExTCiAtIDQ0MyBmb3Igc2NoZW1lcyB3aXRoIFRMUwoK
IEZvciBIVFRQIGJhY2tlbmRzLCB1c2UgW3Byb3RvY29sXVtnb29nbGUuYXBpLkJhY2tlbmRS
dWxlLnByb3RvY29sXQogdG8gc3BlY2lmeSB0aGUgcHJvdG9jb2wgdmVyc2lvbi4KCgwKBQQB
AgEFEgN1AggKDAoFBAECAQESA3UJEAoMCgUEAQIBAxIDdRMUCpoBCgQEAQICEgN5AhYajAEg
VGhlIG51bWJlciBvZiBzZWNvbmRzIHRvIHdhaXQgZm9yIGEgcmVzcG9uc2UgZnJvbSBhIHJl
cXVlc3QuIFRoZSBkZWZhdWx0CiB2YXJpZXMgYmFzZWQgb24gdGhlIHJlcXVlc3QgcHJvdG9j
b2wgYW5kIGRlcGxveW1lbnQgZW52aXJvbm1lbnQuCgoMCgUEAQICBRIDeQIICgwKBQQBAgIB
EgN5CREKDAoFBAECAgMSA3kUFQomCgQEAQIDEgN8Ai4aGSBEZXByZWNhdGVkLCBkbyBub3Qg
dXNlLgoKDAoFBAECAwUSA3wCCAoMCgUEAQIDARIDfAkVCgwKBQQBAgMDEgN8GBkKDAoFBAEC
AwgSA3waLQoNCgYEAQIDCAMSA3wbLAp6CgQEAQIEEgSAAQIgGmwgVGhlIG51bWJlciBvZiBz
ZWNvbmRzIHRvIHdhaXQgZm9yIHRoZSBjb21wbGV0aW9uIG9mIGEgbG9uZyBydW5uaW5nCiBv
cGVyYXRpb24uIFRoZSBkZWZhdWx0IGlzIG5vIGRlYWRsaW5lLgoKDQoFBAECBAUSBIABAggK
DQoFBAECBAESBIABCRsKDQoFBAECBAMSBIABHh8K+wEKBAQBAgUSBIYBAica7AEgUGF0aCB0
cmFuc2xhdGlvbiBzcGVjaWZpZXMgaG93IHRvIGNvbWJpbmUgdGhlIGJhY2tlbmQgYWRkcmVz
cyB3aXRoIHRoZQogcmVxdWVzdCBwYXRoIGluIG9yZGVyIHRvIHByb2R1Y2UgdGhlIGFwcHJv
cHJpYXRlIGZvcndhcmRpbmcgVVJMIGZvciB0aGUKIHJlcXVlc3QuIFNlZSBbUGF0aFRyYW5z
bGF0aW9uXVtnb29nbGUuYXBpLkJhY2tlbmRSdWxlLlBhdGhUcmFuc2xhdGlvbl0gZm9yCiBt
b3JlIGRldGFpbHMuCgoNCgUEAQIFBhIEhgECEQoNCgUEAQIFARIEhgESIgoNCgUEAQIFAxIE
hgElJgrABAoEBAEIABIGlgECoQEDGq8EIEF1dGhlbnRpY2F0aW9uIHNldHRpbmdzIHVzZWQg
YnkgdGhlIGJhY2tlbmQuCgogVGhlc2UgYXJlIHR5cGljYWxseSB1c2VkIHRvIHByb3ZpZGUg
c2VydmljZSBtYW5hZ2VtZW50IGZ1bmN0aW9uYWxpdHkgdG8KIGEgYmFja2VuZCBzZXJ2ZWQg
b24gYSBwdWJsaWNseS1yb3V0YWJsZSBVUkwuIFRoZSBgYXV0aGVudGljYXRpb25gCiBkZXRh
aWxzIHNob3VsZCBtYXRjaCB0aGUgYXV0aGVudGljYXRpb24gYmVoYXZpb3IgdXNlZCBieSB0
aGUgYmFja2VuZC4KCiBGb3IgZXhhbXBsZSwgc3BlY2lmeWluZyBgand0X2F1ZGllbmNlYCBp
bXBsaWVzIHRoYXQgdGhlIGJhY2tlbmQgZXhwZWN0cwogYXV0aGVudGljYXRpb24gdmlhIGEg
SldULgoKIFdoZW4gYXV0aGVudGljYXRpb24gaXMgdW5zcGVjaWZpZWQsIHRoZSByZXN1bHRp
bmcgYmVoYXZpb3IgaXMgdGhlIHNhbWUKIGFzIGBkaXNhYmxlX2F1dGhgIHNldCB0byBgdHJ1
ZWAuCgogUmVmZXIgdG8gaHR0cHM6Ly9kZXZlbG9wZXJzLmdvb2dsZS5jb20vaWRlbnRpdHkv
cHJvdG9jb2xzL09wZW5JRENvbm5lY3QgZm9yCiBKV1QgSUQgdG9rZW4uCgoNCgUEAQgAARIE
lgEIFgq0AQoEBAECBhIEmgEEHBqlASBUaGUgSldUIGF1ZGllbmNlIGlzIHVzZWQgd2hlbiBn
ZW5lcmF0aW5nIGEgSldUIElEIHRva2VuIGZvciB0aGUgYmFja2VuZC4KIFRoaXMgSUQgdG9r
ZW4gd2lsbCBiZSBhZGRlZCBpbiB0aGUgSFRUUCAiYXV0aG9yaXphdGlvbiIgaGVhZGVyLCBh
bmQgc2VudAogdG8gdGhlIGJhY2tlbmQuCgoNCgUEAQIGBRIEmgEECgoNCgUEAQIGARIEmgEL
FwoNCgUEAQIGAxIEmgEaGwqZAgoEBAECBxIEoAEEGhqKAiBXaGVuIGRpc2FibGVfYXV0aCBp
cyB0cnVlLCBhIEpXVCBJRCB0b2tlbiB3b24ndCBiZSBnZW5lcmF0ZWQgYW5kIHRoZQogb3Jp
Z2luYWwgIkF1dGhvcml6YXRpb24iIEhUVFAgaGVhZGVyIHdpbGwgYmUgcHJlc2VydmVkLiBJ
ZiB0aGUgaGVhZGVyIGlzCiB1c2VkIHRvIGNhcnJ5IHRoZSBvcmlnaW5hbCB0b2tlbiBhbmQg
aXMgZXhwZWN0ZWQgYnkgdGhlIGJhY2tlbmQsIHRoaXMKIGZpZWxkIG11c3QgYmUgc2V0IHRv
IHRydWUgdG8gcHJlc2VydmUgdGhlIGhlYWRlci4KCg0KBQQBAgcFEgSgAQQICg0KBQQBAgcB
EgSgAQkVCg0KBQQBAgcDEgSgARgZCvUFCgQEAQIIEgS4AQIWGuYFIFRoZSBwcm90b2NvbCB1
c2VkIGZvciBzZW5kaW5nIGEgcmVxdWVzdCB0byB0aGUgYmFja2VuZC4KIFRoZSBzdXBwb3J0
ZWQgdmFsdWVzIGFyZSAiaHR0cC8xLjEiIGFuZCAiaDIiLgoKIFRoZSBkZWZhdWx0IHZhbHVl
IGlzIGluZmVycmVkIGZyb20gdGhlIHNjaGVtZSBpbiB0aGUKIFthZGRyZXNzXVtnb29nbGUu
YXBpLkJhY2tlbmRSdWxlLmFkZHJlc3NdIGZpZWxkOgoKICAgIFNDSEVNRSAgICAgICAgUFJP
VE9DT0wKICAgIGh0dHA6Ly8gICAgICAgaHR0cC8xLjEKICAgIGh0dHBzOi8vICAgICAgaHR0
cC8xLjEKICAgIGdycGM6Ly8gICAgICAgaDIKICAgIGdycGNzOi8vICAgICAgaDIKCiBGb3Ig
c2VjdXJlIEhUVFAgYmFja2VuZHMgKGh0dHBzOi8vKSB0aGF0IHN1cHBvcnQgSFRUUC8yLCBz
ZXQgdGhpcyBmaWVsZAogdG8gImgyIiBmb3IgaW1wcm92ZWQgcGVyZm9ybWFuY2UuCgogQ29u
ZmlndXJpbmcgdGhpcyBmaWVsZCB0byBub24tZGVmYXVsdCB2YWx1ZXMgaXMgb25seSBzdXBw
b3J0ZWQgZm9yIHNlY3VyZQogSFRUUCBiYWNrZW5kcy4gVGhpcyBmaWVsZCB3aWxsIGJlIGln
bm9yZWQgZm9yIGFsbCBvdGhlciBiYWNrZW5kcy4KCiBTZWUKIGh0dHBzOi8vd3d3LmlhbmEu
b3JnL2Fzc2lnbm1lbnRzL3Rscy1leHRlbnNpb250eXBlLXZhbHVlcy90bHMtZXh0ZW5zaW9u
dHlwZS12YWx1ZXMueGh0bWwjYWxwbi1wcm90b2NvbC1pZHMKIGZvciBtb3JlIGRldGFpbHMg
b24gdGhlIHN1cHBvcnRlZCB2YWx1ZXMuCgoNCgUEAQIIBRIEuAECCAoNCgUEAQIIARIEuAEJ
EQoNCgUEAQIIAxIEuAEUFQpJCgQEAQIJEgS7AQI+GjsgVGhlIG1hcCBiZXR3ZWVuIHJlcXVl
c3QgcHJvdG9jb2wgYW5kIHRoZSBiYWNrZW5kIGFkZHJlc3MuCgoNCgUEAQIJBhIEuwECGgoN
CgUEAQIJARIEuwEbOAoNCgUEAQIJAxIEuwE7PQqsAgoEBAECChIEwgECJBqdAiBUaGUgbG9h
ZCBiYWxhbmNpbmcgcG9saWN5IHVzZWQgZm9yIGNvbm5lY3Rpb24gdG8gdGhlIGFwcGxpY2F0
aW9uIGJhY2tlbmQuCgogRGVmaW5lZCBhcyBhbiBhcmJpdHJhcnkgc3RyaW5nIHRvIGFjY29t
b25kYXRlIGN1c3RvbSBsb2FkIGJhbGFuY2luZwogcG9saWNpZXMgc3VwcG9ydGVkIGJ5IHRo
ZSB1bmRlcmx5aW5nIGNoYW5uZWwsIGJ1dCBzdWdnZXN0IG1vc3QgdXNlcnMgdXNlCiBvbmUg
b2YgdGhlIHN0YW5kYXJkIHBvbGljaWVzLCBzdWNoIGFzIHRoZSBkZWZhdWx0LCAiUm91bmRS
b2JpbiIuCgoNCgUEAQIKBRIEwgECCAoNCgUEAQIKARIEwgEJHgoNCgUEAQIKAxIEwgEhI2IG
cHJvdG8z
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Backend::Backend ===
    # Fields for Backend
    # Field: rules Type: 11 (.google.api.BackendRule)

# === Message: Google::Api::Backend::BackendRule ===
    # Fields for BackendRule
    # Field: selector Type: 9 ()
    # Field: address Type: 9 ()
    # Field: deadline Type: 1 ()
    # Field: min_deadline Type: 1 ()
    # Field: operation_deadline Type: 1 ()
    # Field: path_translation Type: 14 (.google.api.BackendRule.PathTranslation)
    # Field: jwt_audience Type: 9 ()
    # Field: disable_auth Type: 8 ()
    # Field: protocol Type: 9 ()
    # Field: overrides_by_request_protocol Type: 11 (.google.api.BackendRule.OverridesByRequestProtocolEntry)
    # Field: load_balancing_policy Type: 9 ()

# Enum: BackendRule::PathTranslation
our $BackendRule_PATH_TRANSLATION_UNSPECIFIED = 0;
our $BackendRule_CONSTANT_ADDRESS = 1;
our $BackendRule_APPEND_PATH_TO_ADDRESS = 2;

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Backend - Compiled Protocol Buffers messages for google/api/backend.proto

=head1 SYNOPSIS

    use Google::Api::Backend;

    my $msg = Google::Api::Backend::Backend->new({
        rules => $rules,
    });

    # Read or update a field
    my $val = $msg->rules();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Backend::Backend->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/backend.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Backend::Backend

`Backend` defines the backend configuration for a service.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->rules() >> / C<< $msg->rules($value) >>

Type: C<Message> (L<Google::Api::Backend::BackendRule>)

A list of API backend rules that apply to individual API methods.

B<NOTE:> All service configuration rules follow "last one wins" order.

=back

=head2 Google::Api::Backend::BackendRule

A backend rule provides configuration for an individual API element.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->selector() >> / C<< $msg->selector($value) >>

Type: C<String>

Selects the methods to which this rule applies.

Refer to [selector][google.api.DocumentationRule.selector] for syntax
details.

=item * C<< $msg->address() >> / C<< $msg->address($value) >>

Type: C<String>

The address of the API backend.

The scheme is used to determine the backend protocol and security.
The following schemes are accepted:

   SCHEME        PROTOCOL    SECURITY
   http://       HTTP        None
   https://      HTTP        TLS
   grpc://       gRPC        None
   grpcs://      gRPC        TLS

It is recommended to explicitly include a scheme. Leaving out the scheme
may cause constrasting behaviors across platforms.

If the port is unspecified, the default is:
- 80 for schemes without TLS
- 443 for schemes with TLS

For HTTP backends, use [protocol][google.api.BackendRule.protocol]
to specify the protocol version.

=item * C<< $msg->deadline() >> / C<< $msg->deadline($value) >>

Type: C<Double>

The number of seconds to wait for a response from a request. The default
varies based on the request protocol and deployment environment.

=item * C<< $msg->min_deadline() >> / C<< $msg->min_deadline($value) >>

Type: C<Double>

Deprecated, do not use.

=item * C<< $msg->operation_deadline() >> / C<< $msg->operation_deadline($value) >>

Type: C<Double>

The number of seconds to wait for the completion of a long running
operation. The default is no deadline.

=item * C<< $msg->path_translation() >> / C<< $msg->path_translation($value) >>

Type: C<Enum> (L<Google::Api::BackendRule::PathTranslation>)

Path translation specifies how to combine the backend address with the
request path in order to produce the appropriate forwarding URL for the
request. See [PathTranslation][google.api.BackendRule.PathTranslation] for
more details.

=item * C<< $msg->jwt_audience() >> / C<< $msg->jwt_audience($value) >>

Type: C<String>

The JWT audience is used when generating a JWT ID token for the backend.
This ID token will be added in the HTTP "authorization" header, and sent
to the backend.

=item * C<< $msg->disable_auth() >> / C<< $msg->disable_auth($value) >>

Type: C<Bool>

When disable_auth is true, a JWT ID token won't be generated and the
original "Authorization" HTTP header will be preserved. If the header is
used to carry the original token and is expected by the backend, this
field must be set to true to preserve the header.

=item * C<< $msg->protocol() >> / C<< $msg->protocol($value) >>

Type: C<String>

The protocol used for sending a request to the backend.
The supported values are "http/1.1" and "h2".

The default value is inferred from the scheme in the
[address][google.api.BackendRule.address] field:

   SCHEME        PROTOCOL
   http://       http/1.1
   https://      http/1.1
   grpc://       h2
   grpcs://      h2

For secure HTTP backends (https://) that support HTTP/2, set this field
to "h2" for improved performance.

Configuring this field to non-default values is only supported for secure
HTTP backends. This field will be ignored for all other backends.

See
https://www.iana.org/assignments/tls-extensiontype-values/tls-extensiontype-values.xhtml#alpn-protocol-ids
for more details on the supported values.

=item * C<< $msg->overrides_by_request_protocol() >> / C<< $msg->overrides_by_request_protocol($value) >>

Type: C<Message> (L<Google::Api::Backend::BackendRule::OverridesByRequestProtocolEntry>)

The map between request protocol and the backend address.

=item * C<< $msg->load_balancing_policy() >> / C<< $msg->load_balancing_policy($value) >>

Type: C<String>

The load balancing policy used for connection to the application backend.

Defined as an arbitrary string to accomondate custom load balancing
policies supported by the underlying channel, but suggest most users use
one of the standard policies, such as the default, "RoundRobin".

=back

=head3 Enum: BackendRule::PathTranslation

=over 4

=item * C<PATH_TRANSLATION_UNSPECIFIED> => C<0>

=item * C<CONSTANT_ADDRESS> => C<1>

=item * C<APPEND_PATH_TO_ADDRESS> => C<2>

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Backend::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

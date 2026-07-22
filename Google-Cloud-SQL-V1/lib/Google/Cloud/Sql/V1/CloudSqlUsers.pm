package Google::Cloud::Sql::V1::CloudSqlUsers;

use strict;
use warnings;

our $VERSION = '0.10';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    eval { require Google::Api::Annotations };
    eval { require Google::Api::Client };
    eval { require Google::Api::FieldBehavior };
    eval { require Google::Api::Resource };
    eval { require Google::Cloud::Sql::V1::CloudSqlResources };
    eval { require Google::Protobuf::Duration };
    eval { require Google::Protobuf::Timestamp };
    my $descriptor_b64 = <<'EOF';
Cilnb29nbGUvY2xvdWQvc3FsL3YxL2Nsb3VkX3NxbF91c2Vycy5wcm90bxITZ29vZ2xlLmNs
b3VkLnNxbC52MRocZ29vZ2xlL2FwaS9hbm5vdGF0aW9ucy5wcm90bxoXZ29vZ2xlL2FwaS9j
bGllbnQucHJvdG8aH2dvb2dsZS9hcGkvZmllbGRfYmVoYXZpb3IucHJvdG8aGWdvb2dsZS9h
cGkvcmVzb3VyY2UucHJvdG8aLWdvb2dsZS9jbG91ZC9zcWwvdjEvY2xvdWRfc3FsX3Jlc291
cmNlcy5wcm90bxoeZ29vZ2xlL3Byb3RvYnVmL2R1cmF0aW9uLnByb3RvGh9nb29nbGUvcHJv
dG9idWYvdGltZXN0YW1wLnByb3RvInUKFVNxbFVzZXJzRGVsZXRlUmVxdWVzdBISCgRob3N0
GAEgASgJUgRob3N0EhoKCGluc3RhbmNlGAIgASgJUghpbnN0YW5jZRISCgRuYW1lGAMgASgJ
UgRuYW1lEhgKB3Byb2plY3QYBCABKAlSB3Byb2plY3QicgoSU3FsVXNlcnNHZXRSZXF1ZXN0
EhoKCGluc3RhbmNlGAEgASgJUghpbnN0YW5jZRISCgRuYW1lGAIgASgJUgRuYW1lEhgKB3By
b2plY3QYAyABKAlSB3Byb2plY3QSEgoEaG9zdBgEIAEoCVIEaG9zdCJ8ChVTcWxVc2Vyc0lu
c2VydFJlcXVlc3QSGgoIaW5zdGFuY2UYASABKAlSCGluc3RhbmNlEhgKB3Byb2plY3QYAiAB
KAlSB3Byb2plY3QSLQoEYm9keRhkIAEoCzIZLmdvb2dsZS5jbG91ZC5zcWwudjEuVXNlclIE
Ym9keSJLChNTcWxVc2Vyc0xpc3RSZXF1ZXN0EhoKCGluc3RhbmNlGAEgASgJUghpbnN0YW5j
ZRIYCgdwcm9qZWN0GAIgASgJUgdwcm9qZWN0Iq0CChVTcWxVc2Vyc1VwZGF0ZVJlcXVlc3QS
FwoEaG9zdBgBIAEoCUID4EEBUgRob3N0EhoKCGluc3RhbmNlGAIgASgJUghpbnN0YW5jZRIS
CgRuYW1lGAMgASgJUgRuYW1lEhgKB3Byb2plY3QYBCABKAlSB3Byb2plY3QSKgoOZGF0YWJh
c2Vfcm9sZXMYBSADKAlCA+BBAVINZGF0YWJhc2VSb2xlcxI8ChVyZXZva2VfZXhpc3Rpbmdf
cm9sZXMYBiABKAhCA+BBAUgAUhNyZXZva2VFeGlzdGluZ1JvbGVziAEBEi0KBGJvZHkYZCAB
KAsyGS5nb29nbGUuY2xvdWQuc3FsLnYxLlVzZXJSBGJvZHlCGAoWX3Jldm9rZV9leGlzdGlu
Z19yb2xlcyL4AgocVXNlclBhc3N3b3JkVmFsaWRhdGlvblBvbGljeRI2ChdhbGxvd2VkX2Zh
aWxlZF9hdHRlbXB0cxgBIAEoBVIVYWxsb3dlZEZhaWxlZEF0dGVtcHRzElsKHHBhc3N3b3Jk
X2V4cGlyYXRpb25fZHVyYXRpb24YAiABKAsyGS5nb29nbGUucHJvdG9idWYuRHVyYXRpb25S
GnBhc3N3b3JkRXhwaXJhdGlvbkR1cmF0aW9uEj8KHGVuYWJsZV9mYWlsZWRfYXR0ZW1wdHNf
Y2hlY2sYAyABKAhSGWVuYWJsZUZhaWxlZEF0dGVtcHRzQ2hlY2sSQAoGc3RhdHVzGAQgASgL
MiMuZ29vZ2xlLmNsb3VkLnNxbC52MS5QYXNzd29yZFN0YXR1c0ID4EEDUgZzdGF0dXMSQAoc
ZW5hYmxlX3Bhc3N3b3JkX3ZlcmlmaWNhdGlvbhgFIAEoCFIaZW5hYmxlUGFzc3dvcmRWZXJp
ZmljYXRpb24ifgoOUGFzc3dvcmRTdGF0dXMSFgoGbG9ja2VkGAEgASgIUgZsb2NrZWQSVAoY
cGFzc3dvcmRfZXhwaXJhdGlvbl90aW1lGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVz
dGFtcFIWcGFzc3dvcmRFeHBpcmF0aW9uVGltZSLLCAoEVXNlchISCgRraW5kGAEgASgJUgRr
aW5kEhoKCHBhc3N3b3JkGAIgASgJUghwYXNzd29yZBISCgRldGFnGAMgASgJUgRldGFnEhIK
BG5hbWUYBCABKAlSBG5hbWUSFwoEaG9zdBgFIAEoCUID4EEBUgRob3N0EhoKCGluc3RhbmNl
GAYgASgJUghpbnN0YW5jZRIYCgdwcm9qZWN0GAcgASgJUgdwcm9qZWN0EjkKBHR5cGUYCCAB
KA4yJS5nb29nbGUuY2xvdWQuc3FsLnYxLlVzZXIuU3FsVXNlclR5cGVSBHR5cGUSYQoWc3Fs
c2VydmVyX3VzZXJfZGV0YWlscxgJIAEoCzIpLmdvb2dsZS5jbG91ZC5zcWwudjEuU3FsU2Vy
dmVyVXNlckRldGFpbHNIAFIUc3Fsc2VydmVyVXNlckRldGFpbHMSIAoJaWFtX2VtYWlsGAsg
ASgJQgPgQQFSCGlhbUVtYWlsEloKD3Bhc3N3b3JkX3BvbGljeRgMIAEoCzIxLmdvb2dsZS5j
bG91ZC5zcWwudjEuVXNlclBhc3N3b3JkVmFsaWRhdGlvblBvbGljeVIOcGFzc3dvcmRQb2xp
Y3kSXQoSZHVhbF9wYXNzd29yZF90eXBlGA0gASgOMiouZ29vZ2xlLmNsb3VkLnNxbC52MS5V
c2VyLkR1YWxQYXNzd29yZFR5cGVIAVIQZHVhbFBhc3N3b3JkVHlwZYgBARJHCgppYW1fc3Rh
dHVzGA4gASgOMiMuZ29vZ2xlLmNsb3VkLnNxbC52MS5Vc2VyLklhbVN0YXR1c0gCUglpYW1T
dGF0dXOIAQESKgoOZGF0YWJhc2Vfcm9sZXMYDyADKAlCA+BBAVINZGF0YWJhc2VSb2xlcyK0
AQoLU3FsVXNlclR5cGUSDAoIQlVJTFRfSU4QABISCg5DTE9VRF9JQU1fVVNFUhABEh0KGUNM
T1VEX0lBTV9TRVJWSUNFX0FDQ09VTlQQAhITCg9DTE9VRF9JQU1fR1JPVVAQAxIYChRDTE9V
RF9JQU1fR1JPVVBfVVNFUhAEEiMKH0NMT1VEX0lBTV9HUk9VUF9TRVJWSUNFX0FDQ09VTlQQ
BRIQCgxFTlRSQUlEX1VTRVIQByJ8ChBEdWFsUGFzc3dvcmRUeXBlEiIKHkRVQUxfUEFTU1dP
UkRfVFlQRV9VTlNQRUNJRklFRBAAEhsKF05PX01PRElGWV9EVUFMX1BBU1NXT1JEEAESFAoQ
Tk9fRFVBTF9QQVNTV09SRBACEhEKDURVQUxfUEFTU1dPUkQQAyJBCglJYW1TdGF0dXMSGgoW
SUFNX1NUQVRVU19VTlNQRUNJRklFRBAAEgwKCElOQUNUSVZFEAESCgoGQUNUSVZFEAJCDgoM
dXNlcl9kZXRhaWxzQhUKE19kdWFsX3Bhc3N3b3JkX3R5cGVCDQoLX2lhbV9zdGF0dXMiVQoU
U3FsU2VydmVyVXNlckRldGFpbHMSGgoIZGlzYWJsZWQYASABKAhSCGRpc2FibGVkEiEKDHNl
cnZlcl9yb2xlcxgCIAMoCVILc2VydmVyUm9sZXMihAEKEVVzZXJzTGlzdFJlc3BvbnNlEhIK
BGtpbmQYASABKAlSBGtpbmQSLwoFaXRlbXMYAiADKAsyGS5nb29nbGUuY2xvdWQuc3FsLnYx
LlVzZXJSBWl0ZW1zEioKD25leHRfcGFnZV90b2tlbhgDIAEoCUICGAFSDW5leHRQYWdlVG9r
ZW4y9QYKD1NxbFVzZXJzU2VydmljZRKPAQoGRGVsZXRlEiouZ29vZ2xlLmNsb3VkLnNxbC52
MS5TcWxVc2Vyc0RlbGV0ZVJlcXVlc3QaHi5nb29nbGUuY2xvdWQuc3FsLnYxLk9wZXJhdGlv
biI5gtPkkwIzKjEvdjEvcHJvamVjdHMve3Byb2plY3R9L2luc3RhbmNlcy97aW5zdGFuY2V9
L3VzZXJzEosBCgNHZXQSJy5nb29nbGUuY2xvdWQuc3FsLnYxLlNxbFVzZXJzR2V0UmVxdWVz
dBoZLmdvb2dsZS5jbG91ZC5zcWwudjEuVXNlciJAgtPkkwI6EjgvdjEvcHJvamVjdHMve3By
b2plY3R9L2luc3RhbmNlcy97aW5zdGFuY2V9L3VzZXJzL3tuYW1lfRKVAQoGSW5zZXJ0Eiou
Z29vZ2xlLmNsb3VkLnNxbC52MS5TcWxVc2Vyc0luc2VydFJlcXVlc3QaHi5nb29nbGUuY2xv
dWQuc3FsLnYxLk9wZXJhdGlvbiI/gtPkkwI5IjEvdjEvcHJvamVjdHMve3Byb2plY3R9L2lu
c3RhbmNlcy97aW5zdGFuY2V9L3VzZXJzOgRib2R5EpMBCgRMaXN0EiguZ29vZ2xlLmNsb3Vk
LnNxbC52MS5TcWxVc2Vyc0xpc3RSZXF1ZXN0GiYuZ29vZ2xlLmNsb3VkLnNxbC52MS5Vc2Vy
c0xpc3RSZXNwb25zZSI5gtPkkwIzEjEvdjEvcHJvamVjdHMve3Byb2plY3R9L2luc3RhbmNl
cy97aW5zdGFuY2V9L3VzZXJzEpUBCgZVcGRhdGUSKi5nb29nbGUuY2xvdWQuc3FsLnYxLlNx
bFVzZXJzVXBkYXRlUmVxdWVzdBoeLmdvb2dsZS5jbG91ZC5zcWwudjEuT3BlcmF0aW9uIj+C
0+STAjkaMS92MS9wcm9qZWN0cy97cHJvamVjdH0vaW5zdGFuY2VzL3tpbnN0YW5jZX0vdXNl
cnM6BGJvZHkafMpBF3NxbGFkbWluLmdvb2dsZWFwaXMuY29t0kFfaHR0cHM6Ly93d3cuZ29v
Z2xlYXBpcy5jb20vYXV0aC9jbG91ZC1wbGF0Zm9ybSxodHRwczovL3d3dy5nb29nbGVhcGlz
LmNvbS9hdXRoL3NxbHNlcnZpY2UuYWRtaW5CWgoXY29tLmdvb2dsZS5jbG91ZC5zcWwudjFC
EkNsb3VkU3FsVXNlcnNQcm90b1ABWiljbG91ZC5nb29nbGUuY29tL2dvL3NxbC9hcGl2MS9z
cWxwYjtzcWxwYkqmTwoHEgUOALgCAQq8BAoBDBIDDgASMrEEIENvcHlyaWdodCAyMDI2IEdv
b2dsZSBMTEMKCiBMaWNlbnNlZCB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24g
Mi4wICh0aGUgIkxpY2Vuc2UiKTsKIHlvdSBtYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0
IGluIGNvbXBsaWFuY2Ugd2l0aCB0aGUgTGljZW5zZS4KIFlvdSBtYXkgb2J0YWluIGEgY29w
eSBvZiB0aGUgTGljZW5zZSBhdAoKICAgICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5z
ZXMvTElDRU5TRS0yLjAKCiBVbmxlc3MgcmVxdWlyZWQgYnkgYXBwbGljYWJsZSBsYXcgb3Ig
YWdyZWVkIHRvIGluIHdyaXRpbmcsIHNvZnR3YXJlCiBkaXN0cmlidXRlZCB1bmRlciB0aGUg
TGljZW5zZSBpcyBkaXN0cmlidXRlZCBvbiBhbiAiQVMgSVMiIEJBU0lTLAogV0lUSE9VVCBX
QVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9y
IGltcGxpZWQuCiBTZWUgdGhlIExpY2Vuc2UgZm9yIHRoZSBzcGVjaWZpYyBsYW5ndWFnZSBn
b3Zlcm5pbmcgcGVybWlzc2lvbnMgYW5kCiBsaW1pdGF0aW9ucyB1bmRlciB0aGUgTGljZW5z
ZS4KCggKAQISAxAAHAoJCgIDABIDEgAmCgkKAgMBEgMTACEKCQoCAwISAxQAKQoJCgIDAxID
FQAjCgkKAgMEEgMWADcKCQoCAwUSAxcAKAoJCgIDBhIDGAApCggKAQgSAxoAQAoJCgIICxID
GgBACggKAQgSAxsAIgoJCgIIChIDGwAiCggKAQgSAxwAMwoJCgIICBIDHAAzCggKAQgSAx0A
MAoJCgIIARIDHQAwCiYKAgYAEgQgAEoBGhogQ2xvdWQgU1FMIHVzZXJzIHNlcnZpY2UuCgoK
CgMGAAESAyAIFwoKCgMGAAMSAyECPwoMCgUGAAOZCBIDIQI/CgsKAwYAAxIEIgIkOQoNCgUG
AAOaCBIEIgIkOQo5CgQGAAIAEgQnAisDGisgRGVsZXRlcyBhIHVzZXIgZnJvbSBhIENsb3Vk
IFNRTCBpbnN0YW5jZS4KCgwKBQYAAgABEgMnBgwKDAoFBgACAAISAycNIgoMCgUGAAIAAxID
Jy02Cg0KBQYAAgAEEgQoBCoGChEKCQYAAgAEsMq8IhIEKAQqBgpJCgQGAAIBEgQuAjIDGjsg
UmV0cmlldmVzIGEgcmVzb3VyY2UgY29udGFpbmluZyBpbmZvcm1hdGlvbiBhYm91dCBhIHVz
ZXIuCgoMCgUGAAIBARIDLgYJCgwKBQYAAgECEgMuChwKDAoFBgACAQMSAy4nKwoNCgUGAAIB
BBIELwQxBgoRCgkGAAIBBLDKvCISBC8EMQYKOwoEBgACAhIENQI6AxotIENyZWF0ZXMgYSBu
ZXcgdXNlciBpbiBhIENsb3VkIFNRTCBpbnN0YW5jZS4KCgwKBQYAAgIBEgM1BgwKDAoFBgAC
AgISAzUNIgoMCgUGAAICAxIDNS02Cg0KBQYAAgIEEgQ2BDkGChEKCQYAAgIEsMq8IhIENgQ5
BgpACgQGAAIDEgQ9AkEDGjIgTGlzdHMgdXNlcnMgaW4gdGhlIHNwZWNpZmllZCBDbG91ZCBT
UUwgaW5zdGFuY2UuCgoMCgUGAAIDARIDPQYKCgwKBQYAAgMCEgM9Cx4KDAoFBgACAwMSAz0p
OgoNCgUGAAIDBBIEPgRABgoRCgkGAAIDBLDKvCISBD4EQAYKQQoEBgACBBIERAJJAxozIFVw
ZGF0ZXMgYW4gZXhpc3RpbmcgdXNlciBpbiBhIENsb3VkIFNRTCBpbnN0YW5jZS4KCgwKBQYA
AgQBEgNEBgwKDAoFBgACBAISA0QNIgoMCgUGAAIEAxIDRC02Cg0KBQYAAgQEEgRFBEgGChEK
CQYAAgQEsMq8IhIERQRIBgoKCgIEABIETABYAQoKCgMEAAESA0wIHQowCgQEAAIAEgNOAhIa
IyBIb3N0IG9mIHRoZSB1c2VyIGluIHRoZSBpbnN0YW5jZS4KCgwKBQQAAgAFEgNOAggKDAoF
BAACAAESA04JDQoMCgUEAAIAAxIDThARCkoKBAQAAgESA1ECFho9IERhdGFiYXNlIGluc3Rh
bmNlIElELiBUaGlzIGRvZXMgbm90IGluY2x1ZGUgdGhlIHByb2plY3QgSUQuCgoMCgUEAAIB
BRIDUQIICgwKBQQAAgEBEgNRCREKDAoFBAACAQMSA1EUFQowCgQEAAICEgNUAhIaIyBOYW1l
IG9mIHRoZSB1c2VyIGluIHRoZSBpbnN0YW5jZS4KCgwKBQQAAgIFEgNUAggKDAoFBAACAgES
A1QJDQoMCgUEAAICAxIDVBARCkQKBAQAAgMSA1cCFRo3IFByb2plY3QgSUQgb2YgdGhlIHBy
b2plY3QgdGhhdCBjb250YWlucyB0aGUgaW5zdGFuY2UuCgoMCgUEAAIDBRIDVwIICgwKBQQA
AgMBEgNXCRAKDAoFBAACAwMSA1cTFAovCgIEARIEWwBnARojIFJlcXVlc3QgbWVzc2FnZSBm
b3IgVXNlcnMgR2V0IFJQQwoKCgoDBAEBEgNbCBoKSgoEBAECABIDXQIWGj0gRGF0YWJhc2Ug
aW5zdGFuY2UgSUQuIFRoaXMgZG9lcyBub3QgaW5jbHVkZSB0aGUgcHJvamVjdCBJRC4KCgwK
BQQBAgAFEgNdAggKDAoFBAECAAESA10JEQoMCgUEAQIAAxIDXRQVCiQKBAQBAgESA2ACEhoX
IFVzZXIgb2YgdGhlIGluc3RhbmNlLgoKDAoFBAECAQUSA2ACCAoMCgUEAQIBARIDYAkNCgwK
BQQBAgEDEgNgEBEKRAoEBAECAhIDYwIVGjcgUHJvamVjdCBJRCBvZiB0aGUgcHJvamVjdCB0
aGF0IGNvbnRhaW5zIHRoZSBpbnN0YW5jZS4KCgwKBQQBAgIFEgNjAggKDAoFBAECAgESA2MJ
EAoMCgUEAQICAxIDYxMUCi4KBAQBAgMSA2YCEhohIEhvc3Qgb2YgYSB1c2VyIG9mIHRoZSBp
bnN0YW5jZS4KCgwKBQQBAgMFEgNmAggKDAoFBAECAwESA2YJDQoMCgUEAQIDAxIDZhARCgoK
AgQCEgRpAHEBCgoKAwQCARIDaQgdCkoKBAQCAgASA2sCFho9IERhdGFiYXNlIGluc3RhbmNl
IElELiBUaGlzIGRvZXMgbm90IGluY2x1ZGUgdGhlIHByb2plY3QgSUQuCgoMCgUEAgIABRID
awIICgwKBQQCAgABEgNrCREKDAoFBAICAAMSA2sUFQpECgQEAgIBEgNuAhUaNyBQcm9qZWN0
IElEIG9mIHRoZSBwcm9qZWN0IHRoYXQgY29udGFpbnMgdGhlIGluc3RhbmNlLgoKDAoFBAIC
AQUSA24CCAoMCgUEAgIBARIDbgkQCgwKBQQCAgEDEgNuExQKCwoEBAICAhIDcAISCgwKBQQC
AgIGEgNwAgYKDAoFBAICAgESA3AHCwoMCgUEAgICAxIDcA4RCgoKAgQDEgRzAHkBCgoKAwQD
ARIDcwgbCkoKBAQDAgASA3UCFho9IERhdGFiYXNlIGluc3RhbmNlIElELiBUaGlzIGRvZXMg
bm90IGluY2x1ZGUgdGhlIHByb2plY3QgSUQuCgoMCgUEAwIABRIDdQIICgwKBQQDAgABEgN1
CREKDAoFBAMCAAMSA3UUFQpECgQEAwIBEgN4AhUaNyBQcm9qZWN0IElEIG9mIHRoZSBwcm9q
ZWN0IHRoYXQgY29udGFpbnMgdGhlIGluc3RhbmNlLgoKDAoFBAMCAQUSA3gCCAoMCgUEAwIB
ARIDeAkQCgwKBQQDAgEDEgN4ExQKCwoCBAQSBXsAkwEBCgoKAwQEARIDewgdCjoKBAQEAgAS
A30COxotIE9wdGlvbmFsLiBIb3N0IG9mIHRoZSB1c2VyIGluIHRoZSBpbnN0YW5jZS4KCgwK
BQQEAgAFEgN9AggKDAoFBAQCAAESA30JDQoMCgUEBAIAAxIDfRARCgwKBQQEAgAIEgN9EjoK
DwoIBAQCAAicCAASA30TOQpLCgQEBAIBEgSAAQIWGj0gRGF0YWJhc2UgaW5zdGFuY2UgSUQu
IFRoaXMgZG9lcyBub3QgaW5jbHVkZSB0aGUgcHJvamVjdCBJRC4KCg0KBQQEAgEFEgSAAQII
Cg0KBQQEAgEBEgSAAQkRCg0KBQQEAgEDEgSAARQVCjEKBAQEAgISBIMBAhIaIyBOYW1lIG9m
IHRoZSB1c2VyIGluIHRoZSBpbnN0YW5jZS4KCg0KBQQEAgIFEgSDAQIICg0KBQQEAgIBEgSD
AQkNCg0KBQQEAgIDEgSDARARCkUKBAQEAgMSBIYBAhUaNyBQcm9qZWN0IElEIG9mIHRoZSBw
cm9qZWN0IHRoYXQgY29udGFpbnMgdGhlIGluc3RhbmNlLgoKDQoFBAQCAwUSBIYBAggKDQoF
BAQCAwESBIYBCRAKDQoFBAQCAwMSBIYBExQKfwoEBAQCBBIEigECThpxIE9wdGlvbmFsLiBM
aXN0IG9mIGRhdGFiYXNlIHJvbGVzIHRvIGdyYW50IHRvIHRoZSB1c2VyLiBib2R5LmRhdGFi
YXNlX3JvbGVzCiB3aWxsIGJlIGlnbm9yZWQgZm9yIHVwZGF0ZSByZXF1ZXN0LgoKDQoFBAQC
BAQSBIoBAgoKDQoFBAQCBAUSBIoBCxEKDQoFBAQCBAESBIoBEiAKDQoFBAQCBAMSBIoBIyQK
DQoFBAQCBAgSBIoBJU0KEAoIBAQCBAicCAASBIoBJkwK6wEKBAQEAgUSBo8BApABLxraASBP
cHRpb25hbC4gU3BlY2lmaWVzIHdoZXRoZXIgdG8gcmV2b2tlIGV4aXN0aW5nIHJvbGVzIHRo
YXQgYXJlIG5vdCBwcmVzZW50CiBpbiB0aGUgYGRhdGFiYXNlX3JvbGVzYCBmaWVsZC4gSWYg
YGZhbHNlYCBvciB1bnNldCwgdGhlIGRhdGFiYXNlIHJvbGVzCiBzcGVjaWZpZWQgaW4gYGRh
dGFiYXNlX3JvbGVzYCBhcmUgYWRkZWQgdG8gdGhlIHVzZXIncyBleGlzdGluZyByb2xlcy4K
Cg0KBQQEAgUEEgSPAQIKCg0KBQQEAgUFEgSPAQsPCg0KBQQEAgUBEgSPARAlCg0KBQQEAgUD
EgSPASgpCg0KBQQEAgUIEgSQAQYuChAKCAQEAgUInAgAEgSQAQctCgwKBAQEAgYSBJIBAhIK
DQoFBAQCBgYSBJIBAgYKDQoFBAQCBgESBJIBBwsKDQoFBAQCBgMSBJIBDhEKNgoCBAUSBpYB
AKYBARooIFVzZXIgbGV2ZWwgcGFzc3dvcmQgdmFsaWRhdGlvbiBwb2xpY3kuCgoLCgMEBQES
BJYBCCQKTwoEBAUCABIEmAECJBpBIE51bWJlciBvZiBmYWlsZWQgbG9naW4gYXR0ZW1wdHMg
YWxsb3dlZCBiZWZvcmUgdXNlciBnZXQgbG9ja2VkLgoKDQoFBAUCAAUSBJgBAgcKDQoFBAUC
AAESBJgBCB8KDQoFBAUCAAMSBJgBIiMKPgoEBAUCARIEmwECPBowIEV4cGlyYXRpb24gZHVy
YXRpb24gYWZ0ZXIgcGFzc3dvcmQgaXMgdXBkYXRlZC4KCg0KBQQFAgEGEgSbAQIaCg0KBQQF
AgEBEgSbARs3Cg0KBQQFAgEDEgSbATo7CkUKBAQFAgISBJ4BAigaNyBJZiB0cnVlLCBmYWls
ZWQgbG9naW4gYXR0ZW1wdHMgY2hlY2sgd2lsbCBiZSBlbmFibGVkLgoKDQoFBAUCAgUSBJ4B
AgYKDQoFBAUCAgESBJ4BByMKDQoFBAUCAgMSBJ4BJicKNwoEBAUCAxIEoQECSBopIE91dHB1
dCBvbmx5LiBSZWFkLW9ubHkgcGFzc3dvcmQgc3RhdHVzLgoKDQoFBAUCAwYSBKEBAhAKDQoF
BAUCAwESBKEBERcKDQoFBAUCAwMSBKEBGhsKDQoFBAUCAwgSBKEBHEcKEAoIBAUCAwicCAAS
BKEBHUYKiQEKBAQFAgQSBKUBAigaeyBJZiB0cnVlLCB0aGUgdXNlciBtdXN0IHNwZWNpZnkg
dGhlIGN1cnJlbnQgcGFzc3dvcmQgYmVmb3JlIGNoYW5naW5nIHRoZQogcGFzc3dvcmQuIFRo
aXMgZmxhZyBpcyBzdXBwb3J0ZWQgb25seSBmb3IgTXlTUUwuCgoNCgUEBQIEBRIEpQECBgoN
CgUEBQIEARIEpQEHIwoNCgUEBQIEAxIEpQEmJwoqCgIEBhIGqQEArwEBGhwgUmVhZC1vbmx5
IHBhc3N3b3JkIHN0YXR1cy4KCgsKAwQGARIEqQEIFgo9CgQEBgIAEgSrAQISGi8gSWYgdHJ1
ZSwgdXNlciBkb2VzIG5vdCBoYXZlIGxvZ2luIHByaXZpbGVnZXMuCgoNCgUEBgIABRIEqwEC
BgoNCgUEBgIAARIEqwEHDQoNCgUEBgIAAxIEqwEQEQo8CgQEBgIBEgSuAQI5Gi4gVGhlIGV4
cGlyYXRpb24gdGltZSBvZiB0aGUgY3VycmVudCBwYXNzd29yZC4KCg0KBQQGAgEGEgSuAQIb
Cg0KBQQGAgEBEgSuARw0Cg0KBQQGAgEDEgSuATc4CioKAgQHEgayAQCjAgEaHCBBIENsb3Vk
IFNRTCB1c2VyIHJlc291cmNlLgoKCwoDBAcBEgSyAQgMCiAKBAQHBAASBrQBAsoBAxoQIFRo
ZSB1c2VyIHR5cGUuCgoNCgUEBwQAARIEtAEHEgo0CgYEBwQAAgASBLYBBBEaJCBUaGUgZGF0
YWJhc2UncyBidWlsdC1pbiB1c2VyIHR5cGUuCgoPCgcEBwQAAgABEgS2AQQMCg8KBwQHBAAC
AAISBLYBDxAKIQoGBAcEAAIBEgS5AQQXGhEgQ2xvdWQgSUFNIHVzZXIuCgoPCgcEBwQAAgEB
EgS5AQQSCg8KBwQHBAACAQISBLkBFRYKLAoGBAcEAAICEgS8AQQiGhwgQ2xvdWQgSUFNIHNl
cnZpY2UgYWNjb3VudC4KCg8KBwQHBAACAgESBLwBBB0KDwoHBAcEAAICAhIEvAEgIQo2CgYE
BwQAAgMSBL8BBBgaJiBDbG91ZCBJQU0gZ3JvdXAuIE5vdCB1c2VkIGZvciBsb2dpbi4KCg8K
BwQHBAACAwESBL8BBBMKDwoHBAcEAAIDAhIEvwEWFwpSCgYEBwQAAgQSBMIBBB0aQiBSZWFk
LW9ubHkuIExvZ2luIGZvciBhIHVzZXIgdGhhdCBiZWxvbmdzIHRvIHRoZSBDbG91ZCBJQU0g
Z3JvdXAuCgoPCgcEBwQAAgQBEgTCAQQYCg8KBwQHBAACBAISBMIBGxwKXgoGBAcEAAIFEgTG
AQQoGk4gUmVhZC1vbmx5LiBMb2dpbiBmb3IgYSBzZXJ2aWNlIGFjY291bnQgdGhhdCBiZWxv
bmdzIHRvIHRoZQogQ2xvdWQgSUFNIGdyb3VwLgoKDwoHBAcEAAIFARIExgEEIwoPCgcEBwQA
AgUCEgTGASYnCioKBgQHBAACBhIEyQEEFRoaIE1pY3Jvc29mdCBFbnRyYSBJRCB1c2VyLgoK
DwoHBAcEAAIGARIEyQEEEAoPCgcEBwQAAgYCEgTJARMUCjAKBAQHBAESBs0BAtkBAxogIFRo
ZSB0eXBlIG9mIHJldGFpbmVkIHBhc3N3b3JkLgoKDQoFBAcEAQESBM0BBxcKJAoGBAcEAQIA
EgTPAQQnGhQgVGhlIGRlZmF1bHQgdmFsdWUuCgoPCgcEBwQBAgABEgTPAQQiCg8KBwQHBAEC
AAISBM8BJSYKQAoGBAcEAQIBEgTSAQQgGjAgRG8gbm90IHVwZGF0ZSB0aGUgdXNlcidzIGR1
YWwgcGFzc3dvcmQgc3RhdHVzLgoKDwoHBAcEAQIBARIE0gEEGwoPCgcEBwQBAgECEgTSAR4f
CkkKBgQHBAECAhIE1QEEGRo5IE5vIGR1YWwgcGFzc3dvcmQgdXNhYmxlIGZvciBjb25uZWN0
aW5nIHVzaW5nIHRoaXMgdXNlci4KCg8KBwQHBAECAgESBNUBBBQKDwoHBAcEAQICAhIE1QEX
GApGCgYEBwQBAgMSBNgBBBYaNiBEdWFsIHBhc3N3b3JkIHVzYWJsZSBmb3IgY29ubmVjdGlu
ZyB1c2luZyB0aGlzIHVzZXIuCgoPCgcEBwQBAgMBEgTYAQQRCg8KBwQHBAECAwISBNgBFBUK
VAoEBAcEAhIG3AEC6gEDGkQgSW5kaWNhdGVzIGlmIGEgZ3JvdXAgaXMgYXZhaWxhYmxlIGZv
ciBJQU0gZGF0YWJhc2UgYXV0aGVudGljYXRpb24uCgoNCgUEBwQCARIE3AEHEAqZAgoGBAcE
AgIAEgTiAQQfGogCIFRoZSBkZWZhdWx0IHZhbHVlIGZvciB1c2VycyB0aGF0IGFyZSBub3Qg
b2YgdHlwZSBDTE9VRF9JQU1fR1JPVVAuCiBPbmx5IENMT1VEX0lBTV9HUk9VUCB1c2VycyB3
aWxsIGJlIGluYWN0aXZlIG9yIGFjdGl2ZS4KIFVzZXJzIHdpdGggYW4gSWFtU3RhdHVzIG9m
IElBTV9TVEFUVVNfVU5TUEVDSUZJRUQgd2lsbCBub3QKIGRpc3BsYXkgd2hldGhlciB0aGV5
IGFyZSBhY3RpdmUgb3IgaW5hY3RpdmUgYXMgdGhhdCBpcyBub3QgYXBwbGljYWJsZSB0bwog
dGhlbS4KCg8KBwQHBAICAAESBOIBBBoKDwoHBAcEAgIAAhIE4gEdHgpfCgYEBwQCAgESBOYB
BBEaTyBJTkFDVElWRSBpbmRpY2F0ZXMgYSBncm91cCBpcyBub3QgYXZhaWxhYmxlIGZvciBJ
QU0gZGF0YWJhc2UKIGF1dGhlbnRpY2F0aW9uLgoKDwoHBAcEAgIBARIE5gEEDAoPCgcEBwQC
AgECEgTmAQ8QClgKBgQHBAICAhIE6QEEDxpIIEFDVElWRSBpbmRpY2F0ZXMgYSBncm91cCBp
cyBhdmFpbGFibGUgZm9yIElBTSBkYXRhYmFzZSBhdXRoZW50aWNhdGlvbi4KCg8KBwQHBAIC
AgESBOkBBAoKDwoHBAcEAgICAhIE6QENDgoqCgQEBwIAEgTtAQISGhwgVGhpcyBpcyBhbHdh
eXMgYHNxbCN1c2VyYC4KCg0KBQQHAgAFEgTtAQIICg0KBQQHAgABEgTtAQkNCg0KBQQHAgAD
EgTtARARCioKBAQHAgESBPABAhYaHCBUaGUgcGFzc3dvcmQgZm9yIHRoZSB1c2VyLgoKDQoF
BAcCAQUSBPABAggKDQoFBAcCAQESBPABCREKDQoFBAcCAQMSBPABFBUKXwoEBAcCAhIE9AEC
EhpRIFRoaXMgZmllbGQgaXMgZGVwcmVjYXRlZCBhbmQgd2lsbCBiZSByZW1vdmVkIGZyb20g
YSBmdXR1cmUgdmVyc2lvbiBvZiB0aGUKIEFQSS4KCg0KBQQHAgIFEgT0AQIICg0KBQQHAgIB
EgT0AQkNCg0KBQQHAgIDEgT0ARARCogBCgQEBwIDEgT4AQISGnogVGhlIG5hbWUgb2YgdGhl
IHVzZXIgaW4gdGhlIENsb3VkIFNRTCBpbnN0YW5jZS4gQ2FuIGJlIG9taXR0ZWQgZm9yCiBg
dXBkYXRlYCBiZWNhdXNlIGl0IGlzIGFscmVhZHkgc3BlY2lmaWVkIGluIHRoZSBVUkwuCgoN
CgUEBwIDBRIE+AECCAoNCgUEBwIDARIE+AEJDQoNCgUEBwIDAxIE+AEQEQrZAgoEBAcCBBIE
/wECOxrKAiBPcHRpb25hbC4gVGhlIGhvc3QgZnJvbSB3aGljaCB0aGUgdXNlciBjYW4gY29u
bmVjdC4gRm9yIGBpbnNlcnRgCiBvcGVyYXRpb25zLCBob3N0IGRlZmF1bHRzIHRvIGFuIGVt
cHR5IHN0cmluZy4gRm9yIGB1cGRhdGVgCiBvcGVyYXRpb25zLCBob3N0IGlzIHNwZWNpZmll
ZCBhcyBwYXJ0IG9mIHRoZSByZXF1ZXN0IFVSTC4gVGhlIGhvc3QgbmFtZQogY2Fubm90IGJl
IHVwZGF0ZWQgYWZ0ZXIgaW5zZXJ0aW9uLiAgRm9yIGEgTXlTUUwgaW5zdGFuY2UsIGl0J3Mg
cmVxdWlyZWQ7CiBmb3IgYSBQb3N0Z3JlU1FMIG9yIFNRTCBTZXJ2ZXIgaW5zdGFuY2UsIGl0
J3Mgb3B0aW9uYWwuCgoNCgUEBwIEBRIE/wECCAoNCgUEBwIEARIE/wEJDQoNCgUEBwIEAxIE
/wEQEQoNCgUEBwIECBIE/wESOgoQCggEBwIECJwIABIE/wETOQqkAQoEBAcCBRIEhAICFhqV
ASBUaGUgbmFtZSBvZiB0aGUgQ2xvdWQgU1FMIGluc3RhbmNlLiBUaGlzIGRvZXMgbm90IGlu
Y2x1ZGUgdGhlIHByb2plY3QgSUQuCiBDYW4gYmUgb21pdHRlZCBmb3IgYHVwZGF0ZWAgYmVj
YXVzZSBpdCBpcyBhbHJlYWR5IHNwZWNpZmllZCBvbiB0aGUKIFVSTC4KCg0KBQQHAgUFEgSE
AgIICg0KBQQHAgUBEgSEAgkRCg0KBQQHAgUDEgSEAhQVCs0BCgQEBwIGEgSJAgIVGr4BIFRo
ZSBwcm9qZWN0IElEIG9mIHRoZSBwcm9qZWN0IGNvbnRhaW5pbmcgdGhlIENsb3VkIFNRTCBk
YXRhYmFzZS4gVGhlIEdvb2dsZQogYXBwcyBkb21haW4gaXMgcHJlZml4ZWQgaWYgYXBwbGlj
YWJsZS4gQ2FuIGJlIG9taXR0ZWQgZm9yIGB1cGRhdGVgIGJlY2F1c2UKIGl0IGlzIGFscmVh
ZHkgc3BlY2lmaWVkIG9uIHRoZSBVUkwuCgoNCgUEBwIGBRIEiQICCAoNCgUEBwIGARIEiQIJ
EAoNCgUEBwIGAxIEiQITFAqSAQoEBAcCBxIEjQICFxqDASBUaGUgdXNlciB0eXBlLiBJdCBk
ZXRlcm1pbmVzIHRoZSBtZXRob2QgdG8gYXV0aGVudGljYXRlIHRoZSB1c2VyIGR1cmluZwog
bG9naW4uIFRoZSBkZWZhdWx0IGlzIHRoZSBkYXRhYmFzZSdzIGJ1aWx0LWluIHVzZXIgdHlw
ZS4KCg0KBQQHAgcGEgSNAgINCg0KBQQHAgcBEgSNAg4SCg0KBQQHAgcDEgSNAhUWCjkKBAQH
CAASBpACApICAxopIFVzZXIgZGV0YWlscyBmb3Igc3BlY2lmaWMgZGF0YWJhc2UgdHlwZQoK
DQoFBAcIAAESBJACCBQKDAoEBAcCCBIEkQIENAoNCgUEBwIIBhIEkQIEGAoNCgUEBwIIARIE
kQIZLwoNCgUEBwIIAxIEkQIyMwqYAQoEBAcCCRIElgICQRqJASBPcHRpb25hbC4gVGhlIGZ1
bGwgZW1haWwgZm9yIGFuIElBTSB1c2VyLiBGb3Igbm9ybWFsIGRhdGFiYXNlIHVzZXJzLCB0
aGlzCiB3aWxsIG5vdCBiZSBmaWxsZWQuIE9ubHkgYXBwbGljYWJsZSB0byBNeVNRTCBkYXRh
YmFzZSB1c2Vycy4KCg0KBQQHAgkFEgSWAgIICg0KBQQHAgkBEgSWAgkSCg0KBQQHAgkDEgSW
AhUXCg0KBQQHAgkIEgSWAhhAChAKCAQHAgkInAgAEgSWAhk/CjYKBAQHAgoSBJkCAjQaKCBV
c2VyIGxldmVsIHBhc3N3b3JkIHZhbGlkYXRpb24gcG9saWN5LgoKDQoFBAcCCgYSBJkCAh4K
DQoFBAcCCgESBJkCHy4KDQoFBAcCCgMSBJkCMTMKMgoEBAcCCxIEnAICNBokIER1YWwgcGFz
c3dvcmQgc3RhdHVzIGZvciB0aGUgdXNlci4KCg0KBQQHAgsEEgScAgIKCg0KBQQHAgsGEgSc
AgsbCg0KBQQHAgsBEgScAhwuCg0KBQQHAgsDEgScAjEzClsKBAQHAgwSBJ8CAiUaTSBJbmRp
Y2F0ZXMgaWYgYSBncm91cCBpcyBhY3RpdmUgb3IgaW5hY3RpdmUgZm9yIElBTSBkYXRhYmFz
ZSBhdXRoZW50aWNhdGlvbi4KCg0KBQQHAgwEEgSfAgIKCg0KBQQHAgwGEgSfAgsUCg0KBQQH
AgwBEgSfAhUfCg0KBQQHAgwDEgSfAiIkCjYKBAQHAg0SBKICAk8aKCBPcHRpb25hbC4gUm9s
ZSBtZW1iZXJzaGlwcyBvZiB0aGUgdXNlcgoKDQoFBAcCDQQSBKICAgoKDQoFBAcCDQUSBKIC
CxEKDQoFBAcCDQESBKICEiAKDQoFBAcCDQMSBKICIyUKDQoFBAcCDQgSBKICJk4KEAoIBAcC
DQicCAASBKICJ00KRwoCBAgSBqYCAKwCARo5IFJlcHJlc2VudHMgYSBTcWwgU2VydmVyIHVz
ZXIgb24gdGhlIENsb3VkIFNRTCBpbnN0YW5jZS4KCgsKAwQIARIEpgIIHAotCgQECAIAEgSo
AgIUGh8gSWYgdGhlIHVzZXIgaGFzIGJlZW4gZGlzYWJsZWQKCg0KBQQIAgAFEgSoAgIGCg0K
BQQIAgABEgSoAgcPCg0KBQQIAgADEgSoAhITCi4KBAQIAgESBKsCAiMaICBUaGUgc2VydmVy
IHJvbGVzIGZvciB0aGlzIHVzZXIKCg0KBQQIAgEEEgSrAgIKCg0KBQQIAgEFEgSrAgsRCg0K
BQQIAgEBEgSrAhIeCg0KBQQIAgEDEgSrAiEiCiMKAgQJEgavAgC4AgEaFSBVc2VyIGxpc3Qg
cmVzcG9uc2UuCgoLCgMECQESBK8CCBkKLwoEBAkCABIEsQICEhohIFRoaXMgaXMgYWx3YXlz
IGBzcWwjdXNlcnNMaXN0YC4KCg0KBQQJAgAFEgSxAgIICg0KBQQJAgABEgSxAgkNCg0KBQQJ
AgADEgSxAhARCjcKBAQJAgESBLQCAhoaKSBMaXN0IG9mIHVzZXIgcmVzb3VyY2VzIGluIHRo
ZSBpbnN0YW5jZS4KCg0KBQQJAgEEEgS0AgIKCg0KBQQJAgEGEgS0AgsPCg0KBQQJAgEBEgS0
AhAVCg0KBQQJAgEDEgS0AhgZChcKBAQJAgISBLcCAjEaCSBVbnVzZWQuCgoNCgUECQICBRIE
twICCAoNCgUECQICARIEtwIJGAoNCgUECQICAxIEtwIbHAoNCgUECQICCBIEtwIdMAoOCgYE
CQICCAMSBLcCHi9iBnByb3RvMw==
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersDeleteRequest ===
    # Fields for SqlUsersDeleteRequest
    # Field: host Type: 9 ()
    # Field: instance Type: 9 ()
    # Field: name Type: 9 ()
    # Field: project Type: 9 ()

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersDeleteRequest - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlUsers;

    my $msg = Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersDeleteRequest->new(
        host => $value,
    );

=head1 FIELDS

=over 4

=item * B<host>

Type: String

=item * B<instance>

Type: String

=item * B<name>

Type: String

=item * B<project>

Type: String

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersGetRequest ===
    # Fields for SqlUsersGetRequest
    # Field: instance Type: 9 ()
    # Field: name Type: 9 ()
    # Field: project Type: 9 ()
    # Field: host Type: 9 ()

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersGetRequest - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlUsers;

    my $msg = Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersGetRequest->new(
        instance => $value,
    );

=head1 FIELDS

=over 4

=item * B<instance>

Type: String

=item * B<name>

Type: String

=item * B<project>

Type: String

=item * B<host>

Type: String

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersInsertRequest ===
    # Fields for SqlUsersInsertRequest
    # Field: instance Type: 9 ()
    # Field: project Type: 9 ()
    # Field: body Type: 11 (.google.cloud.sql.v1.User)

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersInsertRequest - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlUsers;

    my $msg = Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersInsertRequest->new(
        instance => $value,
    );

=head1 FIELDS

=over 4

=item * B<instance>

Type: String

=item * B<project>

Type: String

=item * B<body>

Type: Message (.google.cloud.sql.v1.User)

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersListRequest ===
    # Fields for SqlUsersListRequest
    # Field: instance Type: 9 ()
    # Field: project Type: 9 ()

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersListRequest - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlUsers;

    my $msg = Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersListRequest->new(
        instance => $value,
    );

=head1 FIELDS

=over 4

=item * B<instance>

Type: String

=item * B<project>

Type: String

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersUpdateRequest ===
    # Fields for SqlUsersUpdateRequest
    # Field: host Type: 9 ()
    # Field: instance Type: 9 ()
    # Field: name Type: 9 ()
    # Field: project Type: 9 ()
    # Field: database_roles Type: 9 ()
    # Field: revoke_existing_roles Type: 8 ()
    # Field: body Type: 11 (.google.cloud.sql.v1.User)

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersUpdateRequest - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlUsers;

    my $msg = Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersUpdateRequest->new(
        host => $value,
    );

=head1 FIELDS

=over 4

=item * B<host>

Type: String

=item * B<instance>

Type: String

=item * B<name>

Type: String

=item * B<project>

Type: String

=item * B<database_roles>

Type: String

=item * B<revoke_existing_roles>

Type: Bool

=item * B<body>

Type: Message (.google.cloud.sql.v1.User)

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlUsers::UserPasswordValidationPolicy ===
    # Fields for UserPasswordValidationPolicy
    # Field: allowed_failed_attempts Type: 5 ()
    # Field: password_expiration_duration Type: 11 (.google.protobuf.Duration)
    # Field: enable_failed_attempts_check Type: 8 ()
    # Field: status Type: 11 (.google.cloud.sql.v1.PasswordStatus)
    # Field: enable_password_verification Type: 8 ()

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers::UserPasswordValidationPolicy - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlUsers;

    my $msg = Google::Cloud::Sql::V1::CloudSqlUsers::UserPasswordValidationPolicy->new(
        allowed_failed_attempts => $value,
    );

=head1 FIELDS

=over 4

=item * B<allowed_failed_attempts>

Type: Int32

=item * B<password_expiration_duration>

Type: Message (.google.protobuf.Duration)

=item * B<enable_failed_attempts_check>

Type: Bool

=item * B<status>

Type: Message (.google.cloud.sql.v1.PasswordStatus)

=item * B<enable_password_verification>

Type: Bool

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlUsers::PasswordStatus ===
    # Fields for PasswordStatus
    # Field: locked Type: 8 ()
    # Field: password_expiration_time Type: 11 (.google.protobuf.Timestamp)

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers::PasswordStatus - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlUsers;

    my $msg = Google::Cloud::Sql::V1::CloudSqlUsers::PasswordStatus->new(
        locked => $value,
    );

=head1 FIELDS

=over 4

=item * B<locked>

Type: Bool

=item * B<password_expiration_time>

Type: Message (.google.protobuf.Timestamp)

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlUsers::User ===
    # Fields for User
    # Field: kind Type: 9 ()
    # Field: password Type: 9 ()
    # Field: etag Type: 9 ()
    # Field: name Type: 9 ()
    # Field: host Type: 9 ()
    # Field: instance Type: 9 ()
    # Field: project Type: 9 ()
    # Field: type Type: 14 (.google.cloud.sql.v1.User.SqlUserType)
    # Field: sqlserver_user_details Type: 11 (.google.cloud.sql.v1.SqlServerUserDetails)
    # Field: iam_email Type: 9 ()
    # Field: password_policy Type: 11 (.google.cloud.sql.v1.UserPasswordValidationPolicy)
    # Field: dual_password_type Type: 14 (.google.cloud.sql.v1.User.DualPasswordType)
    # Field: iam_status Type: 14 (.google.cloud.sql.v1.User.IamStatus)
    # Field: database_roles Type: 9 ()

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers::User - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlUsers;

    my $msg = Google::Cloud::Sql::V1::CloudSqlUsers::User->new(
        kind => $value,
    );

=head1 FIELDS

=over 4

=item * B<kind>

Type: String

=item * B<password>

Type: String

=item * B<etag>

Type: String

=item * B<name>

Type: String

=item * B<host>

Type: String

=item * B<instance>

Type: String

=item * B<project>

Type: String

=item * B<type>

Type: Enum (.google.cloud.sql.v1.User.SqlUserType)

=item * B<sqlserver_user_details>

Type: Message (.google.cloud.sql.v1.SqlServerUserDetails)

=item * B<iam_email>

Type: String

=item * B<password_policy>

Type: Message (.google.cloud.sql.v1.UserPasswordValidationPolicy)

=item * B<dual_password_type>

Type: Enum (.google.cloud.sql.v1.User.DualPasswordType)

=item * B<iam_status>

Type: Enum (.google.cloud.sql.v1.User.IamStatus)

=item * B<database_roles>

Type: String

=back

=cut

# Enum: User::SqlUserType
our $User_BUILT_IN = 0;
our $User_CLOUD_IAM_USER = 1;
our $User_CLOUD_IAM_SERVICE_ACCOUNT = 2;
our $User_CLOUD_IAM_GROUP = 3;
our $User_CLOUD_IAM_GROUP_USER = 4;
our $User_CLOUD_IAM_GROUP_SERVICE_ACCOUNT = 5;
our $User_ENTRAID_USER = 7;

=pod

=head2 Enum: User::SqlUserType

Values:

=over 4

=item * C<BUILT_IN> => 0

=item * C<CLOUD_IAM_USER> => 1

=item * C<CLOUD_IAM_SERVICE_ACCOUNT> => 2

=item * C<CLOUD_IAM_GROUP> => 3

=item * C<CLOUD_IAM_GROUP_USER> => 4

=item * C<CLOUD_IAM_GROUP_SERVICE_ACCOUNT> => 5

=item * C<ENTRAID_USER> => 7

=back

=cut

# Enum: User::DualPasswordType
our $User_DUAL_PASSWORD_TYPE_UNSPECIFIED = 0;
our $User_NO_MODIFY_DUAL_PASSWORD = 1;
our $User_NO_DUAL_PASSWORD = 2;
our $User_DUAL_PASSWORD = 3;

=pod

=head2 Enum: User::DualPasswordType

Values:

=over 4

=item * C<DUAL_PASSWORD_TYPE_UNSPECIFIED> => 0

=item * C<NO_MODIFY_DUAL_PASSWORD> => 1

=item * C<NO_DUAL_PASSWORD> => 2

=item * C<DUAL_PASSWORD> => 3

=back

=cut

# Enum: User::IamStatus
our $User_IAM_STATUS_UNSPECIFIED = 0;
our $User_INACTIVE = 1;
our $User_ACTIVE = 2;

=pod

=head2 Enum: User::IamStatus

Values:

=over 4

=item * C<IAM_STATUS_UNSPECIFIED> => 0

=item * C<INACTIVE> => 1

=item * C<ACTIVE> => 2

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlUsers::SqlServerUserDetails ===
    # Fields for SqlServerUserDetails
    # Field: disabled Type: 8 ()
    # Field: server_roles Type: 9 ()

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers::SqlServerUserDetails - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlUsers;

    my $msg = Google::Cloud::Sql::V1::CloudSqlUsers::SqlServerUserDetails->new(
        disabled => $value,
    );

=head1 FIELDS

=over 4

=item * B<disabled>

Type: Bool

=item * B<server_roles>

Type: String

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlUsers::UsersListResponse ===
    # Fields for UsersListResponse
    # Field: kind Type: 9 ()
    # Field: items Type: 11 (.google.cloud.sql.v1.User)
    # Field: next_page_token Type: 9 ()

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers::UsersListResponse - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlUsers;

    my $msg = Google::Cloud::Sql::V1::CloudSqlUsers::UsersListResponse->new(
        kind => $value,
    );

=head1 FIELDS

=over 4

=item * B<kind>

Type: String

=item * B<items>

Type: Message (.google.cloud.sql.v1.User)

=item * B<next_page_token>

Type: String

=back

=cut

# === Service Client: Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersServiceClient ===
package Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersServiceClient;

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersServiceClient - Client stub representing the remote SqlUsersService service

=head1 DESCRIPTION

This class acts as a local client stub for the remote gRPC service.
It delegates call dispatching to an underlying L<Google::gRPC::Client>
instance, ensuring type-safe request parsing and response mapping.

=head1 CONFIGURATION AND ENVIRONMENT

=head2 target

The endpoint target address. Defaults to C<sql.googleapis.com:443>.

=head2 credentials

The authentication credentials provider. Defaults to application default credentials via L<Google::Auth>.

=cut

use Moo;
use Google::Auth;
use Google::gRPC::Client;

has credentials => ( is => 'ro', default => sub { Google::Auth->default() } );
has target      => ( is => 'ro', default => 'sql.googleapis.com:443' );

has _grpc_client => (
    is => 'ro',
    lazy => 1,
    builder => sub {
        my $self = shift;
        return Google::gRPC::Client->new(
            target     => $self->target,
            auth_token => $self->credentials->get_token(),
        );
    }
);

sub delete {
    my ($self, $args) = @_;
    my $req = ref($args) eq 'HASH'
        ? Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersDeleteRequest->new($args)
        : $args;
    return $self->_grpc_client->call({
        service        => 'google.cloud.sql.v1.SqlUsersService',
        method         => 'Delete',
        request        => $req,
        response_class => 'Google::Cloud::Sql::V1::CloudSqlResources::Operation',
    });
}

sub get {
    my ($self, $args) = @_;
    my $req = ref($args) eq 'HASH'
        ? Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersGetRequest->new($args)
        : $args;
    return $self->_grpc_client->call({
        service        => 'google.cloud.sql.v1.SqlUsersService',
        method         => 'Get',
        request        => $req,
        response_class => 'Google::Cloud::Sql::V1::CloudSqlUsers::User',
    });
}

sub insert {
    my ($self, $args) = @_;
    my $req = ref($args) eq 'HASH'
        ? Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersInsertRequest->new($args)
        : $args;
    return $self->_grpc_client->call({
        service        => 'google.cloud.sql.v1.SqlUsersService',
        method         => 'Insert',
        request        => $req,
        response_class => 'Google::Cloud::Sql::V1::CloudSqlResources::Operation',
    });
}

sub list {
    my ($self, $args) = @_;
    my $req = ref($args) eq 'HASH'
        ? Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersListRequest->new($args)
        : $args;
    return $self->_grpc_client->call({
        service        => 'google.cloud.sql.v1.SqlUsersService',
        method         => 'List',
        request        => $req,
        response_class => 'Google::Cloud::Sql::V1::CloudSqlUsers::UsersListResponse',
    });
}

sub update {
    my ($self, $args) = @_;
    my $req = ref($args) eq 'HASH'
        ? Google::Cloud::Sql::V1::CloudSqlUsers::SqlUsersUpdateRequest->new($args)
        : $args;
    return $self->_grpc_client->call({
        service        => 'google.cloud.sql.v1.SqlUsersService',
        method         => 'Update',
        request        => $req,
        response_class => 'Google::Cloud::Sql::V1::CloudSqlResources::Operation',
    });
}

1;

__END__

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlUsers - Protocol Buffers schema definition

=head1 DESCRIPTION

Auto-generated Protocol Buffers schema definition class.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

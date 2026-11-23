package Google::Type::PostalAddress;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    my $descriptor_b64 = <<'EOF';
CiBnb29nbGUvdHlwZS9wb3N0YWxfYWRkcmVzcy5wcm90bxILZ29vZ2xlLnR5cGUijQMKDVBv
c3RhbEFkZHJlc3MSGgoIcmV2aXNpb24YASABKAVSCHJldmlzaW9uEh8KC3JlZ2lvbl9jb2Rl
GAIgASgJUgpyZWdpb25Db2RlEiMKDWxhbmd1YWdlX2NvZGUYAyABKAlSDGxhbmd1YWdlQ29k
ZRIfCgtwb3N0YWxfY29kZRgEIAEoCVIKcG9zdGFsQ29kZRIhCgxzb3J0aW5nX2NvZGUYBSAB
KAlSC3NvcnRpbmdDb2RlEi8KE2FkbWluaXN0cmF0aXZlX2FyZWEYBiABKAlSEmFkbWluaXN0
cmF0aXZlQXJlYRIaCghsb2NhbGl0eRgHIAEoCVIIbG9jYWxpdHkSIAoLc3VibG9jYWxpdHkY
CCABKAlSC3N1YmxvY2FsaXR5EiMKDWFkZHJlc3NfbGluZXMYCSADKAlSDGFkZHJlc3NMaW5l
cxIeCgpyZWNpcGllbnRzGAogAygJUgpyZWNpcGllbnRzEiIKDG9yZ2FuaXphdGlvbhgLIAEo
CVIMb3JnYW5pemF0aW9uQnUKD2NvbS5nb29nbGUudHlwZUISUG9zdGFsQWRkcmVzc1Byb3Rv
UAFaRmdvb2dsZS5nb2xhbmcub3JnL2dlbnByb3RvL2dvb2dsZWFwaXMvdHlwZS9wb3N0YWxh
ZGRyZXNzO3Bvc3RhbGFkZHJlc3OiAgNHVFBKpzAKBxIFDgCFAQEKvAQKAQwSAw4AEjKxBCBD
b3B5cmlnaHQgMjAyNiBHb29nbGUgTExDCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBM
aWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlICJMaWNlbnNlIik7CiB5b3UgbWF5IG5vdCB1c2Ug
dGhpcyBmaWxlIGV4Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuCiBZb3Ug
bWF5IG9idGFpbiBhIGNvcHkgb2YgdGhlIExpY2Vuc2UgYXQKCiAgICAgaHR0cDovL3d3dy5h
cGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wCgogVW5sZXNzIHJlcXVpcmVkIGJ5IGFw
cGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZQogZGlzdHJp
YnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gIkFTIElTIiBC
QVNJUywKIFdJVEhPVVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBl
aXRoZXIgZXhwcmVzcyBvciBpbXBsaWVkLgogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3Bl
Y2lmaWMgbGFuZ3VhZ2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZAogbGltaXRhdGlvbnMg
dW5kZXIgdGhlIExpY2Vuc2UuCgoICgECEgMQABQKCAoBCBIDEgBdCgkKAggLEgMSAF0KCAoB
CBIDEwAiCgkKAggKEgMTACIKCAoBCBIDFAAzCgkKAggIEgMUADMKCAoBCBIDFQAoCgkKAggB
EgMVACgKCAoBCBIDFgAhCgkKAggkEgMWACEKngYKAgQAEgUpAIUBARqQBiBSZXByZXNlbnRz
IGEgcG9zdGFsIGFkZHJlc3MsIHN1Y2ggYXMgZm9yIHBvc3RhbCBkZWxpdmVyeSBvciBwYXlt
ZW50cwogYWRkcmVzc2VzLiBXaXRoIGEgcG9zdGFsIGFkZHJlc3MsIGEgcG9zdGFsIHNlcnZp
Y2UgY2FuIGRlbGl2ZXIgaXRlbXMgdG8gYQogcHJlbWlzZSwgUC5PLiBib3gsIG9yIHNpbWls
YXIuIEEgcG9zdGFsIGFkZHJlc3MgaXMgbm90IGludGVuZGVkIHRvIG1vZGVsCiBnZW9ncmFw
aGljYWwgbG9jYXRpb25zIGxpa2Ugcm9hZHMsIHRvd25zLCBvciBtb3VudGFpbnMuCgogSW4g
dHlwaWNhbCB1c2FnZSwgYW4gYWRkcmVzcyB3b3VsZCBiZSBjcmVhdGVkIGJ5IHVzZXIgaW5w
dXQgb3IgZnJvbSBpbXBvcnRpbmcKIGV4aXN0aW5nIGRhdGEsIGRlcGVuZGluZyBvbiB0aGUg
dHlwZSBvZiBwcm9jZXNzLgoKIEFkdmljZSBvbiBhZGRyZXNzIGlucHV0IG9yIGVkaXRpbmc6
CgogIC0gVXNlIGFuIGludGVybmF0aW9uYWxpemF0aW9uLXJlYWR5IGFkZHJlc3Mgd2lkZ2V0
IHN1Y2ggYXMKICBodHRwczovL2dpdGh1Yi5jb20vZ29vZ2xlL2xpYmFkZHJlc3NpbnB1dC4K
ICAtIFVzZXJzIHNob3VsZCBub3QgYmUgcHJlc2VudGVkIHdpdGggVUkgZWxlbWVudHMgZm9y
IGlucHV0IG9yIGVkaXRpbmcgb2YKICBmaWVsZHMgb3V0c2lkZSBjb3VudHJpZXMgd2hlcmUg
dGhhdCBmaWVsZCBpcyB1c2VkLgoKIEZvciBtb3JlIGd1aWRhbmNlIG9uIGhvdyB0byB1c2Ug
dGhpcyBzY2hlbWEsIHNlZToKIGh0dHBzOi8vc3VwcG9ydC5nb29nbGUuY29tL2J1c2luZXNz
L2Fuc3dlci82Mzk3NDc4LgoKCgoDBAABEgMpCBUKuQEKBAQAAgASAy4CFRqrASBUaGUgc2No
ZW1hIHJldmlzaW9uIG9mIHRoZSBgUG9zdGFsQWRkcmVzc2AuIFRoaXMgbXVzdCBiZSBzZXQg
dG8gMCwgd2hpY2ggaXMKIHRoZSBsYXRlc3QgcmV2aXNpb24uCgogQWxsIG5ldyByZXZpc2lv
bnMgKiptdXN0KiogYmUgYmFja3dhcmQgY29tcGF0aWJsZSB3aXRoIG9sZCByZXZpc2lvbnMu
CgoMCgUEAAIABRIDLgIHCgwKBQQAAgABEgMuCBAKDAoFBAACAAMSAy4TFArBAgoEBAACARID
NQIZGrMCIFJlcXVpcmVkLiBDTERSIHJlZ2lvbiBjb2RlIG9mIHRoZSBjb3VudHJ5L3JlZ2lv
biBvZiB0aGUgYWRkcmVzcy4gVGhpcwogaXMgbmV2ZXIgaW5mZXJyZWQgYW5kIGl0IGlzIHVw
IHRvIHRoZSB1c2VyIHRvIGVuc3VyZSB0aGUgdmFsdWUgaXMKIGNvcnJlY3QuIFNlZSBodHRw
czovL2NsZHIudW5pY29kZS5vcmcvIGFuZAogaHR0cHM6Ly93d3cudW5pY29kZS5vcmcvY2xk
ci9jaGFydHMvMzAvc3VwcGxlbWVudGFsL3RlcnJpdG9yeV9pbmZvcm1hdGlvbi5odG1sCiBm
b3IgZGV0YWlscy4gRXhhbXBsZTogIkNIIiBmb3IgU3dpdHplcmxhbmQuCgoMCgUEAAIBBRID
NQIICgwKBQQAAgEBEgM1CRQKDAoFBAACAQMSAzUXGArVBAoEBAACAhIDQwIbGscEIE9wdGlv
bmFsLiBCQ1AtNDcgbGFuZ3VhZ2UgY29kZSBvZiB0aGUgY29udGVudHMgb2YgdGhpcyBhZGRy
ZXNzIChpZgoga25vd24pLiBUaGlzIGlzIG9mdGVuIHRoZSBVSSBsYW5ndWFnZSBvZiB0aGUg
aW5wdXQgZm9ybSBvciBpcyBleHBlY3RlZAogdG8gbWF0Y2ggb25lIG9mIHRoZSBsYW5ndWFn
ZXMgdXNlZCBpbiB0aGUgYWRkcmVzcycgY291bnRyeS9yZWdpb24sIG9yIHRoZWlyCiB0cmFu
c2xpdGVyYXRlZCBlcXVpdmFsZW50cy4KIFRoaXMgY2FuIGFmZmVjdCBmb3JtYXR0aW5nIGlu
IGNlcnRhaW4gY291bnRyaWVzLCBidXQgaXMgbm90IGNyaXRpY2FsCiB0byB0aGUgY29ycmVj
dG5lc3Mgb2YgdGhlIGRhdGEgYW5kIHdpbGwgbmV2ZXIgYWZmZWN0IGFueSB2YWxpZGF0aW9u
IG9yCiBvdGhlciBub24tZm9ybWF0dGluZyByZWxhdGVkIG9wZXJhdGlvbnMuCgogSWYgdGhp
cyB2YWx1ZSBpcyBub3Qga25vd24sIGl0IHNob3VsZCBiZSBvbWl0dGVkIChyYXRoZXIgdGhh
biBzcGVjaWZ5aW5nIGEKIHBvc3NpYmx5IGluY29ycmVjdCBkZWZhdWx0KS4KCiBFeGFtcGxl
czogInpoLUhhbnQiLCAiamEiLCAiamEtTGF0biIsICJlbiIuCgoMCgUEAAICBRIDQwIICgwK
BQQAAgIBEgNDCRYKDAoFBAACAgMSA0MZGgqXAgoEBAACAxIDSQIZGokCIE9wdGlvbmFsLiBQ
b3N0YWwgY29kZSBvZiB0aGUgYWRkcmVzcy4gTm90IGFsbCBjb3VudHJpZXMgdXNlIG9yIHJl
cXVpcmUKIHBvc3RhbCBjb2RlcyB0byBiZSBwcmVzZW50LCBidXQgd2hlcmUgdGhleSBhcmUg
dXNlZCwgdGhleSBtYXkgdHJpZ2dlcgogYWRkaXRpb25hbCB2YWxpZGF0aW9uIHdpdGggb3Ro
ZXIgcGFydHMgb2YgdGhlIGFkZHJlc3MgKGZvciBleGFtcGxlLAogc3RhdGUgb3IgemlwIGNv
ZGUgdmFsaWRhdGlvbiBpbiB0aGUgVW5pdGVkIFN0YXRlcykuCgoMCgUEAAIDBRIDSQIICgwK
BQQAAgMBEgNJCRQKDAoFBAACAwMSA0kXGAr0AgoEBAACBBIDUAIaGuYCIE9wdGlvbmFsLiBB
ZGRpdGlvbmFsLCBjb3VudHJ5LXNwZWNpZmljLCBzb3J0aW5nIGNvZGUuIFRoaXMgaXMgbm90
IHVzZWQKIGluIG1vc3QgcmVnaW9ucy4gV2hlcmUgaXQgaXMgdXNlZCwgdGhlIHZhbHVlIGlz
IGVpdGhlciBhIHN0cmluZyBsaWtlCiAiQ0VERVgiLCBvcHRpb25hbGx5IGZvbGxvd2VkIGJ5
IGEgbnVtYmVyIChmb3IgZXhhbXBsZSwgIkNFREVYIDciKSwgb3IganVzdAogYSBudW1iZXIg
YWxvbmUsIHJlcHJlc2VudGluZyB0aGUgInNlY3RvciBjb2RlIiAoSmFtYWljYSksICJkZWxp
dmVyeSBhcmVhCiBpbmRpY2F0b3IiIChNYWxhd2kpIG9yICJwb3N0IG9mZmljZSBpbmRpY2F0
b3IiIChDw7R0ZSBkJ0l2b2lyZSkuCgoMCgUEAAIEBRIDUAIICgwKBQQAAgQBEgNQCRUKDAoF
BAACBAMSA1AYGQq7AwoEBAACBRIDWQIhGq0DIE9wdGlvbmFsLiBIaWdoZXN0IGFkbWluaXN0
cmF0aXZlIHN1YmRpdmlzaW9uIHdoaWNoIGlzIHVzZWQgZm9yIHBvc3RhbAogYWRkcmVzc2Vz
IG9mIGEgY291bnRyeSBvciByZWdpb24uCiBGb3IgZXhhbXBsZSwgdGhpcyBjYW4gYmUgYSBz
dGF0ZSwgYSBwcm92aW5jZSwgYW4gb2JsYXN0LCBvciBhIHByZWZlY3R1cmUuCiBGb3IgU3Bh
aW4sIHRoaXMgaXMgdGhlIHByb3ZpbmNlIGFuZCBub3QgdGhlIGF1dG9ub21vdXMKIGNvbW11
bml0eSAoZm9yIGV4YW1wbGUsICJCYXJjZWxvbmEiIGFuZCBub3QgIkNhdGFsb25pYSIpLgog
TWFueSBjb3VudHJpZXMgZG9uJ3QgdXNlIGFuIGFkbWluaXN0cmF0aXZlIGFyZWEgaW4gcG9z
dGFsIGFkZHJlc3Nlcy4gRm9yCiBleGFtcGxlLCBpbiBTd2l0emVybGFuZCwgdGhpcyBzaG91
bGQgYmUgbGVmdCB1bnBvcHVsYXRlZC4KCgwKBQQAAgUFEgNZAggKDAoFBAACBQESA1kJHAoM
CgUEAAIFAxIDWR8gCpsCCgQEAAIGEgNfAhYajQIgT3B0aW9uYWwuIEdlbmVyYWxseSByZWZl
cnMgdG8gdGhlIGNpdHkgb3IgdG93biBwb3J0aW9uIG9mIHRoZSBhZGRyZXNzLgogRXhhbXBs
ZXM6IFVTIGNpdHksIElUIGNvbXVuZSwgVUsgcG9zdCB0b3duLgogSW4gcmVnaW9ucyBvZiB0
aGUgd29ybGQgd2hlcmUgbG9jYWxpdGllcyBhcmUgbm90IHdlbGwgZGVmaW5lZCBvciBkbyBu
b3QgZml0CiBpbnRvIHRoaXMgc3RydWN0dXJlIHdlbGwsIGxlYXZlIGBsb2NhbGl0eWAgZW1w
dHkgYW5kIHVzZSBgYWRkcmVzc19saW5lc2AuCgoMCgUEAAIGBRIDXwIICgwKBQQAAgYBEgNf
CREKDAoFBAACBgMSA18UFQp0CgQEAAIHEgNjAhkaZyBPcHRpb25hbC4gU3VibG9jYWxpdHkg
b2YgdGhlIGFkZHJlc3MuCiBGb3IgZXhhbXBsZSwgdGhpcyBjYW4gYmUgYSBuZWlnaGJvcmhv
b2QsIGJvcm91Z2gsIG9yIGRpc3RyaWN0LgoKDAoFBAACBwUSA2MCCAoMCgUEAAIHARIDYwkU
CgwKBQQAAgcDEgNjFxgKigoKBAQAAggSA3wCJBr8CSBVbnN0cnVjdHVyZWQgYWRkcmVzcyBs
aW5lcyBkZXNjcmliaW5nIHRoZSBsb3dlciBsZXZlbHMgb2YgYW4gYWRkcmVzcy4KCiBCZWNh
dXNlIHZhbHVlcyBpbiBgYWRkcmVzc19saW5lc2AgZG8gbm90IGhhdmUgdHlwZSBpbmZvcm1h
dGlvbiBhbmQgbWF5CiBzb21ldGltZXMgY29udGFpbiBtdWx0aXBsZSB2YWx1ZXMgaW4gYSBz
aW5nbGUgZmllbGQgKGZvciBleGFtcGxlLAogIkF1c3RpbiwgVFgiKSwgaXQgaXMgaW1wb3J0
YW50IHRoYXQgdGhlIGxpbmUgb3JkZXIgaXMgY2xlYXIuIFRoZSBvcmRlciBvZgogYWRkcmVz
cyBsaW5lcyBzaG91bGQgYmUgImVudmVsb3BlIG9yZGVyIiBmb3IgdGhlIGNvdW50cnkgb3Ig
cmVnaW9uIG9mIHRoZQogYWRkcmVzcy4gSW4gcGxhY2VzIHdoZXJlIHRoaXMgY2FuIHZhcnkg
KGZvciBleGFtcGxlLCBKYXBhbiksCiBgYWRkcmVzc19sYW5ndWFnZWAgaXMgdXNlZCB0byBt
YWtlIGl0IGV4cGxpY2l0IChmb3IgZXhhbXBsZSwgImphIiBmb3IKIGxhcmdlLXRvLXNtYWxs
IG9yZGVyaW5nIGFuZCAiamEtTGF0biIgb3IgImVuIiBmb3Igc21hbGwtdG8tbGFyZ2UpLiBJ
biB0aGlzCiB3YXksIHRoZSBtb3N0IHNwZWNpZmljIGxpbmUgb2YgYW4gYWRkcmVzcyBjYW4g
YmUgc2VsZWN0ZWQgYmFzZWQgb24gdGhlCiBsYW5ndWFnZS4KCiBUaGUgbWluaW11bSBwZXJt
aXR0ZWQgc3RydWN0dXJhbCByZXByZXNlbnRhdGlvbiBvZiBhbiBhZGRyZXNzIGNvbnNpc3Rz
CiBvZiBhIGByZWdpb25fY29kZWAgd2l0aCBhbGwgcmVtYWluaW5nIGluZm9ybWF0aW9uIHBs
YWNlZCBpbiB0aGUKIGBhZGRyZXNzX2xpbmVzYC4gSXQgd291bGQgYmUgcG9zc2libGUgdG8g
Zm9ybWF0IHN1Y2ggYW4gYWRkcmVzcyB2ZXJ5CiBhcHByb3hpbWF0ZWx5IHdpdGhvdXQgZ2Vv
Y29kaW5nLCBidXQgbm8gc2VtYW50aWMgcmVhc29uaW5nIGNvdWxkIGJlCiBtYWRlIGFib3V0
IGFueSBvZiB0aGUgYWRkcmVzcyBjb21wb25lbnRzIHVudGlsIGl0IHdhcyBhdCBsZWFzdAog
cGFydGlhbGx5IHJlc29sdmVkLgoKIENyZWF0aW5nIGFuIGFkZHJlc3Mgb25seSBjb250YWlu
aW5nIGEgYHJlZ2lvbl9jb2RlYCBhbmQgYGFkZHJlc3NfbGluZXNgIGFuZAogdGhlbiBnZW9j
b2RpbmcgaXMgdGhlIHJlY29tbWVuZGVkIHdheSB0byBoYW5kbGUgY29tcGxldGVseSB1bnN0
cnVjdHVyZWQKIGFkZHJlc3NlcyAoYXMgb3Bwb3NlZCB0byBndWVzc2luZyB3aGljaCBwYXJ0
cyBvZiB0aGUgYWRkcmVzcyBzaG91bGQgYmUKIGxvY2FsaXRpZXMgb3IgYWRtaW5pc3RyYXRp
dmUgYXJlYXMpLgoKDAoFBAACCAQSA3wCCgoMCgUEAAIIBRIDfAsRCgwKBQQAAggBEgN8Eh8K
DAoFBAACCAMSA3wiIwq7AQoEBAACCRIEgQECIhqsASBPcHRpb25hbC4gVGhlIHJlY2lwaWVu
dCBhdCB0aGUgYWRkcmVzcy4KIFRoaXMgZmllbGQgbWF5LCB1bmRlciBjZXJ0YWluIGNpcmN1
bXN0YW5jZXMsIGNvbnRhaW4gbXVsdGlsaW5lIGluZm9ybWF0aW9uLgogRm9yIGV4YW1wbGUs
IGl0IG1pZ2h0IGNvbnRhaW4gImNhcmUgb2YiIGluZm9ybWF0aW9uLgoKDQoFBAACCQQSBIEB
AgoKDQoFBAACCQUSBIEBCxEKDQoFBAACCQESBIEBEhwKDQoFBAACCQMSBIEBHyEKRgoEBAAC
ChIEhAECGxo4IE9wdGlvbmFsLiBUaGUgbmFtZSBvZiB0aGUgb3JnYW5pemF0aW9uIGF0IHRo
ZSBhZGRyZXNzLgoKDQoFBAACCgUSBIQBAggKDQoFBAACCgESBIQBCRUKDQoFBAACCgMSBIQB
GBpiBnByb3RvMw==
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Type::PostalAddress::PostalAddress ===
    # Fields for PostalAddress
    # Field: revision Type: 5 ()
    # Field: region_code Type: 9 ()
    # Field: language_code Type: 9 ()
    # Field: postal_code Type: 9 ()
    # Field: sorting_code Type: 9 ()
    # Field: administrative_area Type: 9 ()
    # Field: locality Type: 9 ()
    # Field: sublocality Type: 9 ()
    # Field: address_lines Type: 9 ()
    # Field: recipients Type: 9 ()
    # Field: organization Type: 9 ()

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Type::PostalAddress - Compiled Protocol Buffers messages for google/type/postal_address.proto

=head1 SYNOPSIS

    use Google::Type::PostalAddress;

    my $msg = Google::Type::PostalAddress::PostalAddress->new({
        revision => $revision,
        region_code => $region_code,
        language_code => $language_code,
        postal_code => $postal_code,
    });

    # Read or update a field
    my $val = $msg->revision();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Type::PostalAddress::PostalAddress->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/type/postal_address.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Type::PostalAddress::PostalAddress

Represents a postal address, such as for postal delivery or payments
addresses. With a postal address, a postal service can deliver items to a
premise, P.O. box, or similar. A postal address is not intended to model
geographical locations like roads, towns, or mountains.

In typical usage, an address would be created by user input or from importing
existing data, depending on the type of process.

Advice on address input or editing:

 - Use an internationalization-ready address widget such as
 https://github.com/google/libaddressinput.
 - Users should not be presented with UI elements for input or editing of
 fields outside countries where that field is used.

For more guidance on how to use this schema, see:
https://support.google.com/business/answer/6397478.

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->revision() >> / C<< $msg->revision($value) >>

Type: C<Int32>

The schema revision of the `PostalAddress`. This must be set to 0, which is
the latest revision.

All new revisions B<must> be backward compatible with old revisions.

=item * C<< $msg->region_code() >> / C<< $msg->region_code($value) >>

Type: C<String>

Required. CLDR region code of the country/region of the address. This
is never inferred and it is up to the user to ensure the value is
correct. See https://cldr.unicode.org/ and
https://www.unicode.org/cldr/charts/30/supplemental/territory_information.html
for details. Example: "CH" for Switzerland.

=item * C<< $msg->language_code() >> / C<< $msg->language_code($value) >>

Type: C<String>

Optional. BCP-47 language code of the contents of this address (if
known). This is often the UI language of the input form or is expected
to match one of the languages used in the address' country/region, or their
transliterated equivalents.
This can affect formatting in certain countries, but is not critical
to the correctness of the data and will never affect any validation or
other non-formatting related operations.

If this value is not known, it should be omitted (rather than specifying a
possibly incorrect default).

Examples: "zh-Hant", "ja", "ja-Latn", "en".

=item * C<< $msg->postal_code() >> / C<< $msg->postal_code($value) >>

Type: C<String>

Optional. Postal code of the address. Not all countries use or require
postal codes to be present, but where they are used, they may trigger
additional validation with other parts of the address (for example,
state or zip code validation in the United States).

=item * C<< $msg->sorting_code() >> / C<< $msg->sorting_code($value) >>

Type: C<String>

Optional. Additional, country-specific, sorting code. This is not used
in most regions. Where it is used, the value is either a string like
"CEDEX", optionally followed by a number (for example, "CEDEX 7"), or just
a number alone, representing the "sector code" (Jamaica), "delivery area
indicator" (Malawi) or "post office indicator" (Côte d'Ivoire).

=item * C<< $msg->administrative_area() >> / C<< $msg->administrative_area($value) >>

Type: C<String>

Optional. Highest administrative subdivision which is used for postal
addresses of a country or region.
For example, this can be a state, a province, an oblast, or a prefecture.
For Spain, this is the province and not the autonomous
community (for example, "Barcelona" and not "Catalonia").
Many countries don't use an administrative area in postal addresses. For
example, in Switzerland, this should be left unpopulated.

=item * C<< $msg->locality() >> / C<< $msg->locality($value) >>

Type: C<String>

Optional. Generally refers to the city or town portion of the address.
Examples: US city, IT comune, UK post town.
In regions of the world where localities are not well defined or do not fit
into this structure well, leave `locality` empty and use `address_lines`.

=item * C<< $msg->sublocality() >> / C<< $msg->sublocality($value) >>

Type: C<String>

Optional. Sublocality of the address.
For example, this can be a neighborhood, borough, or district.

=item * C<< $msg->address_lines() >> / C<< $msg->address_lines($value) >>

Type: C<String>

Unstructured address lines describing the lower levels of an address.

Because values in `address_lines` do not have type information and may
sometimes contain multiple values in a single field (for example,
"Austin, TX"), it is important that the line order is clear. The order of
address lines should be "envelope order" for the country or region of the
address. In places where this can vary (for example, Japan),
`address_language` is used to make it explicit (for example, "ja" for
large-to-small ordering and "ja-Latn" or "en" for small-to-large). In this
way, the most specific line of an address can be selected based on the
language.

The minimum permitted structural representation of an address consists
of a `region_code` with all remaining information placed in the
`address_lines`. It would be possible to format such an address very
approximately without geocoding, but no semantic reasoning could be
made about any of the address components until it was at least
partially resolved.

Creating an address only containing a `region_code` and `address_lines` and
then geocoding is the recommended way to handle completely unstructured
addresses (as opposed to guessing which parts of the address should be
localities or administrative areas).

=item * C<< $msg->recipients() >> / C<< $msg->recipients($value) >>

Type: C<String>

Optional. The recipient at the address.
This field may, under certain circumstances, contain multiline information.
For example, it might contain "care of" information.

=item * C<< $msg->organization() >> / C<< $msg->organization($value) >>

Type: C<String>

Optional. The name of the organization at the address.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Type::PostalAddress::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

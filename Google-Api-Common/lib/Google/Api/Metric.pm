package Google::Api::Metric;

use strict;
use warnings;

our $VERSION = '0.14';

use Protobuf::Message;
use Protobuf::DescriptorPool;
use Protobuf::Internal qw(:all);
use MIME::Base64;

BEGIN {
    eval { require Google::Api::Label };
    eval { require Google::Api::LaunchStage };
    eval { require Google::Protobuf::Duration };
    my $descriptor_b64 = <<'EOF';
Chdnb29nbGUvYXBpL21ldHJpYy5wcm90bxIKZ29vZ2xlLmFwaRoWZ29vZ2xlL2FwaS9sYWJl
bC5wcm90bxodZ29vZ2xlL2FwaS9sYXVuY2hfc3RhZ2UucHJvdG8aHmdvb2dsZS9wcm90b2J1
Zi9kdXJhdGlvbi5wcm90byLwCQoQTWV0cmljRGVzY3JpcHRvchISCgRuYW1lGAEgASgJUgRu
YW1lEhIKBHR5cGUYCCABKAlSBHR5cGUSMwoGbGFiZWxzGAIgAygLMhsuZ29vZ2xlLmFwaS5M
YWJlbERlc2NyaXB0b3JSBmxhYmVscxJICgttZXRyaWNfa2luZBgDIAEoDjInLmdvb2dsZS5h
cGkuTWV0cmljRGVzY3JpcHRvci5NZXRyaWNLaW5kUgptZXRyaWNLaW5kEkUKCnZhbHVlX3R5
cGUYBCABKA4yJi5nb29nbGUuYXBpLk1ldHJpY0Rlc2NyaXB0b3IuVmFsdWVUeXBlUgl2YWx1
ZVR5cGUSEgoEdW5pdBgFIAEoCVIEdW5pdBIgCgtkZXNjcmlwdGlvbhgGIAEoCVILZGVzY3Jp
cHRpb24SIQoMZGlzcGxheV9uYW1lGAcgASgJUgtkaXNwbGF5TmFtZRJRCghtZXRhZGF0YRgK
IAEoCzI1Lmdvb2dsZS5hcGkuTWV0cmljRGVzY3JpcHRvci5NZXRyaWNEZXNjcmlwdG9yTWV0
YWRhdGFSCG1ldGFkYXRhEjoKDGxhdW5jaF9zdGFnZRgMIAEoDjIXLmdvb2dsZS5hcGkuTGF1
bmNoU3RhZ2VSC2xhdW5jaFN0YWdlEjgKGG1vbml0b3JlZF9yZXNvdXJjZV90eXBlcxgNIAMo
CVIWbW9uaXRvcmVkUmVzb3VyY2VUeXBlcxqHBAoYTWV0cmljRGVzY3JpcHRvck1ldGFkYXRh
Ej4KDGxhdW5jaF9zdGFnZRgBIAEoDjIXLmdvb2dsZS5hcGkuTGF1bmNoU3RhZ2VCAhgBUgts
YXVuY2hTdGFnZRI+Cg1zYW1wbGVfcGVyaW9kGAIgASgLMhkuZ29vZ2xlLnByb3RvYnVmLkR1
cmF0aW9uUgxzYW1wbGVQZXJpb2QSPAoMaW5nZXN0X2RlbGF5GAMgASgLMhkuZ29vZ2xlLnBy
b3RvYnVmLkR1cmF0aW9uUgtpbmdlc3REZWxheRKmAQokdGltZV9zZXJpZXNfcmVzb3VyY2Vf
aGllcmFyY2h5X2xldmVsGAQgAygOMlYuZ29vZ2xlLmFwaS5NZXRyaWNEZXNjcmlwdG9yLk1l
dHJpY0Rlc2NyaXB0b3JNZXRhZGF0YS5UaW1lU2VyaWVzUmVzb3VyY2VIaWVyYXJjaHlMZXZl
bFIgdGltZVNlcmllc1Jlc291cmNlSGllcmFyY2h5TGV2ZWwigwEKIFRpbWVTZXJpZXNSZXNv
dXJjZUhpZXJhcmNoeUxldmVsEjQKMFRJTUVfU0VSSUVTX1JFU09VUkNFX0hJRVJBUkNIWV9M
RVZFTF9VTlNQRUNJRklFRBAAEgsKB1BST0pFQ1QQARIQCgxPUkdBTklaQVRJT04QAhIKCgZG
T0xERVIQAyJPCgpNZXRyaWNLaW5kEhsKF01FVFJJQ19LSU5EX1VOU1BFQ0lGSUVEEAASCQoF
R0FVR0UQARIJCgVERUxUQRACEg4KCkNVTVVMQVRJVkUQAyJxCglWYWx1ZVR5cGUSGgoWVkFM
VUVfVFlQRV9VTlNQRUNJRklFRBAAEggKBEJPT0wQARIJCgVJTlQ2NBACEgoKBkRPVUJMRRAD
EgoKBlNUUklORxAEEhAKDERJU1RSSUJVVElPThAFEgkKBU1PTkVZEAYijwEKBk1ldHJpYxIS
CgR0eXBlGAMgASgJUgR0eXBlEjYKBmxhYmVscxgCIAMoCzIeLmdvb2dsZS5hcGkuTWV0cmlj
LkxhYmVsc0VudHJ5UgZsYWJlbHMaOQoLTGFiZWxzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkS
FAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AUJfCg5jb20uZ29vZ2xlLmFwaUILTWV0cmljUHJv
dG9QAVo3Z29vZ2xlLmdvbGFuZy5vcmcvZ2VucHJvdG8vZ29vZ2xlYXBpcy9hcGkvbWV0cmlj
O21ldHJpY6ICBEdBUElKo1YKBxIFDgCeAgEKvAQKAQwSAw4AEjKxBCBDb3B5cmlnaHQgMjAy
NiBHb29nbGUgTExDCgogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBMaWNlbnNlLCBWZXJz
aW9uIDIuMCAodGhlICJMaWNlbnNlIik7CiB5b3UgbWF5IG5vdCB1c2UgdGhpcyBmaWxlIGV4
Y2VwdCBpbiBjb21wbGlhbmNlIHdpdGggdGhlIExpY2Vuc2UuCiBZb3UgbWF5IG9idGFpbiBh
IGNvcHkgb2YgdGhlIExpY2Vuc2UgYXQKCiAgICAgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xp
Y2Vuc2VzL0xJQ0VOU0UtMi4wCgogVW5sZXNzIHJlcXVpcmVkIGJ5IGFwcGxpY2FibGUgbGF3
IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2FyZQogZGlzdHJpYnV0ZWQgdW5kZXIg
dGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKIFdJVEhP
VVQgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIEFOWSBLSU5ELCBlaXRoZXIgZXhwcmVz
cyBvciBpbXBsaWVkLgogU2VlIHRoZSBMaWNlbnNlIGZvciB0aGUgc3BlY2lmaWMgbGFuZ3Vh
Z2UgZ292ZXJuaW5nIHBlcm1pc3Npb25zIGFuZAogbGltaXRhdGlvbnMgdW5kZXIgdGhlIExp
Y2Vuc2UuCgoICgECEgMQABMKCQoCAwASAxIAIAoJCgIDARIDEwAnCgkKAgMCEgMUACgKCAoB
CBIDFgBOCgkKAggLEgMWAE4KCAoBCBIDFwAiCgkKAggKEgMXACIKCAoBCBIDGAAsCgkKAggI
EgMYACwKCAoBCBIDGQAnCgkKAggBEgMZACcKCAoBCBIDGgAiCgkKAggkEgMaACIKvwEKAgQA
EgUgAJECARqxASBEZWZpbmVzIGEgbWV0cmljIHR5cGUgYW5kIGl0cyBzY2hlbWEuIE9uY2Ug
YSBtZXRyaWMgZGVzY3JpcHRvciBpcyBjcmVhdGVkLAogZGVsZXRpbmcgb3IgYWx0ZXJpbmcg
aXQgc3RvcHMgZGF0YSBjb2xsZWN0aW9uIGFuZCBtYWtlcyB0aGUgbWV0cmljIHR5cGUncwog
ZXhpc3RpbmcgZGF0YSB1bnVzYWJsZS4KCgoKCgMEAAESAyAIGArZAQoEBAAEABIEJAI0AxrK
ASBUaGUga2luZCBvZiBtZWFzdXJlbWVudC4gSXQgZGVzY3JpYmVzIGhvdyB0aGUgZGF0YSBp
cyByZXBvcnRlZC4KIEZvciBpbmZvcm1hdGlvbiBvbiBzZXR0aW5nIHRoZSBzdGFydCB0aW1l
IGFuZCBlbmQgdGltZSBiYXNlZCBvbgogdGhlIE1ldHJpY0tpbmQsIHNlZSBbVGltZUludGVy
dmFsXVtnb29nbGUubW9uaXRvcmluZy52My5UaW1lSW50ZXJ2YWxdLgoKDAoFBAAEAAESAyQH
EQovCgYEAAQAAgASAyYEIBogIERvIG5vdCB1c2UgdGhpcyBkZWZhdWx0IHZhbHVlLgoKDgoH
BAAEAAIAARIDJgQbCg4KBwQABAACAAISAyYeHwo5CgYEAAQAAgESAykEDhoqIEFuIGluc3Rh
bnRhbmVvdXMgbWVhc3VyZW1lbnQgb2YgYSB2YWx1ZS4KCg4KBwQABAACAQESAykECQoOCgcE
AAQAAgECEgMpDA0KPgoGBAAEAAICEgMsBA4aLyBUaGUgY2hhbmdlIGluIGEgdmFsdWUgZHVy
aW5nIGEgdGltZSBpbnRlcnZhbC4KCg4KBwQABAACAgESAywECQoOCgcEAAQAAgICEgMsDA0K
igIKBgQABAACAxIDMwQTGvoBIEEgdmFsdWUgYWNjdW11bGF0ZWQgb3ZlciBhIHRpbWUgaW50
ZXJ2YWwuICBDdW11bGF0aXZlCiBtZWFzdXJlbWVudHMgaW4gYSB0aW1lIHNlcmllcyBzaG91
bGQgaGF2ZSB0aGUgc2FtZSBzdGFydCB0aW1lCiBhbmQgaW5jcmVhc2luZyBlbmQgdGltZXMs
IHVudGlsIGFuIGV2ZW50IHJlc2V0cyB0aGUgY3VtdWxhdGl2ZQogdmFsdWUgdG8gemVybyBh
bmQgc2V0cyBhIG5ldyBzdGFydCB0aW1lIGZvciB0aGUgZm9sbG93aW5nCiBwb2ludHMuCgoO
CgcEAAQAAgMBEgMzBA4KDgoHBAAEAAIDAhIDMxESCisKBAQABAESBDcCTgMaHSBUaGUgdmFs
dWUgdHlwZSBvZiBhIG1ldHJpYy4KCgwKBQQABAEBEgM3BxAKLwoGBAAEAQIAEgM5BB8aICBE
byBub3QgdXNlIHRoaXMgZGVmYXVsdCB2YWx1ZS4KCg4KBwQABAECAAESAzkEGgoOCgcEAAQB
AgACEgM5HR4KaQoGBAAEAQIBEgM9BA0aWiBUaGUgdmFsdWUgaXMgYSBib29sZWFuLgogVGhp
cyB2YWx1ZSB0eXBlIGNhbiBiZSB1c2VkIG9ubHkgaWYgdGhlIG1ldHJpYyBraW5kIGlzIGBH
QVVHRWAuCgoOCgcEAAQBAgEBEgM9BAgKDgoHBAAEAQIBAhIDPQsMCjYKBgQABAECAhIDQAQO
GicgVGhlIHZhbHVlIGlzIGEgc2lnbmVkIDY0LWJpdCBpbnRlZ2VyLgoKDgoHBAAEAQICARID
QAQJCg4KBwQABAECAgISA0AMDQpHCgYEAAQBAgMSA0MEDxo4IFRoZSB2YWx1ZSBpcyBhIGRv
dWJsZSBwcmVjaXNpb24gZmxvYXRpbmcgcG9pbnQgbnVtYmVyLgoKDgoHBAAEAQIDARIDQwQK
Cg4KBwQABAECAwISA0MNDgptCgYEAAQBAgQSA0cEDxpeIFRoZSB2YWx1ZSBpcyBhIHRleHQg
c3RyaW5nLgogVGhpcyB2YWx1ZSB0eXBlIGNhbiBiZSB1c2VkIG9ubHkgaWYgdGhlIG1ldHJp
YyBraW5kIGlzIGBHQVVHRWAuCgoOCgcEAAQBAgQBEgNHBAoKDgoHBAAEAQIEAhIDRw0OCkoK
BgQABAECBRIDSgQVGjsgVGhlIHZhbHVlIGlzIGEgW2BEaXN0cmlidXRpb25gXVtnb29nbGUu
YXBpLkRpc3RyaWJ1dGlvbl0uCgoOCgcEAAQBAgUBEgNKBBAKDgoHBAAEAQIFAhIDShMUCiQK
BgQABAECBhIDTQQOGhUgVGhlIHZhbHVlIGlzIG1vbmV5LgoKDgoHBAAEAQIGARIDTQQJCg4K
BwQABAECBgISA00MDQpXCgQEAAMAEgRRAnQDGkkgQWRkaXRpb25hbCBhbm5vdGF0aW9ucyB0
aGF0IGNhbiBiZSB1c2VkIHRvIGd1aWRlIHRoZSB1c2FnZSBvZiBhIG1ldHJpYy4KCgwKBQQA
AwABEgNRCiIKUgoGBAADAAQAEgRTBF8FGkIgVGhlIHJlc291cmNlIGhpZXJhcmNoeSBsZXZl
bCBvZiB0aGUgdGltZXNlcmllcyBkYXRhIG9mIGEgbWV0cmljLgoKDgoHBAADAAQAARIDUwkp
CjEKCAQAAwAEAAIAEgNVBjsaICBEbyBub3QgdXNlIHRoaXMgZGVmYXVsdCB2YWx1ZS4KChAK
CQQAAwAEAAIAARIDVQY2ChAKCQQAAwAEAAIAAhIDVTk6CjAKCAQAAwAEAAIBEgNYBhIaHyBT
Y29wZXMgYSBtZXRyaWMgdG8gYSBwcm9qZWN0LgoKEAoJBAADAAQAAgEBEgNYBg0KEAoJBAAD
AAQAAgECEgNYEBEKNgoIBAADAAQAAgISA1sGFxolIFNjb3BlcyBhIG1ldHJpYyB0byBhbiBv
cmdhbml6YXRpb24uCgoQCgkEAAMABAACAgESA1sGEgoQCgkEAAMABAACAgISA1sVFgovCggE
AAMABAACAxIDXgYRGh4gU2NvcGVzIGEgbWV0cmljIHRvIGEgZm9sZGVyLgoKEAoJBAADAAQA
AgMBEgNeBgwKEAoJBAADAAQAAgMCEgNeDxAKfgoGBAADAAIAEgNkBDUabyBEZXByZWNhdGVk
LiBNdXN0IHVzZSB0aGUKIFtNZXRyaWNEZXNjcmlwdG9yLmxhdW5jaF9zdGFnZV1bZ29vZ2xl
LmFwaS5NZXRyaWNEZXNjcmlwdG9yLmxhdW5jaF9zdGFnZV0KIGluc3RlYWQuCgoOCgcEAAMA
AgAGEgNkBA8KDgoHBAADAAIAARIDZBAcCg4KBwQAAwACAAMSA2QfIAoOCgcEAAMAAgAIEgNk
ITQKDwoIBAADAAIACAMSA2QiMwqKAgoGBAADAAIBEgNqBC8a+gEgVGhlIHNhbXBsaW5nIHBl
cmlvZCBvZiBtZXRyaWMgZGF0YSBwb2ludHMuIEZvciBtZXRyaWNzIHdoaWNoIGFyZSB3cml0
dGVuCiBwZXJpb2RpY2FsbHksIGNvbnNlY3V0aXZlIGRhdGEgcG9pbnRzIGFyZSBzdG9yZWQg
YXQgdGhpcyB0aW1lIGludGVydmFsLAogZXhjbHVkaW5nIGRhdGEgbG9zcyBkdWUgdG8gZXJy
b3JzLiBNZXRyaWNzIHdpdGggYSBoaWdoZXIgZ3JhbnVsYXJpdHkgaGF2ZQogYSBzbWFsbGVy
IHNhbXBsaW5nIHBlcmlvZC4KCg4KBwQAAwACAQYSA2oEHAoOCgcEAAMAAgEBEgNqHSoKDgoH
BAADAAIBAxIDai0uCrwBCgYEAAMAAgISA28ELhqsASBUaGUgZGVsYXkgb2YgZGF0YSBwb2lu
dHMgY2F1c2VkIGJ5IGluZ2VzdGlvbi4gRGF0YSBwb2ludHMgb2xkZXIgdGhhbiB0aGlzCiBh
Z2UgYXJlIGd1YXJhbnRlZWQgdG8gYmUgaW5nZXN0ZWQgYW5kIGF2YWlsYWJsZSB0byBiZSBy
ZWFkLCBleGNsdWRpbmcKIGRhdGEgbG9zcyBkdWUgdG8gZXJyb3JzLgoKDgoHBAADAAICBhID
bwQcCg4KBwQAAwACAgESA28dKQoOCgcEAAMAAgIDEgNvLC0KQQoGBAADAAIDEgRyBHMxGjEg
VGhlIHNjb3BlIG9mIHRoZSB0aW1lc2VyaWVzIGRhdGEgb2YgdGhlIG1ldHJpYy4KCg4KBwQA
AwACAwQSA3IEDAoOCgcEAAMAAgMGEgNyDS0KDgoHBAADAAIDARIDcwgsCg4KBwQAAwACAwMS
A3MvMAo6CgQEAAIAEgN3AhIaLSBUaGUgcmVzb3VyY2UgbmFtZSBvZiB0aGUgbWV0cmljIGRl
c2NyaXB0b3IuCgoMCgUEAAIABRIDdwIICgwKBQQAAgABEgN3CQ0KDAoFBAACAAMSA3cQEQqq
AwoEBAACARIEgQECEhqbAyBUaGUgbWV0cmljIHR5cGUsIGluY2x1ZGluZyBpdHMgRE5TIG5h
bWUgcHJlZml4LiBUaGUgdHlwZSBpcyBub3QKIFVSTC1lbmNvZGVkLiBBbGwgdXNlci1kZWZp
bmVkIG1ldHJpYyB0eXBlcyBoYXZlIHRoZSBETlMgbmFtZQogYGN1c3RvbS5nb29nbGVhcGlz
LmNvbWAgb3IgYGV4dGVybmFsLmdvb2dsZWFwaXMuY29tYC4gTWV0cmljIHR5cGVzIHNob3Vs
ZAogdXNlIGEgbmF0dXJhbCBoaWVyYXJjaGljYWwgZ3JvdXBpbmcuIEZvciBleGFtcGxlOgoK
ICAgICAiY3VzdG9tLmdvb2dsZWFwaXMuY29tL2ludm9pY2UvcGFpZC9hbW91bnQiCiAgICAg
ImV4dGVybmFsLmdvb2dsZWFwaXMuY29tL3Byb21ldGhldXMvdXAiCiAgICAgImFwcGVuZ2lu
ZS5nb29nbGVhcGlzLmNvbS9odHRwL3NlcnZlci9yZXNwb25zZV9sYXRlbmNpZXMiCgoNCgUE
AAIBBRIEgQECCAoNCgUEAAIBARIEgQEJDQoNCgUEAAIBAxIEgQEQEQrWAgoEBAACAhIEiQEC
JhrHAiBUaGUgc2V0IG9mIGxhYmVscyB0aGF0IGNhbiBiZSB1c2VkIHRvIGRlc2NyaWJlIGEg
c3BlY2lmaWMKIGluc3RhbmNlIG9mIHRoaXMgbWV0cmljIHR5cGUuIEZvciBleGFtcGxlLCB0
aGUKIGBhcHBlbmdpbmUuZ29vZ2xlYXBpcy5jb20vaHR0cC9zZXJ2ZXIvcmVzcG9uc2VfbGF0
ZW5jaWVzYCBtZXRyaWMKIHR5cGUgaGFzIGEgbGFiZWwgZm9yIHRoZSBIVFRQIHJlc3BvbnNl
IGNvZGUsIGByZXNwb25zZV9jb2RlYCwgc28KIHlvdSBjYW4gbG9vayBhdCBsYXRlbmNpZXMg
Zm9yIHN1Y2Nlc3NmdWwgcmVzcG9uc2VzIG9yIGp1c3QKIGZvciByZXNwb25zZXMgdGhhdCBm
YWlsZWQuCgoNCgUEAAICBBIEiQECCgoNCgUEAAICBhIEiQELGgoNCgUEAAICARIEiQEbIQoN
CgUEAAICAxIEiQEkJQqnAQoEBAACAxIEjQECHRqYASBXaGV0aGVyIHRoZSBtZXRyaWMgcmVj
b3JkcyBpbnN0YW50YW5lb3VzIHZhbHVlcywgY2hhbmdlcyB0byBhIHZhbHVlLCBldGMuCiBT
b21lIGNvbWJpbmF0aW9ucyBvZiBgbWV0cmljX2tpbmRgIGFuZCBgdmFsdWVfdHlwZWAgbWln
aHQgbm90IGJlIHN1cHBvcnRlZC4KCg0KBQQAAgMGEgSNAQIMCg0KBQQAAgMBEgSNAQ0YCg0K
BQQAAgMDEgSNARscCqIBCgQEAAIEEgSRAQIbGpMBIFdoZXRoZXIgdGhlIG1lYXN1cmVtZW50
IGlzIGFuIGludGVnZXIsIGEgZmxvYXRpbmctcG9pbnQgbnVtYmVyLCBldGMuCiBTb21lIGNv
bWJpbmF0aW9ucyBvZiBgbWV0cmljX2tpbmRgIGFuZCBgdmFsdWVfdHlwZWAgbWlnaHQgbm90
IGJlIHN1cHBvcnRlZC4KCg0KBQQAAgQGEgSRAQILCg0KBQQAAgQBEgSRAQwWCg0KBQQAAgQD
EgSRARkaCsoeCgQEAAIFEgT5AQISGrseIFRoZSB1bml0cyBpbiB3aGljaCB0aGUgbWV0cmlj
IHZhbHVlIGlzIHJlcG9ydGVkLiBJdCBpcyBvbmx5IGFwcGxpY2FibGUKIGlmIHRoZSBgdmFs
dWVfdHlwZWAgaXMgYElOVDY0YCwgYERPVUJMRWAsIG9yIGBESVNUUklCVVRJT05gLiBUaGUg
YHVuaXRgCiBkZWZpbmVzIHRoZSByZXByZXNlbnRhdGlvbiBvZiB0aGUgc3RvcmVkIG1ldHJp
YyB2YWx1ZXMuCgogRGlmZmVyZW50IHN5c3RlbXMgbWlnaHQgc2NhbGUgdGhlIHZhbHVlcyB0
byBiZSBtb3JlIGVhc2lseSBkaXNwbGF5ZWQgKHNvIGEKIHZhbHVlIG9mIGAwLjAya0J5YCBf
bWlnaHRfIGJlIGRpc3BsYXllZCBhcyBgMjBCeWAsIGFuZCBhIHZhbHVlIG9mCiBgMzUyM2tC
eWAgX21pZ2h0XyBiZSBkaXNwbGF5ZWQgYXMgYDMuNU1CeWApLiBIb3dldmVyLCBpZiB0aGUg
YHVuaXRgIGlzCiBga0J5YCwgdGhlbiB0aGUgdmFsdWUgb2YgdGhlIG1ldHJpYyBpcyBhbHdh
eXMgaW4gdGhvdXNhbmRzIG9mIGJ5dGVzLCBubwogbWF0dGVyIGhvdyBpdCBtaWdodCBiZSBk
aXNwbGF5ZWQuCgogSWYgeW91IHdhbnQgYSBjdXN0b20gbWV0cmljIHRvIHJlY29yZCB0aGUg
ZXhhY3QgbnVtYmVyIG9mIENQVS1zZWNvbmRzIHVzZWQKIGJ5IGEgam9iLCB5b3UgY2FuIGNy
ZWF0ZSBhbiBgSU5UNjQgQ1VNVUxBVElWRWAgbWV0cmljIHdob3NlIGB1bml0YCBpcwogYHN7
Q1BVfWAgKG9yIGVxdWl2YWxlbnRseSBgMXN7Q1BVfWAgb3IganVzdCBgc2ApLiBJZiB0aGUg
am9iIHVzZXMgMTIsMDA1CiBDUFUtc2Vjb25kcywgdGhlbiB0aGUgdmFsdWUgaXMgd3JpdHRl
biBhcyBgMTIwMDVgLgoKIEFsdGVybmF0aXZlbHksIGlmIHlvdSB3YW50IGEgY3VzdG9tIG1l
dHJpYyB0byByZWNvcmQgZGF0YSBpbiBhIG1vcmUKIGdyYW51bGFyIHdheSwgeW91IGNhbiBj
cmVhdGUgYSBgRE9VQkxFIENVTVVMQVRJVkVgIG1ldHJpYyB3aG9zZSBgdW5pdGAgaXMKIGBr
c3tDUFV9YCwgYW5kIHRoZW4gd3JpdGUgdGhlIHZhbHVlIGAxMi4wMDVgICh3aGljaCBpcyBg
MTIwMDUvMTAwMGApLAogb3IgdXNlIGBLaXN7Q1BVfWAgYW5kIHdyaXRlIGAxMS43MjNgICh3
aGljaCBpcyBgMTIwMDUvMTAyNGApLgoKIFRoZSBzdXBwb3J0ZWQgdW5pdHMgYXJlIGEgc3Vi
c2V0IG9mIFtUaGUgVW5pZmllZCBDb2RlIGZvciBVbml0cyBvZgogTWVhc3VyZV0oaHR0cHM6
Ly91bml0c29mbWVhc3VyZS5vcmcvdWN1bS5odG1sKSBzdGFuZGFyZDoKCiAqKkJhc2ljIHVu
aXRzIChVTklUKSoqCgogKiBgYml0YCAgIGJpdAogKiBgQnlgICAgIGJ5dGUKICogYHNgICAg
ICBzZWNvbmQKICogYG1pbmAgICBtaW51dGUKICogYGhgICAgICBob3VyCiAqIGBkYCAgICAg
ZGF5CiAqIGAxYCAgICAgZGltZW5zaW9ubGVzcwoKICoqUHJlZml4ZXMgKFBSRUZJWCkqKgoK
ICogYGtgICAgICBraWxvICAgICgxMF4zKQogKiBgTWAgICAgIG1lZ2EgICAgKDEwXjYpCiAq
IGBHYCAgICAgZ2lnYSAgICAoMTBeOSkKICogYFRgICAgICB0ZXJhICAgICgxMF4xMikKICog
YFBgICAgICBwZXRhICAgICgxMF4xNSkKICogYEVgICAgICBleGEgICAgICgxMF4xOCkKICog
YFpgICAgICB6ZXR0YSAgICgxMF4yMSkKICogYFlgICAgICB5b3R0YSAgICgxMF4yNCkKCiAq
IGBtYCAgICAgbWlsbGkgICAoMTBeLTMpCiAqIGB1YCAgICAgbWljcm8gICAoMTBeLTYpCiAq
IGBuYCAgICAgbmFubyAgICAoMTBeLTkpCiAqIGBwYCAgICAgcGljbyAgICAoMTBeLTEyKQog
KiBgZmAgICAgIGZlbXRvICAgKDEwXi0xNSkKICogYGFgICAgICBhdHRvICAgICgxMF4tMTgp
CiAqIGB6YCAgICAgemVwdG8gICAoMTBeLTIxKQogKiBgeWAgICAgIHlvY3RvICAgKDEwXi0y
NCkKCiAqIGBLaWAgICAga2liaSAgICAoMl4xMCkKICogYE1pYCAgICBtZWJpICAgICgyXjIw
KQogKiBgR2lgICAgIGdpYmkgICAgKDJeMzApCiAqIGBUaWAgICAgdGViaSAgICAoMl40MCkK
ICogYFBpYCAgICBwZWJpICAgICgyXjUwKQoKICoqR3JhbW1hcioqCgogVGhlIGdyYW1tYXIg
YWxzbyBpbmNsdWRlcyB0aGVzZSBjb25uZWN0b3JzOgoKICogYC9gICAgIGRpdmlzaW9uIG9y
IHJhdGlvIChhcyBhbiBpbmZpeCBvcGVyYXRvcikuIEZvciBleGFtcGxlcywKICAgICAgICAg
IGBrQnkve2VtYWlsfWAgb3IgYE1pQnkvMTBtc2AgKGFsdGhvdWdoIHlvdSBzaG91bGQgYWxt
b3N0IG5ldmVyCiAgICAgICAgICBoYXZlIGAvc2AgaW4gYSBtZXRyaWMgYHVuaXRgOyByYXRl
cyBzaG91bGQgYWx3YXlzIGJlIGNvbXB1dGVkIGF0CiAgICAgICAgICBxdWVyeSB0aW1lIGZy
b20gdGhlIHVuZGVybHlpbmcgY3VtdWxhdGl2ZSBvciBkZWx0YSB2YWx1ZSkuCiAqIGAuYCAg
ICBtdWx0aXBsaWNhdGlvbiBvciBjb21wb3NpdGlvbiAoYXMgYW4gaW5maXggb3BlcmF0b3Ip
LiBGb3IKICAgICAgICAgIGV4YW1wbGVzLCBgR0J5LmRgIG9yIGBre3dhdHR9LmhgLgoKIFRo
ZSBncmFtbWFyIGZvciBhIHVuaXQgaXMgYXMgZm9sbG93czoKCiAgICAgRXhwcmVzc2lvbiA9
IENvbXBvbmVudCB7ICIuIiBDb21wb25lbnQgfSB7ICIvIiBDb21wb25lbnQgfSA7CgogICAg
IENvbXBvbmVudCA9ICggWyBQUkVGSVggXSBVTklUIHwgIiUiICkgWyBBbm5vdGF0aW9uIF0K
ICAgICAgICAgICAgICAgfCBBbm5vdGF0aW9uCiAgICAgICAgICAgICAgIHwgIjEiCiAgICAg
ICAgICAgICAgIDsKCiAgICAgQW5ub3RhdGlvbiA9ICJ7IiBOQU1FICJ9IiA7CgogTm90ZXM6
CgogKiBgQW5ub3RhdGlvbmAgaXMganVzdCBhIGNvbW1lbnQgaWYgaXQgZm9sbG93cyBhIGBV
TklUYC4gSWYgdGhlIGFubm90YXRpb24KICAgIGlzIHVzZWQgYWxvbmUsIHRoZW4gdGhlIHVu
aXQgaXMgZXF1aXZhbGVudCB0byBgMWAuIEZvciBleGFtcGxlcywKICAgIGB7cmVxdWVzdH0v
cyA9PSAxL3NgLCBgQnl7dHJhbnNtaXR0ZWR9L3MgPT0gQnkvc2AuCiAqIGBOQU1FYCBpcyBh
IHNlcXVlbmNlIG9mIG5vbi1ibGFuayBwcmludGFibGUgQVNDSUkgY2hhcmFjdGVycyBub3QK
ICAgIGNvbnRhaW5pbmcgYHtgIG9yIGB9YC4KICogYDFgIHJlcHJlc2VudHMgYSB1bml0YXJ5
IFtkaW1lbnNpb25sZXNzCiAgICB1bml0XShodHRwczovL2VuLndpa2lwZWRpYS5vcmcvd2lr
aS9EaW1lbnNpb25sZXNzX3F1YW50aXR5KSBvZiAxLCBzdWNoCiAgICBhcyBpbiBgMS9zYC4g
SXQgaXMgdHlwaWNhbGx5IHVzZWQgd2hlbiBub25lIG9mIHRoZSBiYXNpYyB1bml0cyBhcmUK
ICAgIGFwcHJvcHJpYXRlLiBGb3IgZXhhbXBsZSwgIm5ldyB1c2VycyBwZXIgZGF5IiBjYW4g
YmUgcmVwcmVzZW50ZWQgYXMKICAgIGAxL2RgIG9yIGB7bmV3LXVzZXJzfS9kYCAoYW5kIGEg
bWV0cmljIHZhbHVlIGA1YCB3b3VsZCBtZWFuICI1IG5ldwogICAgdXNlcnMpLiBBbHRlcm5h
dGl2ZWx5LCAidGhvdXNhbmRzIG9mIHBhZ2Ugdmlld3MgcGVyIGRheSIgd291bGQgYmUKICAg
IHJlcHJlc2VudGVkIGFzIGAxMDAwL2RgIG9yIGBrMS9kYCBvciBga3twYWdlX3ZpZXdzfS9k
YCAoYW5kIGEgbWV0cmljCiAgICB2YWx1ZSBvZiBgNS4zYCB3b3VsZCBtZWFuICI1MzAwIHBh
Z2Ugdmlld3MgcGVyIGRheSIpLgogKiBgJWAgcmVwcmVzZW50cyBkaW1lbnNpb25sZXNzIHZh
bHVlIG9mIDEvMTAwLCBhbmQgYW5ub3RhdGVzIHZhbHVlcyBnaXZpbmcKICAgIGEgcGVyY2Vu
dGFnZSAoc28gdGhlIG1ldHJpYyB2YWx1ZXMgYXJlIHR5cGljYWxseSBpbiB0aGUgcmFuZ2Ug
b2YgMC4uMTAwLAogICAgYW5kIGEgbWV0cmljIHZhbHVlIGAzYCBtZWFucyAiMyBwZXJjZW50
IikuCiAqIGAxMF4yLiVgIGluZGljYXRlcyBhIG1ldHJpYyBjb250YWlucyBhIHJhdGlvLCB0
eXBpY2FsbHkgaW4gdGhlIHJhbmdlCiAgICAwLi4xLCB0aGF0IHdpbGwgYmUgbXVsdGlwbGll
ZCBieSAxMDAgYW5kIGRpc3BsYXllZCBhcyBhIHBlcmNlbnRhZ2UKICAgIChzbyBhIG1ldHJp
YyB2YWx1ZSBgMC4wM2AgbWVhbnMgIjMgcGVyY2VudCIpLgoKDQoFBAACBQUSBPkBAggKDQoF
BAACBQESBPkBCQ0KDQoFBAACBQMSBPkBEBEKWQoEBAACBhIE/AECGRpLIEEgZGV0YWlsZWQg
ZGVzY3JpcHRpb24gb2YgdGhlIG1ldHJpYywgd2hpY2ggY2FuIGJlIHVzZWQgaW4gZG9jdW1l
bnRhdGlvbi4KCg0KBQQAAgYFEgT8AQIICg0KBQQAAgYBEgT8AQkUCg0KBQQAAgYDEgT8ARcY
CqMCCgQEAAIHEgSCAgIaGpQCIEEgY29uY2lzZSBuYW1lIGZvciB0aGUgbWV0cmljLCB3aGlj
aCBjYW4gYmUgZGlzcGxheWVkIGluIHVzZXIgaW50ZXJmYWNlcy4KIFVzZSBzZW50ZW5jZSBj
YXNlIHdpdGhvdXQgYW4gZW5kaW5nIHBlcmlvZCwgZm9yIGV4YW1wbGUgIlJlcXVlc3QgY291
bnQiLgogVGhpcyBmaWVsZCBpcyBvcHRpb25hbCBidXQgaXQgaXMgcmVjb21tZW5kZWQgdG8g
YmUgc2V0IGZvciBhbnkgbWV0cmljcwogYXNzb2NpYXRlZCB3aXRoIHVzZXItdmlzaWJsZSBj
b25jZXB0cywgc3VjaCBhcyBRdW90YS4KCg0KBQQAAgcFEgSCAgIICg0KBQQAAgcBEgSCAgkV
Cg0KBQQAAgcDEgSCAhgZClIKBAQAAggSBIUCAikaRCBPcHRpb25hbC4gTWV0YWRhdGEgd2hp
Y2ggY2FuIGJlIHVzZWQgdG8gZ3VpZGUgdXNhZ2Ugb2YgdGhlIG1ldHJpYy4KCg0KBQQAAggG
EgSFAgIaCg0KBQQAAggBEgSFAhsjCg0KBQQAAggDEgSFAiYoCkQKBAQAAgkSBIgCAiAaNiBP
cHRpb25hbC4gVGhlIGxhdW5jaCBzdGFnZSBvZiB0aGUgbWV0cmljIGRlZmluaXRpb24uCgoN
CgUEAAIJBhIEiAICDQoNCgUEAAIJARIEiAIOGgoNCgUEAAIJAxIEiAIdHwrVAgoEBAACChIE
kAICMBrGAiBSZWFkLW9ubHkuIElmIHByZXNlbnQsIHRoZW4gYSBbdGltZQogc2VyaWVzXVtn
b29nbGUubW9uaXRvcmluZy52My5UaW1lU2VyaWVzXSwgd2hpY2ggaXMgaWRlbnRpZmllZCBw
YXJ0aWFsbHkgYnkKIGEgbWV0cmljIHR5cGUgYW5kIGEKIFtNb25pdG9yZWRSZXNvdXJjZURl
c2NyaXB0b3JdW2dvb2dsZS5hcGkuTW9uaXRvcmVkUmVzb3VyY2VEZXNjcmlwdG9yXSwgdGhh
dAogaXMgYXNzb2NpYXRlZCB3aXRoIHRoaXMgbWV0cmljIHR5cGUgY2FuIG9ubHkgYmUgYXNz
b2NpYXRlZCB3aXRoIG9uZSBvZiB0aGUKIG1vbml0b3JlZCByZXNvdXJjZSB0eXBlcyBsaXN0
ZWQgaGVyZS4KCg0KBQQAAgoEEgSQAgIKCg0KBQQAAgoFEgSQAgsRCg0KBQQAAgoBEgSQAhIq
Cg0KBQQAAgoDEgSQAi0vCpIBCgIEARIGlQIAngIBGoMBIEEgc3BlY2lmaWMgbWV0cmljLCBp
ZGVudGlmaWVkIGJ5IHNwZWNpZnlpbmcgdmFsdWVzIGZvciBhbGwgb2YgdGhlCiBsYWJlbHMg
b2YgYSBbYE1ldHJpY0Rlc2NyaXB0b3JgXVtnb29nbGUuYXBpLk1ldHJpY0Rlc2NyaXB0b3Jd
LgoKCwoDBAEBEgSVAggOCqUBCgQEAQIAEgSZAgISGpYBIEFuIGV4aXN0aW5nIG1ldHJpYyB0
eXBlLCBzZWUKIFtnb29nbGUuYXBpLk1ldHJpY0Rlc2NyaXB0b3JdW2dvb2dsZS5hcGkuTWV0
cmljRGVzY3JpcHRvcl0uIEZvciBleGFtcGxlLAogYGN1c3RvbS5nb29nbGVhcGlzLmNvbS9p
bnZvaWNlL3BhaWQvYW1vdW50YC4KCg0KBQQBAgAFEgSZAgIICg0KBQQBAgABEgSZAgkNCg0K
BQQBAgADEgSZAhARCpIBCgQEAQIBEgSdAgIhGoMBIFRoZSBzZXQgb2YgbGFiZWwgdmFsdWVz
IHRoYXQgdW5pcXVlbHkgaWRlbnRpZnkgdGhpcyBtZXRyaWMuIEFsbAogbGFiZWxzIGxpc3Rl
ZCBpbiB0aGUgYE1ldHJpY0Rlc2NyaXB0b3JgIG11c3QgYmUgYXNzaWduZWQgdmFsdWVzLgoK
DQoFBAECAQYSBJ0CAhUKDQoFBAECAQESBJ0CFhwKDQoFBAECAQMSBJ0CHyBiBnByb3RvMw==

EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Api::Metric::MetricDescriptor ===
    # Fields for MetricDescriptor
    # Field: name Type: 9 ()
    # Field: type Type: 9 ()
    # Field: labels Type: 11 (.google.api.LabelDescriptor)
    # Field: metric_kind Type: 14 (.google.api.MetricDescriptor.MetricKind)
    # Field: value_type Type: 14 (.google.api.MetricDescriptor.ValueType)
    # Field: unit Type: 9 ()
    # Field: description Type: 9 ()
    # Field: display_name Type: 9 ()
    # Field: metadata Type: 11 (.google.api.MetricDescriptor.MetricDescriptorMetadata)
    # Field: launch_stage Type: 14 (.google.api.LaunchStage)
    # Field: monitored_resource_types Type: 9 ()

# Enum: MetricDescriptor::MetricKind
our $MetricDescriptor_METRIC_KIND_UNSPECIFIED = 0;
our $MetricDescriptor_GAUGE = 1;
our $MetricDescriptor_DELTA = 2;
our $MetricDescriptor_CUMULATIVE = 3;

# Enum: MetricDescriptor::ValueType
our $MetricDescriptor_VALUE_TYPE_UNSPECIFIED = 0;
our $MetricDescriptor_BOOL = 1;
our $MetricDescriptor_INT64 = 2;
our $MetricDescriptor_DOUBLE = 3;
our $MetricDescriptor_STRING = 4;
our $MetricDescriptor_DISTRIBUTION = 5;
our $MetricDescriptor_MONEY = 6;

# === Message: Google::Api::Metric::Metric ===
    # Fields for Metric
    # Field: type Type: 9 ()
    # Field: labels Type: 11 (.google.api.Metric.LabelsEntry)

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Metric - Compiled Protocol Buffers messages for google/api/metric.proto

=head1 SYNOPSIS

    use Google::Api::Metric;

    my $msg = Google::Api::Metric::MetricDescriptor->new({
        name => $name,
        type => $type,
        labels => $labels,
        metric_kind => $metric_kind,
    });

    # Read or update a field
    my $val = $msg->name();

    # Binary wire-format roundtrip
    my $bytes   = $msg->serialize();
    my $decoded = Google::Api::Metric::MetricDescriptor->parse($bytes);

    # Canonical ProtoJSON
    my $json = $msg->to_json();

=head1 DESCRIPTION

Auto-generated L<Protobuf> message classes compiled from C<google/api/metric.proto>. All message classes inherit from
L<Protobuf::Message> and support C<new()>, C<serialize()>, C<parse()>,
C<to_json()>, C<from_json()>, C<to_text()>, and C<to_perl()>.

=head1 MESSAGES

=head2 Google::Api::Metric::MetricDescriptor

Defines a metric type and its schema. Once a metric descriptor is created,
deleting or altering it stops data collection and makes the metric type's
existing data unusable.


Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->name() >> / C<< $msg->name($value) >>

Type: C<String>

The resource name of the metric descriptor.

=item * C<< $msg->type() >> / C<< $msg->type($value) >>

Type: C<String>

The metric type, including its DNS name prefix. The type is not
URL-encoded. All user-defined metric types have the DNS name
`custom.googleapis.com` or `external.googleapis.com`. Metric types should
use a natural hierarchical grouping. For example:

    "custom.googleapis.com/invoice/paid/amount"
    "external.googleapis.com/prometheus/up"
    "appengine.googleapis.com/http/server/response_latencies"

=item * C<< $msg->labels() >> / C<< $msg->labels($value) >>

Type: C<Message> (L<Google::Api::Label::LabelDescriptor>)

The set of labels that can be used to describe a specific
instance of this metric type. For example, the
`appengine.googleapis.com/http/server/response_latencies` metric
type has a label for the HTTP response code, `response_code`, so
you can look at latencies for successful responses or just
for responses that failed.

=item * C<< $msg->metric_kind() >> / C<< $msg->metric_kind($value) >>

Type: C<Enum> (L<Google::Api::MetricDescriptor::MetricKind>)

Whether the metric records instantaneous values, changes to a value, etc.
Some combinations of `metric_kind` and `value_type` might not be supported.

=item * C<< $msg->value_type() >> / C<< $msg->value_type($value) >>

Type: C<Enum> (L<Google::Api::MetricDescriptor::ValueType>)

Whether the measurement is an integer, a floating-point number, etc.
Some combinations of `metric_kind` and `value_type` might not be supported.

=item * C<< $msg->unit() >> / C<< $msg->unit($value) >>

Type: C<String>

The units in which the metric value is reported. It is only applicable
if the `value_type` is `INT64`, `DOUBLE`, or `DISTRIBUTION`. The `unit`
defines the representation of the stored metric values.

Different systems might scale the values to be more easily displayed (so a
value of `0.02kBy` _might_ be displayed as `20By`, and a value of
`3523kBy` _might_ be displayed as `3.5MBy`). However, if the `unit` is
`kBy`, then the value of the metric is always in thousands of bytes, no
matter how it might be displayed.

If you want a custom metric to record the exact number of CPU-seconds used
by a job, you can create an `INT64 CUMULATIVE` metric whose `unit` is
`s{CPU}` (or equivalently `1s{CPU}` or just `s`). If the job uses 12,005
CPU-seconds, then the value is written as `12005`.

Alternatively, if you want a custom metric to record data in a more
granular way, you can create a `DOUBLE CUMULATIVE` metric whose `unit` is
`ks{CPU}`, and then write the value `12.005` (which is `12005/1000`),
or use `Kis{CPU}` and write `11.723` (which is `12005/1024`).

The supported units are a subset of [The Unified Code for Units of
Measure](https://unitsofmeasure.org/ucum.html) standard:

B<Basic units (UNIT)>

* `bit`   bit
* `By`    byte
* `s`     second
* `min`   minute
* `h`     hour
* `d`     day
* `1`     dimensionless

B<Prefixes (PREFIX)>

* `k`     kilo    (10^3)
* `M`     mega    (10^6)
* `G`     giga    (10^9)
* `T`     tera    (10^12)
* `P`     peta    (10^15)
* `E`     exa     (10^18)
* `Z`     zetta   (10^21)
* `Y`     yotta   (10^24)

* `m`     milli   (10^-3)
* `u`     micro   (10^-6)
* `n`     nano    (10^-9)
* `p`     pico    (10^-12)
* `f`     femto   (10^-15)
* `a`     atto    (10^-18)
* `z`     zepto   (10^-21)
* `y`     yocto   (10^-24)

* `Ki`    kibi    (2^10)
* `Mi`    mebi    (2^20)
* `Gi`    gibi    (2^30)
* `Ti`    tebi    (2^40)
* `Pi`    pebi    (2^50)

B<Grammar>

The grammar also includes these connectors:

* `/`    division or ratio (as an infix operator). For examples,
         `kBy/{email}` or `MiBy/10ms` (although you should almost never
         have `/s` in a metric `unit`; rates should always be computed at
         query time from the underlying cumulative or delta value).
* `.`    multiplication or composition (as an infix operator). For
         examples, `GBy.d` or `k{watt}.h`.

The grammar for a unit is as follows:

    Expression = Component { "." Component } { "/" Component } ;

    Component = ( [ PREFIX ] UNIT | "%" ) [ Annotation ]
              | Annotation
              | "1"
              ;

    Annotation = "{" NAME "}" ;

Notes:

* `Annotation` is just a comment if it follows a `UNIT`. If the annotation
   is used alone, then the unit is equivalent to `1`. For examples,
   `{request}/s == 1/s`, `By{transmitted}/s == By/s`.
* `NAME` is a sequence of non-blank printable ASCII characters not
   containing `{` or `}`.
* `1` represents a unitary [dimensionless
   unit](https://en.wikipedia.org/wiki/Dimensionless_quantity) of 1, such
   as in `1/s`. It is typically used when none of the basic units are
   appropriate. For example, "new users per day" can be represented as
   `1/d` or `{new-users}/d` (and a metric value `5` would mean "5 new
   users). Alternatively, "thousands of page views per day" would be
   represented as `1000/d` or `k1/d` or `k{page_views}/d` (and a metric
   value of `5.3` would mean "5300 page views per day").
* `%` represents dimensionless value of 1/100, and annotates values giving
   a percentage (so the metric values are typically in the range of 0..100,
   and a metric value `3` means "3 percent").
* `10^2.%` indicates a metric contains a ratio, typically in the range
   0..1, that will be multiplied by 100 and displayed as a percentage
   (so a metric value `0.03` means "3 percent").

=item * C<< $msg->description() >> / C<< $msg->description($value) >>

Type: C<String>

A detailed description of the metric, which can be used in documentation.

=item * C<< $msg->display_name() >> / C<< $msg->display_name($value) >>

Type: C<String>

A concise name for the metric, which can be displayed in user interfaces.
Use sentence case without an ending period, for example "Request count".
This field is optional but it is recommended to be set for any metrics
associated with user-visible concepts, such as Quota.

=item * C<< $msg->metadata() >> / C<< $msg->metadata($value) >>

Type: C<Message> (L<Google::Api::Metric::MetricDescriptor::MetricDescriptorMetadata>)

Optional. Metadata which can be used to guide usage of the metric.

=item * C<< $msg->launch_stage() >> / C<< $msg->launch_stage($value) >>

Type: C<Enum> (L<Google::Api::LaunchStage>)

Optional. The launch stage of the metric definition.

=item * C<< $msg->monitored_resource_types() >> / C<< $msg->monitored_resource_types($value) >>

Type: C<String>

Read-only. If present, then a [time
series][google.monitoring.v3.TimeSeries], which is identified partially by
a metric type and a
[MonitoredResourceDescriptor][google.api.MonitoredResourceDescriptor], that
is associated with this metric type can only be associated with one of the
monitored resource types listed here.

=back

=head3 Enum: MetricDescriptor::MetricKind

=over 4

=item * C<METRIC_KIND_UNSPECIFIED> => C<0>

=item * C<GAUGE> => C<1>

=item * C<DELTA> => C<2>

=item * C<CUMULATIVE> => C<3>

=back

=head3 Enum: MetricDescriptor::ValueType

=over 4

=item * C<VALUE_TYPE_UNSPECIFIED> => C<0>

=item * C<BOOL> => C<1>

=item * C<INT64> => C<2>

=item * C<DOUBLE> => C<3>

=item * C<STRING> => C<4>

=item * C<DISTRIBUTION> => C<5>

=item * C<MONEY> => C<6>

=back

=head2 Google::Api::Metric::Metric

A specific metric, identified by specifying values for all of the
labels of a [`MetricDescriptor`][google.api.MetricDescriptor].

Inherits from L<Protobuf::Message>.

=head3 Accessors

=over 4

=item * C<< $msg->type() >> / C<< $msg->type($value) >>

Type: C<String>

An existing metric type, see
[google.api.MetricDescriptor][google.api.MetricDescriptor]. For example,
`custom.googleapis.com/invoice/paid/amount`.

=item * C<< $msg->labels() >> / C<< $msg->labels($value) >>

Type: C<Message> (L<Google::Api::Metric::Metric::LabelsEntry>)

The set of label values that uniquely identify this metric. All
labels listed in the `MetricDescriptor` must be assigned values.

=back

=head1 SEE ALSO

L<Protobuf>, L<Protobuf::Message>, L<Google::Api::Metric::Types>, L<https://protobuf.dev/>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

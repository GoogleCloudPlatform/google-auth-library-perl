package Google::Cloud::Sql::V1::CloudSqlConnect;

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
    eval { require Google::Cloud::Sql::V1::CloudSqlResources };
    eval { require Google::Protobuf::Duration };
    eval { require Google::Protobuf::Timestamp };
    my $descriptor_b64 = <<'EOF';
Citnb29nbGUvY2xvdWQvc3FsL3YxL2Nsb3VkX3NxbF9jb25uZWN0LnByb3RvEhNnb29nbGUu
Y2xvdWQuc3FsLnYxGhxnb29nbGUvYXBpL2Fubm90YXRpb25zLnByb3RvGhdnb29nbGUvYXBp
L2NsaWVudC5wcm90bxofZ29vZ2xlL2FwaS9maWVsZF9iZWhhdmlvci5wcm90bxotZ29vZ2xl
L2Nsb3VkL3NxbC92MS9jbG91ZF9zcWxfcmVzb3VyY2VzLnByb3RvGh5nb29nbGUvcHJvdG9i
dWYvZHVyYXRpb24ucHJvdG8aH2dvb2dsZS9wcm90b2J1Zi90aW1lc3RhbXAucHJvdG8ijwEK
GUdldENvbm5lY3RTZXR0aW5nc1JlcXVlc3QSGgoIaW5zdGFuY2UYASABKAlSCGluc3RhbmNl
EhgKB3Byb2plY3QYAiABKAlSB3Byb2plY3QSPAoJcmVhZF90aW1lGAcgASgLMhouZ29vZ2xl
LnByb3RvYnVmLlRpbWVzdGFtcEID4EEBUghyZWFkVGltZSLPCgoPQ29ubmVjdFNldHRpbmdz
EhIKBGtpbmQYASABKAlSBGtpbmQSQgoOc2VydmVyX2NhX2NlcnQYAiABKAsyHC5nb29nbGUu
Y2xvdWQuc3FsLnYxLlNzbENlcnRSDHNlcnZlckNhQ2VydBJBCgxpcF9hZGRyZXNzZXMYAyAD
KAsyHi5nb29nbGUuY2xvdWQuc3FsLnYxLklwTWFwcGluZ1ILaXBBZGRyZXNzZXMSFgoGcmVn
aW9uGAQgASgJUgZyZWdpb24SUgoQZGF0YWJhc2VfdmVyc2lvbhgfIAEoDjInLmdvb2dsZS5j
bG91ZC5zcWwudjEuU3FsRGF0YWJhc2VWZXJzaW9uUg9kYXRhYmFzZVZlcnNpb24SRgoMYmFj
a2VuZF90eXBlGCAgASgOMiMuZ29vZ2xlLmNsb3VkLnNxbC52MS5TcWxCYWNrZW5kVHlwZVIL
YmFja2VuZFR5cGUSHwoLcHNjX2VuYWJsZWQYISABKAhSCnBzY0VuYWJsZWQSGQoIZG5zX25h
bWUYIiABKAlSB2Ruc05hbWUSUQoOc2VydmVyX2NhX21vZGUYIyABKA4yKy5nb29nbGUuY2xv
dWQuc3FsLnYxLkNvbm5lY3RTZXR0aW5ncy5DYU1vZGVSDHNlcnZlckNhTW9kZRJHCiBjdXN0
b21fc3ViamVjdF9hbHRlcm5hdGl2ZV9uYW1lcxglIAMoCVIdY3VzdG9tU3ViamVjdEFsdGVy
bmF0aXZlTmFtZXMSRQoJZG5zX25hbWVzGCYgAygLMiMuZ29vZ2xlLmNsb3VkLnNxbC52MS5E
bnNOYW1lTWFwcGluZ0ID4EEDUghkbnNOYW1lcxIiCgpub2RlX2NvdW50GD8gASgFSABSCW5v
ZGVDb3VudIgBARJVCgVub2RlcxhAIAMoCzI6Lmdvb2dsZS5jbG91ZC5zcWwudjEuQ29ubmVj
dFNldHRpbmdzLkNvbm5lY3RQb29sTm9kZUNvbmZpZ0ID4EEDUgVub2RlcxJxChRtZHhfcHJv
dG9jb2xfc3VwcG9ydBgnIAMoDjI3Lmdvb2dsZS5jbG91ZC5zcWwudjEuQ29ubmVjdFNldHRp
bmdzLk1keFByb3RvY29sU3VwcG9ydEIG4EED4EEBUhJtZHhQcm90b2NvbFN1cHBvcnQa/wEK
FUNvbm5lY3RQb29sTm9kZUNvbmZpZxIcCgRuYW1lGAEgASgJQgPgQQNIAFIEbmFtZYgBARJG
CgxpcF9hZGRyZXNzZXMYAiADKAsyHi5nb29nbGUuY2xvdWQuc3FsLnYxLklwTWFwcGluZ0ID
4EEDUgtpcEFkZHJlc3NlcxIjCghkbnNfbmFtZRgDIAEoCUID4EEDSAFSB2Ruc05hbWWIAQES
RQoJZG5zX25hbWVzGAQgAygLMiMuZ29vZ2xlLmNsb3VkLnNxbC52MS5EbnNOYW1lTWFwcGlu
Z0ID4EEDUghkbnNOYW1lc0IHCgVfbmFtZUILCglfZG5zX25hbWUieQoGQ2FNb2RlEhcKE0NB
X01PREVfVU5TUEVDSUZJRUQQABIeChpHT09HTEVfTUFOQUdFRF9JTlRFUk5BTF9DQRABEhkK
FUdPT0dMRV9NQU5BR0VEX0NBU19DQRACEhsKF0NVU1RPTUVSX01BTkFHRURfQ0FTX0NBEAMi
VAoSTWR4UHJvdG9jb2xTdXBwb3J0EiQKIE1EWF9QUk9UT0NPTF9TVVBQT1JUX1VOU1BFQ0lG
SUVEEAASGAoUQ0xJRU5UX1BST1RPQ09MX1RZUEUQAUINCgtfbm9kZV9jb3VudCKiAgocR2Vu
ZXJhdGVFcGhlbWVyYWxDZXJ0UmVxdWVzdBIaCghpbnN0YW5jZRgBIAEoCVIIaW5zdGFuY2US
GAoHcHJvamVjdBgCIAEoCVIHcHJvamVjdBIeCgpwdWJsaWNfa2V5GAMgASgJUgpwdWJsaWNf
a2V5EicKDGFjY2Vzc190b2tlbhgEIAEoCUID4EEBUgxhY2Nlc3NfdG9rZW4SPAoJcmVhZF90
aW1lGAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEID4EEBUghyZWFkVGltZRJF
Cg52YWxpZF9kdXJhdGlvbhgMIAEoCzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlvbkID4EEB
Ug12YWxpZER1cmF0aW9uImQKHUdlbmVyYXRlRXBoZW1lcmFsQ2VydFJlc3BvbnNlEkMKDmVw
aGVtZXJhbF9jZXJ0GAEgASgLMhwuZ29vZ2xlLmNsb3VkLnNxbC52MS5Tc2xDZXJ0Ug1lcGhl
bWVyYWxDZXJ0MpIEChFTcWxDb25uZWN0U2VydmljZRKvAQoSR2V0Q29ubmVjdFNldHRpbmdz
Ei4uZ29vZ2xlLmNsb3VkLnNxbC52MS5HZXRDb25uZWN0U2V0dGluZ3NSZXF1ZXN0GiQuZ29v
Z2xlLmNsb3VkLnNxbC52MS5Db25uZWN0U2V0dGluZ3MiQ4LT5JMCPRI7L3YxL3Byb2plY3Rz
L3twcm9qZWN0fS9pbnN0YW5jZXMve2luc3RhbmNlfS9jb25uZWN0U2V0dGluZ3MSzAEKFUdl
bmVyYXRlRXBoZW1lcmFsQ2VydBIxLmdvb2dsZS5jbG91ZC5zcWwudjEuR2VuZXJhdGVFcGhl
bWVyYWxDZXJ0UmVxdWVzdBoyLmdvb2dsZS5jbG91ZC5zcWwudjEuR2VuZXJhdGVFcGhlbWVy
YWxDZXJ0UmVzcG9uc2UiTILT5JMCRiJBL3YxL3Byb2plY3RzL3twcm9qZWN0fS9pbnN0YW5j
ZXMve2luc3RhbmNlfTpnZW5lcmF0ZUVwaGVtZXJhbENlcnQ6ASoafMpBF3NxbGFkbWluLmdv
b2dsZWFwaXMuY29t0kFfaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vYXV0aC9jbG91ZC1w
bGF0Zm9ybSxodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9hdXRoL3NxbHNlcnZpY2UuYWRt
aW5CXAoXY29tLmdvb2dsZS5jbG91ZC5zcWwudjFCFENsb3VkU3FsQ29ubmVjdFByb3RvUAFa
KWNsb3VkLmdvb2dsZS5jb20vZ28vc3FsL2FwaXYxL3NxbHBiO3NxbHBiSvE6CgcSBQ4A1wEB
CrwECgEMEgMOABIysQQgQ29weXJpZ2h0IDIwMjYgR29vZ2xlIExMQwoKIExpY2Vuc2VkIHVu
ZGVyIHRoZSBBcGFjaGUgTGljZW5zZSwgVmVyc2lvbiAyLjAgKHRoZSAiTGljZW5zZSIpOwog
eW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoIHRo
ZSBMaWNlbnNlLgogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0Cgog
ICAgIGh0dHA6Ly93d3cuYXBhY2hlLm9yZy9saWNlbnNlcy9MSUNFTlNFLTIuMAoKIFVubGVz
cyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywg
c29mdHdhcmUKIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSBMaWNlbnNlIGlzIGRpc3RyaWJ1dGVk
IG9uIGFuICJBUyBJUyIgQkFTSVMsCiBXSVRIT1VUIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9O
UyBPRiBBTlkgS0lORCwgZWl0aGVyIGV4cHJlc3Mgb3IgaW1wbGllZC4KIFNlZSB0aGUgTGlj
ZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBh
bmQKIGxpbWl0YXRpb25zIHVuZGVyIHRoZSBMaWNlbnNlLgoKCAoBAhIDEAAcCgkKAgMAEgMS
ACYKCQoCAwESAxMAIQoJCgIDAhIDFAApCgkKAgMDEgMVADcKCQoCAwQSAxYAKAoJCgIDBRID
FwApCggKAQgSAxkAQAoJCgIICxIDGQBACggKAQgSAxoAIgoJCgIIChIDGgAiCggKAQgSAxsA
NQoJCgIICBIDGwA1CggKAQgSAxwAMAoJCgIIARIDHAAwCigKAgYAEgQfADcBGhwgQ2xvdWQg
U1FMIGNvbm5lY3Qgc2VydmljZS4KCgoKAwYAARIDHwgZCgoKAwYAAxIDIAI/CgwKBQYAA5kI
EgMgAj8KCwoDBgADEgQhAiM5Cg0KBQYAA5oIEgQhAiM5CkYKBAYAAgASBCYCKgMaOCBSZXRy
aWV2ZXMgY29ubmVjdCBzZXR0aW5ncyBhYm91dCBhIENsb3VkIFNRTCBpbnN0YW5jZS4KCgwK
BQYAAgABEgMmBhgKDAoFBgACAAISAyYZMgoMCgUGAAIAAxIDJj1MCg0KBQYAAgAEEgQnBCkG
ChEKCQYAAgAEsMq8IhIEJwQpBgr5AQoEBgACARIEMAI2AxrqASBHZW5lcmF0ZXMgYSBzaG9y
dC1saXZlZCBYNTA5IGNlcnRpZmljYXRlIGNvbnRhaW5pbmcgdGhlIHByb3ZpZGVkIHB1Ymxp
YyBrZXkKIGFuZCBzaWduZWQgYnkgYSBwcml2YXRlIGtleSBzcGVjaWZpYyB0byB0aGUgdGFy
Z2V0IGluc3RhbmNlLiBVc2VycyBtYXkgdXNlCiB0aGUgY2VydGlmaWNhdGUgdG8gYXV0aGVu
dGljYXRlIGFzIHRoZW1zZWx2ZXMgd2hlbiBjb25uZWN0aW5nIHRvIHRoZQogZGF0YWJhc2Uu
CgoMCgUGAAIBARIDMAYbCgwKBQYAAgECEgMwHDgKDAoFBgACAQMSAzEPLAoNCgUGAAIBBBIE
MgQ1BgoRCgkGAAIBBLDKvCISBDIENQYKMQoCBAASBDoARQEaJSBDb25uZWN0IHNldHRpbmdz
IHJldHJpZXZhbCByZXF1ZXN0LgoKCgoDBAABEgM6CCEKSwoEBAACABIDPAIWGj4gQ2xvdWQg
U1FMIGluc3RhbmNlIElELiBUaGlzIGRvZXMgbm90IGluY2x1ZGUgdGhlIHByb2plY3QgSUQu
CgoMCgUEAAIABRIDPAIICgwKBQQAAgABEgM8CREKDAoFBAACAAMSAzwUFQpECgQEAAIBEgM/
AhUaNyBQcm9qZWN0IElEIG9mIHRoZSBwcm9qZWN0IHRoYXQgY29udGFpbnMgdGhlIGluc3Rh
bmNlLgoKDAoFBAACAQUSAz8CCAoMCgUEAAIBARIDPwkQCgwKBQQAAgEDEgM/ExQKXwoEBAAC
AhIEQwJELxpRIE9wdGlvbmFsLiBPcHRpb25hbCBzbmFwc2hvdCByZWFkIHRpbWVzdGFtcCB0
byB0cmFkZSBmcmVzaG5lc3MgZm9yCiBwZXJmb3JtYW5jZS4KCgwKBQQAAgIGEgNDAhsKDAoF
BAACAgESA0McJQoMCgUEAAICAxIDQygpCgwKBQQAAgIIEgNEBi4KDwoIBAACAgicCAASA0QH
LQozCgIEARIFSAC4AQEaJiBDb25uZWN0IHNldHRpbmdzIHJldHJpZXZhbCByZXNwb25zZS4K
CgoKAwQBARIDSAgXClEKBAQBBAASBEoCWAMaQyBWYXJpb3VzIENlcnRpZmljYXRlIEF1dGhv
cml0eSAoQ0EpIG1vZGVzIGZvciBjZXJ0aWZpY2F0ZSBzaWduaW5nLgoKDAoFBAEEAAESA0oH
DQokCgYEAQQAAgASA0wEHBoVIENBIG1vZGUgaXMgdW5rbm93bi4KCg4KBwQBBAACAAESA0wE
FwoOCgcEAQQAAgACEgNMGhsKOAoGBAEEAAIBEgNPBCMaKSBHb29nbGUtbWFuYWdlZCBzZWxm
LXNpZ25lZCBpbnRlcm5hbCBDQS4KCg4KBwQBBAACAQESA08EHgoOCgcEAQQAAgECEgNPISIK
hAEKBgQBBAACAhIDUwQeGnUgR29vZ2xlLW1hbmFnZWQgcmVnaW9uYWwgQ0EgcGFydCBvZiBy
b290IENBIGhpZXJhcmNoeSBob3N0ZWQgb24gR29vZ2xlCiBDbG91ZCdzIENlcnRpZmljYXRl
IEF1dGhvcml0eSBTZXJ2aWNlIChDQVMpLgoKDgoHBAEEAAICARIDUwQZCg4KBwQBBAACAgIS
A1McHQpjCgYEAQQAAgMSA1cEIBpUIEN1c3RvbWVyLW1hbmFnZWQgQ0EgaG9zdGVkIG9uIEdv
b2dsZSBDbG91ZCdzIENlcnRpZmljYXRlIEF1dGhvcml0eQogU2VydmljZSAoQ0FTKS4KCg4K
BwQBBAACAwESA1cEGwoOCgcEAQQAAgMCEgNXHh8KQgoEBAEDABIEWwJrAxo0IERldGFpbHMg
b2YgYSBzaW5nbGUgcmVhZCBwb29sIG5vZGUgb2YgYSByZWFkIHBvb2wuCgoMCgUEAQMAARID
WwofCl4KBgQBAwACABIDXgRJGk8gT3V0cHV0IG9ubHkuIFRoZSBuYW1lIG9mIHRoZSByZWFk
IHBvb2wgbm9kZS4gRG9lc24ndCBpbmNsdWRlIHRoZSBwcm9qZWN0CiBJRC4KCg4KBwQBAwAC
AAQSA14EDAoOCgcEAQMAAgAFEgNeDRMKDgoHBAEDAAIAARIDXhQYCg4KBwQBAwACAAMSA14b
HAoOCgcEAQMAAgAIEgNeHUgKEQoKBAEDAAIACJwIABIDXh5HCnMKBgQBAwACARIEYgRjNBpj
IE91dHB1dCBvbmx5LiBNYXBwaW5ncyBjb250YWluaW5nIElQIGFkZHJlc3NlcyB0aGF0IGNh
biBiZSB1c2VkIHRvIGNvbm5lY3QKIHRvIHRoZSByZWFkIHBvb2wgbm9kZS4KCg4KBwQBAwAC
AQQSA2IEDAoOCgcEAQMAAgEGEgNiDRYKDgoHBAEDAAIBARIDYhcjCg4KBwQBAwACAQMSA2Im
JwoOCgcEAQMAAgEIEgNjCDMKEQoKBAEDAAIBCJwIABIDYwkyCkEKBgQBAwACAhIDZgRNGjIg
T3V0cHV0IG9ubHkuIFRoZSBETlMgbmFtZSBvZiB0aGUgcmVhZCBwb29sIG5vZGUuCgoOCgcE
AQMAAgIEEgNmBAwKDgoHBAEDAAICBRIDZg0TCg4KBwQBAwACAgESA2YUHAoOCgcEAQMAAgID
EgNmHyAKDgoHBAEDAAICCBIDZiFMChEKCgQBAwACAgicCAASA2YiSwpRCgYEAQMAAgMSBGkE
ajQaQSBPdXRwdXQgb25seS4gVGhlIGxpc3Qgb2YgRE5TIG5hbWVzIHVzZWQgYnkgdGhpcyBy
ZWFkIHBvb2wgbm9kZS4KCg4KBwQBAwACAwQSA2kEDAoOCgcEAQMAAgMGEgNpDRsKDgoHBAED
AAIDARIDaRwlCg4KBwQBAwACAwMSA2koKQoOCgcEAQMAAgMIEgNqCDMKEQoKBAEDAAIDCJwI
ABIDagkyCmMKBAQBBAESBG8CdQMaVSBNZHhQcm90b2NvbFN1cHBvcnQgZGVzY3JpYmVzIHBh
cnRzIG9mIHRoZSBNRFggcHJvdG9jb2wgc3VwcG9ydGVkIGJ5IHRoaXMKIGluc3RhbmNlLgoK
DAoFBAEEAQESA28HGQofCgYEAQQBAgASA3EEKRoQIE5vdCBzcGVjaWZpZWQuCgoOCgcEAQQB
AgABEgNxBCQKDgoHBAEEAQIAAhIDcScoClAKBgQBBAECARIDdAQdGkEgQ2xpZW50IHNob3Vs
ZCBzZW5kIHRoZSBjbGllbnQgcHJvdG9jb2wgdHlwZSBpbiB0aGUgTURYIHJlcXVlc3QuCgoO
CgcEAQQBAgEBEgN0BBgKDgoHBAEEAQIBAhIDdBscCjQKBAQBAgASA3gCEhonIFRoaXMgaXMg
YWx3YXlzIGBzcWwjY29ubmVjdFNldHRpbmdzYC4KCgwKBQQBAgAFEgN4AggKDAoFBAECAAES
A3gJDQoMCgUEAQIAAxIDeBARCiEKBAQBAgESA3sCHRoUIFNTTCBjb25maWd1cmF0aW9uLgoK
DAoFBAECAQYSA3sCCQoMCgUEAQIBARIDewoYCgwKBQQBAgEDEgN7GxwKOgoEBAECAhIDfgIm
Gi0gVGhlIGFzc2lnbmVkIElQIGFkZHJlc3NlcyBmb3IgdGhlIGluc3RhbmNlLgoKDAoFBAEC
AgQSA34CCgoMCgUEAQICBhIDfgsUCgwKBQQBAgIBEgN+FSEKDAoFBAECAgMSA34kJQqWAQoE
BAECAxIEggECFBqHASBUaGUgY2xvdWQgcmVnaW9uIGZvciB0aGUgaW5zdGFuY2UuIEZvciBl
eGFtcGxlLCBgdXMtY2VudHJhbDFgLAogYGV1cm9wZS13ZXN0MWAuIFRoZSByZWdpb24gY2Fu
bm90IGJlIGNoYW5nZWQgYWZ0ZXIgaW5zdGFuY2UgY3JlYXRpb24uCgoNCgUEAQIDBRIEggEC
CAoNCgUEAQIDARIEggEJDwoNCgUEAQIDAxIEggESEwrDBAoEBAECBBIEjwECKxq0BCBUaGUg
ZGF0YWJhc2UgZW5naW5lIHR5cGUgYW5kIHZlcnNpb24uIFRoZSBgZGF0YWJhc2VWZXJzaW9u
YAogZmllbGQgY2Fubm90IGJlIGNoYW5nZWQgYWZ0ZXIgaW5zdGFuY2UgY3JlYXRpb24uCiAg
IE15U1FMIGluc3RhbmNlczogYE1ZU1FMXzhfMGAsIGBNWVNRTF81XzdgIChkZWZhdWx0KSwK
IG9yIGBNWVNRTF81XzZgLgogICBQb3N0Z3JlU1FMIGluc3RhbmNlczogYFBPU1RHUkVTXzlf
NmAsIGBQT1NUR1JFU18xMGAsCiBgUE9TVEdSRVNfMTFgLCBgUE9TVEdSRVNfMTJgIChkZWZh
dWx0KSwgYFBPU1RHUkVTXzEzYCwgb3IgYFBPU1RHUkVTXzE0YC4KICAgU1FMIFNlcnZlciBp
bnN0YW5jZXM6IGBTUUxTRVJWRVJfMjAxN19TVEFOREFSRGAgKGRlZmF1bHQpLAogYFNRTFNF
UlZFUl8yMDE3X0VOVEVSUFJJU0VgLCBgU1FMU0VSVkVSXzIwMTdfRVhQUkVTU2AsCiBgU1FM
U0VSVkVSXzIwMTdfV0VCYCwgYFNRTFNFUlZFUl8yMDE5X1NUQU5EQVJEYCwKIGBTUUxTRVJW
RVJfMjAxOV9FTlRFUlBSSVNFYCwgYFNRTFNFUlZFUl8yMDE5X0VYUFJFU1NgLCBvcgogYFNR
TFNFUlZFUl8yMDE5X1dFQmAuCgoNCgUEAQIEBhIEjwECFAoNCgUEAQIEARIEjwEVJQoNCgUE
AQIEAxIEjwEoKgroAQoEBAECBRIElQECIxrZASBgU0VDT05EX0dFTmA6IENsb3VkIFNRTCBk
YXRhYmFzZSBpbnN0YW5jZS4KIGBFWFRFUk5BTGA6IEEgZGF0YWJhc2Ugc2VydmVyIHRoYXQg
aXMgbm90IG1hbmFnZWQgYnkgR29vZ2xlLgogVGhpcyBwcm9wZXJ0eSBpcyByZWFkLW9ubHk7
IHVzZSB0aGUgYHRpZXJgIHByb3BlcnR5IGluIHRoZSBgc2V0dGluZ3NgCiBvYmplY3QgdG8g
ZGV0ZXJtaW5lIHRoZSBkYXRhYmFzZSB0eXBlLgoKDQoFBAECBQYSBJUBAhAKDQoFBAECBQES
BJUBER0KDQoFBAECBQMSBJUBICIKRgoEBAECBhIEmAECGBo4IFdoZXRoZXIgUFNDIGNvbm5l
Y3Rpdml0eSBpcyBlbmFibGVkIGZvciB0aGlzIGluc3RhbmNlLgoKDQoFBAECBgUSBJgBAgYK
DQoFBAECBgESBJgBBxIKDQoFBAECBgMSBJgBFRcKLQoEBAECBxIEmwECFxofIFRoZSBkbnMg
bmFtZSBvZiB0aGUgaW5zdGFuY2UuCgoNCgUEAQIHBRIEmwECCAoNCgUEAQIHARIEmwEJEQoN
CgUEAQIHAxIEmwEUFgpLCgQEAQIIEgSeAQIdGj0gU3BlY2lmeSB3aGF0IHR5cGUgb2YgQ0Eg
aXMgdXNlZCBmb3IgdGhlIHNlcnZlciBjZXJ0aWZpY2F0ZS4KCg0KBQQBAggGEgSeAQIICg0K
BQQBAggBEgSeAQkXCg0KBQQBAggDEgSeARocCkwKBAQBAgkSBKEBAjgaPiBDdXN0b20gc3Vi
amVjdCBhbHRlcm5hdGl2ZSBuYW1lcyBmb3IgdGhlIHNlcnZlciBjZXJ0aWZpY2F0ZS4KCg0K
BQQBAgkEEgShAQIKCg0KBQQBAgkFEgShAQsRCg0KBQQBAgkBEgShARIyCg0KBQQBAgkDEgSh
ATU3CksKBAQBAgoSBqQBAqUBMho7IE91dHB1dCBvbmx5LiBUaGUgbGlzdCBvZiBETlMgbmFt
ZXMgdXNlZCBieSB0aGlzIGluc3RhbmNlLgoKDQoFBAECCgQSBKQBAgoKDQoFBAECCgYSBKQB
CxkKDQoFBAECCgESBKQBGiMKDQoFBAECCgMSBKQBJigKDQoFBAECCggSBKUBBjEKEAoIBAEC
CgicCAASBKUBBzAKPQoEBAECCxIEqAECIRovIFRoZSBudW1iZXIgb2YgcmVhZCBwb29sIG5v
ZGVzIGluIGEgcmVhZCBwb29sLgoKDQoFBAECCwQSBKgBAgoKDQoFBAECCwUSBKgBCxAKDQoF
BAECCwESBKgBERsKDQoFBAECCwMSBKgBHiAKagoEBAECDBIGrAECrQEyGlogT3V0cHV0IG9u
bHkuIEVudHJpZXMgY29udGFpbmluZyBpbmZvcm1hdGlvbiBhYm91dCBlYWNoIHJlYWQgcG9v
bCBub2RlIG9mCiB0aGUgcmVhZCBwb29sLgoKDQoFBAECDAQSBKwBAgoKDQoFBAECDAYSBKwB
CyAKDQoFBAECDAESBKwBISYKDQoFBAECDAMSBKwBKSsKDQoFBAECDAgSBK0BBjEKEAoIBAEC
DAicCAASBK0BBzAK8gIKBAQBAg0SBrQBArcBBBrhAiBPcHRpb25hbC4gT3V0cHV0IG9ubHku
IG1keF9wcm90b2NvbF9zdXBwb3J0IGNvbnRyb2xzIGhvdyB0aGUgY2xpZW50IHVzZXMKIG1l
dGFkYXRhIGV4Y2hhbmdlIHdoZW4gY29ubmVjdGluZyB0byB0aGUgaW5zdGFuY2UuIFRoZSB2
YWx1ZXMgaW4gdGhlIGxpc3QKIHJlcHJlc2VudGluZyBwYXJ0cyBvZiB0aGUgTURYIHByb3Rv
Y29sIHRoYXQgYXJlIHN1cHBvcnRlZCBieSB0aGlzIGluc3RhbmNlLgogV2hlbiB0aGUgbGlz
dCBpcyBlbXB0eSwgdGhlIGluc3RhbmNlIGRvZXMgbm90IHN1cHBvcnQgTURYLCBzbyB0aGUg
Y2xpZW50CiBtdXN0IG5vdCBzZW5kIGFuIE1EWCByZXF1ZXN0LiBUaGUgZGVmYXVsdCBpcyBl
bXB0eS4KCg0KBQQBAg0EEgS0AQIKCg0KBQQBAg0GEgS0AQsdCg0KBQQBAg0BEgS0AR4yCg0K
BQQBAg0DEgS0ATU3Cg8KBQQBAg0IEga0ATi3AQMKEAoIBAECDQicCAASBLUBBC0KEAoIBAEC
DQicCAESBLYBBCoKNwoCBAISBrsBANEBARopIEVwaGVtZXJhbCBjZXJ0aWZpY2F0ZSBjcmVh
dGlvbiByZXF1ZXN0LgoKCwoDBAIBEgS7AQgkCkwKBAQCAgASBL0BAhYaPiBDbG91ZCBTUUwg
aW5zdGFuY2UgSUQuIFRoaXMgZG9lcyBub3QgaW5jbHVkZSB0aGUgcHJvamVjdCBJRC4KCg0K
BQQCAgAFEgS9AQIICg0KBQQCAgABEgS9AQkRCg0KBQQCAgADEgS9ARQVCkUKBAQCAgESBMAB
AhUaNyBQcm9qZWN0IElEIG9mIHRoZSBwcm9qZWN0IHRoYXQgY29udGFpbnMgdGhlIGluc3Rh
bmNlLgoKDQoFBAICAQUSBMABAggKDQoFBAICAQESBMABCRAKDQoFBAICAQMSBMABExQKTAoE
BAICAhIEwwECMxo+IFBFTSBlbmNvZGVkIHB1YmxpYyBrZXkgdG8gaW5jbHVkZSBpbiB0aGUg
c2lnbmVkIGNlcnRpZmljYXRlLgoKDQoFBAICAgUSBMMBAggKDQoFBAICAgESBMMBCRMKDQoF
BAICAgMSBMMBFhcKDQoFBAICAggSBMMBGDIKDQoFBAICAgoSBMMBGTEKDQoFBAICAgoSBMMB
JTEKTgoEBAICAxIGxgECxwFLGj4gT3B0aW9uYWwuIEFjY2VzcyB0b2tlbiB0byBpbmNsdWRl
IGluIHRoZSBzaWduZWQgY2VydGlmaWNhdGUuCgoNCgUEAgIDBRIExgECCAoNCgUEAgIDARIE
xgEJFQoNCgUEAgIDAxIExgEYGQoNCgUEAgIDCBIExwEGSgoNCgUEAgIDChIExwEHIQoNCgUE
AgIDChIExwETIQoQCggEAgIDCJwIABIExwEjSQphCgQEAgIEEgbLAQLMAS8aUSBPcHRpb25h
bC4gT3B0aW9uYWwgc25hcHNob3QgcmVhZCB0aW1lc3RhbXAgdG8gdHJhZGUgZnJlc2huZXNz
IGZvcgogcGVyZm9ybWFuY2UuCgoNCgUEAgIEBhIEywECGwoNCgUEAgIEARIEywEcJQoNCgUE
AgIEAxIEywEoKQoNCgUEAgIECBIEzAEGLgoQCggEAgIECJwIABIEzAEHLQpMCgQEAgIFEgbP
AQLQAS8aPCBPcHRpb25hbC4gSWYgc2V0LCBpdCB3aWxsIGNvbnRhaW4gdGhlIGNlcnQgdmFs
aWQgZHVyYXRpb24uCgoNCgUEAgIFBhIEzwECGgoNCgUEAgIFARIEzwEbKQoNCgUEAgIFAxIE
zwEsLgoNCgUEAgIFCBIE0AEGLgoQCggEAgIFCJwIABIE0AEHLQo3CgIEAxIG1AEA1wEBGikg
RXBoZW1lcmFsIGNlcnRpZmljYXRlIGNyZWF0aW9uIHJlcXVlc3QuCgoLCgMEAwESBNQBCCUK
HgoEBAMCABIE1gECHRoQIEdlbmVyYXRlZCBjZXJ0CgoNCgUEAwIABhIE1gECCQoNCgUEAwIA
ARIE1gEKGAoNCgUEAwIAAxIE1gEbHGIGcHJvdG8z
EOF
    Protobuf::DescriptorPool->generated_pool->add_serialized_file(MIME::Base64::decode_base64($descriptor_b64));
}

# Message definitions

# === Message: Google::Cloud::Sql::V1::CloudSqlConnect::GetConnectSettingsRequest ===
    # Fields for GetConnectSettingsRequest
    # Field: instance Type: 9 ()
    # Field: project Type: 9 ()
    # Field: read_time Type: 11 (.google.protobuf.Timestamp)

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlConnect::GetConnectSettingsRequest - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlConnect;

    my $msg = Google::Cloud::Sql::V1::CloudSqlConnect::GetConnectSettingsRequest->new(
        instance => $value,
    );

=head1 FIELDS

=over 4

=item * B<instance>

Type: String

=item * B<project>

Type: String

=item * B<read_time>

Type: Message (.google.protobuf.Timestamp)

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlConnect::ConnectSettings ===
    # Fields for ConnectSettings
    # Field: kind Type: 9 ()
    # Field: server_ca_cert Type: 11 (.google.cloud.sql.v1.SslCert)
    # Field: ip_addresses Type: 11 (.google.cloud.sql.v1.IpMapping)
    # Field: region Type: 9 ()
    # Field: database_version Type: 14 (.google.cloud.sql.v1.SqlDatabaseVersion)
    # Field: backend_type Type: 14 (.google.cloud.sql.v1.SqlBackendType)
    # Field: psc_enabled Type: 8 ()
    # Field: dns_name Type: 9 ()
    # Field: server_ca_mode Type: 14 (.google.cloud.sql.v1.ConnectSettings.CaMode)
    # Field: custom_subject_alternative_names Type: 9 ()
    # Field: dns_names Type: 11 (.google.cloud.sql.v1.DnsNameMapping)
    # Field: node_count Type: 5 ()
    # Field: nodes Type: 11 (.google.cloud.sql.v1.ConnectSettings.ConnectPoolNodeConfig)
    # Field: mdx_protocol_support Type: 14 (.google.cloud.sql.v1.ConnectSettings.MdxProtocolSupport)

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlConnect::ConnectSettings - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlConnect;

    my $msg = Google::Cloud::Sql::V1::CloudSqlConnect::ConnectSettings->new(
        kind => $value,
    );

=head1 FIELDS

=over 4

=item * B<kind>

Type: String

=item * B<server_ca_cert>

Type: Message (.google.cloud.sql.v1.SslCert)

=item * B<ip_addresses>

Type: Message (.google.cloud.sql.v1.IpMapping)

=item * B<region>

Type: String

=item * B<database_version>

Type: Enum (.google.cloud.sql.v1.SqlDatabaseVersion)

=item * B<backend_type>

Type: Enum (.google.cloud.sql.v1.SqlBackendType)

=item * B<psc_enabled>

Type: Bool

=item * B<dns_name>

Type: String

=item * B<server_ca_mode>

Type: Enum (.google.cloud.sql.v1.ConnectSettings.CaMode)

=item * B<custom_subject_alternative_names>

Type: String

=item * B<dns_names>

Type: Message (.google.cloud.sql.v1.DnsNameMapping)

=item * B<node_count>

Type: Int32

=item * B<nodes>

Type: Message (.google.cloud.sql.v1.ConnectSettings.ConnectPoolNodeConfig)

=item * B<mdx_protocol_support>

Type: Enum (.google.cloud.sql.v1.ConnectSettings.MdxProtocolSupport)

=back

=cut

# Enum: ConnectSettings::CaMode
our $ConnectSettings_CA_MODE_UNSPECIFIED = 0;
our $ConnectSettings_GOOGLE_MANAGED_INTERNAL_CA = 1;
our $ConnectSettings_GOOGLE_MANAGED_CAS_CA = 2;
our $ConnectSettings_CUSTOMER_MANAGED_CAS_CA = 3;

=pod

=head2 Enum: ConnectSettings::CaMode

Values:

=over 4

=item * C<CA_MODE_UNSPECIFIED> => 0

=item * C<GOOGLE_MANAGED_INTERNAL_CA> => 1

=item * C<GOOGLE_MANAGED_CAS_CA> => 2

=item * C<CUSTOMER_MANAGED_CAS_CA> => 3

=back

=cut

# Enum: ConnectSettings::MdxProtocolSupport
our $ConnectSettings_MDX_PROTOCOL_SUPPORT_UNSPECIFIED = 0;
our $ConnectSettings_CLIENT_PROTOCOL_TYPE = 1;

=pod

=head2 Enum: ConnectSettings::MdxProtocolSupport

Values:

=over 4

=item * C<MDX_PROTOCOL_SUPPORT_UNSPECIFIED> => 0

=item * C<CLIENT_PROTOCOL_TYPE> => 1

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlConnect::GenerateEphemeralCertRequest ===
    # Fields for GenerateEphemeralCertRequest
    # Field: instance Type: 9 ()
    # Field: project Type: 9 ()
    # Field: public_key Type: 9 ()
    # Field: access_token Type: 9 ()
    # Field: read_time Type: 11 (.google.protobuf.Timestamp)
    # Field: valid_duration Type: 11 (.google.protobuf.Duration)

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlConnect::GenerateEphemeralCertRequest - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlConnect;

    my $msg = Google::Cloud::Sql::V1::CloudSqlConnect::GenerateEphemeralCertRequest->new(
        instance => $value,
    );

=head1 FIELDS

=over 4

=item * B<instance>

Type: String

=item * B<project>

Type: String

=item * B<public_key>

Type: String

=item * B<access_token>

Type: String

=item * B<read_time>

Type: Message (.google.protobuf.Timestamp)

=item * B<valid_duration>

Type: Message (.google.protobuf.Duration)

=back

=cut

# === Message: Google::Cloud::Sql::V1::CloudSqlConnect::GenerateEphemeralCertResponse ===
    # Fields for GenerateEphemeralCertResponse
    # Field: ephemeral_cert Type: 11 (.google.cloud.sql.v1.SslCert)

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlConnect::GenerateEphemeralCertResponse - Compiled Protocol Buffers message class

=head1 SYNOPSIS

    use Google::Cloud::Sql::V1::CloudSqlConnect;

    my $msg = Google::Cloud::Sql::V1::CloudSqlConnect::GenerateEphemeralCertResponse->new(
        ephemeral_cert => $value,
    );

=head1 FIELDS

=over 4

=item * B<ephemeral_cert>

Type: Message (.google.cloud.sql.v1.SslCert)

=back

=cut

# === Service Client: Google::Cloud::Sql::V1::CloudSqlConnect::SqlConnectServiceClient ===
package Google::Cloud::Sql::V1::CloudSqlConnect::SqlConnectServiceClient;

=pod

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlConnect::SqlConnectServiceClient - Client stub representing the remote SqlConnectService service

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

sub get_connect_settings {
    my ($self, $args) = @_;
    my $req = ref($args) eq 'HASH'
        ? Google::Cloud::Sql::V1::CloudSqlConnect::GetConnectSettingsRequest->new($args)
        : $args;
    return $self->_grpc_client->call({
        service        => 'google.cloud.sql.v1.SqlConnectService',
        method         => 'GetConnectSettings',
        request        => $req,
        response_class => 'Google::Cloud::Sql::V1::CloudSqlConnect::ConnectSettings',
    });
}

sub generate_ephemeral_cert {
    my ($self, $args) = @_;
    my $req = ref($args) eq 'HASH'
        ? Google::Cloud::Sql::V1::CloudSqlConnect::GenerateEphemeralCertRequest->new($args)
        : $args;
    return $self->_grpc_client->call({
        service        => 'google.cloud.sql.v1.SqlConnectService',
        method         => 'GenerateEphemeralCert',
        request        => $req,
        response_class => 'Google::Cloud::Sql::V1::CloudSqlConnect::GenerateEphemeralCertResponse',
    });
}

1;

__END__

=head1 NAME

Google::Cloud::Sql::V1::CloudSqlConnect - Protocol Buffers schema definition

=head1 DESCRIPTION

Auto-generated Protocol Buffers schema definition class.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

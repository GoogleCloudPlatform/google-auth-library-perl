use strict;
use warnings;
use blib;
use Google::Auth::IDTokens::OpenSSL;
use Test::More;
use Data::Dumper;
use Crypt::PK::RSA;

my $cert_pem = <<'EOF';
-----BEGIN CERTIFICATE-----
MIIC/zCCAeegAwIBAgIUJgMNngJIYB1t9wJvIQwEgj5ytmUwDQYJKoZIhvcNAQEL
BQAwDzENMAsGA1UEAwwEdGVzdDAeFw0yNjAzMTAwMzM1NTdaFw0yNzAzMTAwMzM1
NTdaMA8xDTALBgNVBAMMBHRlc3QwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQDd9BRYsVvmQ5MBooNEZoJVPOIPHkw0PhreEFPePNVRfp3gdVMuK/GNGjxF
6bfqidMOKy7u9oa7G1qbHluVLWyvmIBfaDJqFh7FPa9Y2hKmxwjGJUE4A41cBly6
fubONyU6VBXfh9FHOhLTOJWR3dP9BNakuFHMD8G/U03mK0oHIw3mguCc9wzdzwJc
FuZVxYxNNbeJGUnqWpUDk0pEXXkdgUMRa4KXe5jM/2ITUSV/E6DKUFzOOhwPd3yS
GWWfLknje/jb+a9kzbPIKszw26GpmyUabXDD/haEvDIAPP43/L9xH7qjUD2I8PQi
DyJZIUWKuSJKM8vJMgJa7xi5UxR3AgMBAAGjUzBRMB0GA1UdDgQWBBS9bdtLralW
e6BMGp58C+mDPX67EDAfBgNVHSMEGDAWgBS9bdtLralWe6BMGp58C+mDPX67EDAP
BgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQA8jo093nq9XuqwtBqL
zVK6Gv1Ar0UD25Sk8WU1xVnIwYLQ19ZYSk5Vju3c4BA05QHZXdD0pMIrWjYAHwih
bzdGY8cXYy8ZUpHPXeG2+EmNmdXA65JknKw6IHw8mSl1qQ1JrCDOw8kpfOHziZj9
Mw+gR9kEuNC69n5lwsAwMdw9mtP9/1y3wPNljUVSDurtEjg+XTo6xq3oBDXPqKdz
Pt4CaI9EPUMEifYjWnSkinqwmApuBVbHI6W0giuANthHYti2WVHOO83HikslLl6S
7r6s33HhmNQpQ97R+ixY9ZdOx52QEw8xW73RYGnyBZy8GxHt8Pkd7FPOSOqx9Utt
g7W6
-----END CERTIFICATE-----
EOF

my $pubkey_der = Google::Auth::IDTokens::OpenSSL::get_pubkey_from_x509($cert_pem);
ok(defined($pubkey_der), "Returns defined pubkey for valid PEM cert");

my $rsa = Crypt::PK::RSA->new();
eval { $rsa->import_key(\$pubkey_der) };
ok(!$@, "Crypt::PK::RSA can import the extracted public key");

my $pubkey_invalid = eval { Google::Auth::IDTokens::OpenSSL::get_pubkey_from_x509("invalid") };
ok(!defined($pubkey_invalid), "Returns undef for invalid cert");

done_testing();

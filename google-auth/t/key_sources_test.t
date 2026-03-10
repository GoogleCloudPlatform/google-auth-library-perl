# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::Deep;
use JSON::XS;
use Crypt::PK::RSA;
use Crypt::PK::ECC;

use Google::Auth::IDTokens::KeySources;
use Google::Auth::Transport::LWP;

# Mocking LWP for HttpKeySource tests
{
    package MockTransport;
    sub new { bless { responses => {} }, shift }
    sub map_response {
        my ($self, $url, $code, $data) = @_;
        $self->{responses}{$url} = { code => $code, data => $data };
    }
    sub request {
        my ($self, %args) = @_;
        my $res = $self->{responses}{$args{url}} || { code => 404, data => 'Not Found' };
        return bless $res, 'MockResponse';
    }

    package MockResponse;
    sub status { $_[0]->{code} }
    sub data   { $_[0]->{data} }
    sub headers { {} }
}

my $cert1_pem = <<'EOF';
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

my $cert2_pem = <<'EOF';
-----BEGIN CERTIFICATE-----
MIIDATCCAemgAwIBAgIUK64B47mU8jzOHYAPbvEGLG8GDW8wDQYJKoZIhvcNAQEL
BQAwEDEOMAwGA1UEAwwFdGVzdDIwHhcNMjYwMzEwMDQxMzA2WhcNMjcwMzEwMDQx
MzA2WjAQMQ4wDAYDVQQDDAV0ZXN0MjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAOb9/sFwet8QKIY3ubI8DfPskqvAy9vxTFko3+CFnJB6BLLD01ecl3Jl
03/IrkXD3SBhX6oZhgwhEa79Yq20B5I/ildQTAkCkqK6wVyBJCovFka7aRvZRpLa
INPQ6ug+JWEP7ine4Uba7IMcqDNOgcLFOoXcKjjKgpWsyWralljzSYc/zjg2WaQr
2EtE0I4sTOmvdjacdoapJJmtJBen6VhW2OlQrg7FjYg6xYdMMpjzrSP1/eapib8J
JKS0b6d3SLB4qZb5SgYTeN8moEFAglaTDPq9X/iLn74iYvIuIOHl1cGyoT+d06Kd
zt40owkOkn+4xRPt4wtOSu/aqvXnNskCAwEAAaNTMFEwHQYDVR0OBBYEFEQCmP4g
dffVifbgAGoT32R/bh0oMB8GA1UdIwQYMBaAFEQCmP4gdffVifbgAGoT32R/bh0o
MA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBABXsnkPux4/5LXPq
2A42X4fdSgx20nHE0/HoW4hAfP/ycVjDJWsXo9zI95/01IxPJn5zn8V1zoYo2Jmz
HvoS/SvfD+5wobZlcAYePU5WgVMLEjyr7Hhz4nies81Eri+HTE9emjeX9aStWWTs
R2VLrZVsQquLg9pzIfKHvQ7C+bXhAxBi+Xd98VSe3G/FWg6o08IVHsGJ2t6MIFC/
uaxvN/06DpZm3Ct8P8m4QQj4ncNboz6v9EE2PgbsszkZKzXkn4OSMgivtxfP4Qsr
ZIpV3in+6uLPQNR52BVbli6Df6+5sN4edwgqLRMv89RkAERhhG590qUtntLBYPGg
/NwPuyU=
-----END CERTIFICATE-----
EOF

#
# Static Key Source
#

subtest 'StaticKeySource' => sub {
    my $key1 = Google::Auth::IDTokens::KeyInfo->new(
        { id => "1234", key => "key1", algorithm => "RS256" } );
    my $key2 = Google::Auth::IDTokens::KeyInfo->new(
        { id => "5678", key => "key2", algorithm => "ES256" } );
    my $keys   = [ $key1, $key2 ];
    my $source = Google::Auth::IDTokens::StaticKeySource->new( { keys => $keys } );

    is( ref $key1, "Google::Auth::IDTokens::KeyInfo", 'KeyInfo object correct' );
    is_deeply( [$source->current_keys], $keys, 'returns a static set of keys' );
    is_deeply( [$source->refresh_keys], $keys, 'does not change on refresh' );
};

#
# HttpKeySource Base Class (Testing with mocks)
#

subtest 'HttpKeySource' => sub {
    my $uri = "https://example.com/keys";
    my $mock_transport = MockTransport->new();
    
    # 1. Invalid JSON
    $mock_transport->map_response($uri, 200, "not json");
    my $source = Google::Auth::IDTokens::HttpKeySource->new({ 
        uri => $uri, 
        transport => $mock_transport 
    });
    
    throws_ok { $source->refresh_keys } qr/KeySourceError: Unable to parse JSON/, 
        'raises error on invalid JSON';

    # 2. HTTP Error
    $mock_transport->map_response($uri, 404, "Not Found");
    $source = Google::Auth::IDTokens::HttpKeySource->new({ 
        uri => $uri, 
        transport => $mock_transport 
    });
    throws_ok { $source->refresh_keys } qr/KeySourceError: Unable to retrieve data/, 
        'raises error on 404';
};

#
# X509CertHttpKeySource
#

subtest 'X509CertHttpKeySource' => sub {
    my $uri = "https://example.com/certs";
    my $mock_transport = MockTransport->new();
    my $coder = JSON::XS->new->ascii;
    
    my $certs_body = {
        "key1" => $cert1_pem,
        "key2" => $cert2_pem
    };
    $mock_transport->map_response($uri, 200, $coder->encode($certs_body));

    my $source = Google::Auth::IDTokens::X509CertHttpKeySource->new({ 
        uri => $uri, 
        transport => $mock_transport 
    });

    my @keys;
    lives_ok { @keys = $source->refresh_keys } 'refresh succeeds';
    is( scalar @keys, 2, 'two keys returned' );
    is( $keys[0]->id, "key1", 'first key ID matches' );
    is( $keys[1]->id, "key2", 'second key ID matches' );
    isa_ok( $keys[0]->key, 'Crypt::PK::RSA' );
};

#
# JwkHttpKeySource
#

subtest 'JwkHttpKeySource' => sub {
    my $uri = "https://example.com/jwks";
    my $mock_transport = MockTransport->new();
    my $coder = JSON::XS->new->ascii;

    my $jwk1 = {
        alg => "RS256",
        e   => "AQAB",
        kid => "id1",
        kty => "RSA",
        n   => "zK8PHf_6V3G5rU-viUOL1HvAYn7q--dxMoUkt7x1rSWX6fimla-lpoYAKhFTLU"
            . "ELkRKy_6UDzfybz0P9eItqS2UxVWYpKYmKTQ08HgUBUde4GtO_B0SkSk8iLtGh"
            . "653UBBjgXmfzdfQEz_DsaWn7BMtuAhY9hpMtJye8LQlwaS8ibQrsC0j0GZM5KX"
            . "RITHwfx06_T1qqC_MOZRA6iJs-J2HNlgeyFuoQVBTY6pRqGXa-qaVsSG3iU-vq"
            . "NIciFquIq-xydwxLqZNksRRer5VAsSHf0eD3g2DX-cf6paSy1aM40svO9EfSvG"
            . "_07MuHafEE44RFvSZZ4ubEN9U7ALSjdw",
    };
    
    my $jwks_body = { keys => [ $jwk1 ] };
    $mock_transport->map_response($uri, 200, $coder->encode($jwks_body));

    my $source = Google::Auth::IDTokens::JwkHttpKeySource->new({ 
        uri => $uri, 
        transport => $mock_transport 
    });

    my @keys;
    lives_ok { @keys = $source->refresh_keys } 'JWK refresh succeeds';
    is( scalar @keys, 1, 'one JWK returned' );
    is( $keys[0]->id, "id1", 'JWK ID matches' );
    isa_ok( $keys[0]->key, 'Crypt::PK::RSA' );
};

#
# AggregateKeySource
#

subtest 'AggregateKeySource' => sub {
    my $k1 = Google::Auth::IDTokens::KeyInfo->new({ id => 'a', key => 'k1', algorithm => 'RS256' });
    my $k2 = Google::Auth::IDTokens::KeyInfo->new({ id => 'b', key => 'k2', algorithm => 'RS256' });
    
    my $s1 = Google::Auth::IDTokens::StaticKeySource->new({ keys => [$k1] });
    my $s2 = Google::Auth::IDTokens::StaticKeySource->new({ keys => [$k2] });
    
    my $agg = Google::Auth::IDTokens::AggregateKeySource->new({ sources => [$s1, $s2] });
    
    my @keys = $agg->current_keys();
    is( scalar @keys, 2, 'aggregates keys from both sources' );
    is_deeply( \@keys, [$k1, $k2], 'keys match' );
};

done_testing();

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

package Google::Auth::IDTokens::Verifier;

use strict;
use warnings;
use Log::Any qw($log);
use Google::Auth::Exceptions;

use JSON::XS;
use Google::Auth::IDTokens::KeySources;
use Google::Auth::Transport::LWP;
use Google::Auth::Codec;
use Google::Auth::IDTokens::OpenSSL;

our $VERSION = '0.02';

my $JSON = JSON::XS->new()->utf8();

##
# An object that can verify ID tokens.
#
# A verifier maintains a set of default settings, including the key
# source and fields to verify. However, individual verification calls can
# override any of these settings.
#

sub new {
    my ( $class, $params ) = @_;
    my $self = bless {
        key_source => $params->{key_source},
        aud        => $params->{aud},
        azp        => $params->{azp},
        iss        => $params->{iss},
        transport  => $params->{transport} || Google::Auth::Transport::LWP->new(),
    }, $class;
    return $self;
}

sub verify {
    my ( $self, $token, %options ) = @_;

    my $key_source = $options{key_source} // $self->{key_source};
    my $aud        = $options{aud}        // $self->{aud};
    my $azp        = $options{azp}        // $self->{azp};
    my $iss        = $options{iss}        // $self->{iss};

    unless ($key_source) {
        Google::Auth::Error->throw('No key source provided');
    }

    my @keys = $key_source->current_keys();
    my $payload = $self->decode_token( $token, \@keys, $aud, $azp, $iss );

    unless ($payload) {
        @keys = $key_source->refresh_keys();
        $payload = $self->decode_token( $token, \@keys, $aud, $azp, $iss );
    }

    unless ($payload) {
        Google::Auth::Error->throw('Token not verified as issued by Google');
    }

    return $payload;
}

sub decode_token {
    my ( $self, $token, $keys, $aud, $azp, $iss ) = @_;

    my $payload = $self->_jwt_decode_and_verify( $token, $keys );
    return if !$payload;

    return $self->normalize_and_verify_payload( $payload, $aud, $azp, $iss );
}

sub _jwt_decode_and_verify {
    my ( $self, $token, $keys ) = @_;

    my @parts = split( /\./, $token );
    unless (scalar @parts == 3) {
        Google::Auth::Error->throw('Invalid token format');
    }

    my ( $header_b64, $payload_b64, $signature_b64 ) = @parts;
    
    my $header_json = Google::Auth::Codec::base64url_decode($header_b64);
    my $header = $JSON->decode($header_json);

    unless ($header->{alg} eq 'RS256') {
        Google::Auth::Error->throw('Unsupported algorithm: ' . $header->{alg});
    }

    my $message = $header_b64 . '.' . $payload_b64;
    my $signature = Google::Auth::Codec::base64url_decode($signature_b64);

    my $verified = 0;
    foreach my $key_info (@$keys) {
        # Google ID tokens are RS256. 
        # KeyInfo->key currently returns a Crypt::PK::RSA object or similar.
        # We need the DER representation of the public key for our XS function.
        
        my $pubkey_der = $key_info->key_der;

        if ( Google::Auth::IDTokens::OpenSSL::verify_rs256($message, $signature, $pubkey_der) ) {
            $verified = 1;
            last;
        }
    }

    unless ($verified) {
        Google::Auth::Error->throw('Signature verification failed');
    }

    my $payload_json = Google::Auth::Codec::base64url_decode($payload_b64);
    return $JSON->decode($payload_json);
}

sub normalize_and_verify_payload {
    my ( $self, $payload, $aud, $azp, $iss ) = @_;
    return unless $payload;

    # Map legacy "cid" to "azp"
    $payload->{azp} //= $payload->{cid} if exists $payload->{cid};

    # Audience check
    if ($aud) {
        my $match = 0;
        my @auds = ref $aud eq 'ARRAY' ? @$aud : ($aud);
        my @p_auds = ref $payload->{aud} eq 'ARRAY' ? @{$payload->{aud}} : ($payload->{aud});
        foreach my $a (@auds) {
            foreach my $pa (@p_auds) {
                if ($a eq $pa) { $match = 1; last; }
            }
            last if $match;
        }
        unless ($match) {
            Google::Auth::Error->throw('Audience mismatch');
        }
    }

    # Authorized party check
    if ($azp) {
        my $match = 0;
        my @azps = ref $azp eq 'ARRAY' ? @$azp : ($azp);
        my @p_azps = ref $payload->{azp} eq 'ARRAY' ? @{$payload->{azp}} : ($payload->{azp});
        foreach my $a (@azps) {
            foreach my $pa (@p_azps) {
                if ($a eq $pa) { $match = 1; last; }
            }
            last if $match;
        }
        unless ($match) {
            Google::Auth::Error->throw('Authorized party mismatch');
        }
    }

    # Issuer check
    if ($iss) {
        my $match = 0;
        my @isss = ref $iss eq 'ARRAY' ? @$iss : ($iss);
        my @p_isss = ref $payload->{iss} eq 'ARRAY' ? @{$payload->{iss}} : ($payload->{iss});
        foreach my $i (@isss) {
            foreach my $pi (@p_isss) {
                if ($i eq $pi) { $match = 1; last; }
            }
            last if $match;
        }
        unless ($match) {
            Google::Auth::Error->throw('Issuer mismatch');
        }
    }

    return $payload;
}

1;

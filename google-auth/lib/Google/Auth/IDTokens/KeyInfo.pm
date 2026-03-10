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

package Google::Auth::IDTokens::KeyInfo;

use strict;
use warnings;

use Carp;
use JSON::XS;
use Crypt::PK::RSA;
use Crypt::PK::ECC;

our $VERSION = '0.01';

my $coder = JSON::XS->new->ascii->pretty->allow_nonref;

##
# A public key used for verifying ID tokens.
#
# This includes the public key data, ID, and the algorithm used for
# signature verification. RSA and Elliptical Curve (EC) keys are
# supported.
#

sub new {
    my ( $class, $params ) = @_;
    my $self = bless {
        id        => $params->{id},
        key       => $params->{key},
        algorithm => $params->{algorithm},
    }, $class;
    return $self;
}

sub id        { return $_[0]->{id} }
sub key       { return $_[0]->{key} }
sub algorithm { return $_[0]->{algorithm} }

sub key_der {
    my $self = shift;
    my $key = $self->key;
    if ($key->can('export_key_der')) {
        return $key->export_key_der('public');
    }
    die "Cannot export DER for this key type";
}

##
# Create a KeyInfo from a single JWK.
#
sub from_jwk {
    my ( $class, $jwk ) = @_;
    $jwk = _ensure_json_parsed($jwk);

    my $key;
    if ( ( $jwk->{kty} || '' ) eq 'RSA' ) {
        $key = _extract_rsa_key($jwk);
    }
    elsif ( ( $jwk->{kty} || '' ) eq 'EC' ) {
        $key = _extract_ec_key($jwk);
    }
    elsif ( !defined $jwk->{kty} ) {
        die "Key type not found";
    }
    else {
        die "Cannot use key type $jwk->{kty}";
    }

    return $class->new(
        {
            id        => $jwk->{kid},
            key       => $key,
            algorithm => $jwk->{alg},
        }
    );
}

##
# Create an array of KeyInfo from a JWK Set.
#
sub from_jwk_set {
    my ( $class, $jwk_set ) = @_;
    $jwk_set = _ensure_json_parsed($jwk_set);
    confess "No keys found in jwk set"
        unless ( exists $jwk_set->{keys} && ref $jwk_set->{keys} eq 'ARRAY' );

    return [ map { $class->from_jwk($_) } @{ $jwk_set->{keys} } ];
}

sub _ensure_json_parsed {
    my ($input) = @_;
    return $input if ref $input;
    my $decoded = eval { $coder->decode($input) };
    confess("Unable to parse JSON: $@") if $@;
    return $decoded;
}

sub _extract_rsa_key {
    my ($jwk) = @_;
    my $pk = Crypt::PK::RSA->new();
    $pk->import_key($jwk);
    return $pk;
}

sub _extract_ec_key {
    my ($jwk) = @_;
    my $pk = Crypt::PK::ECC->new();
    $pk->import_key($jwk);
    return $pk;
}

1;

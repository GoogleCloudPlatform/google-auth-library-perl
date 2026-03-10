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

package Google::Auth::IDTokens::KeySource::X509CertHttp;

use strict;
use warnings;

use Google::Auth::IDTokens::KeySource::Http;
use Google::Auth::IDTokens::KeyInfo;
use Google::Auth::IDTokens::OpenSSL;
use Crypt::PK::RSA;
use Crypt::PK::ECC;

our @ISA = qw(Google::Auth::IDTokens::KeySource::Http);
our $VERSION = '0.01';

##
# A key source that downloads X509 certificates.
# Used by the legacy OAuth V1 public certs endpoint.
#

sub new {
    my ( $class, $params ) = @_;
    my $self = $class->SUPER::new($params);
    $self->{algorithm} = $params->{algorithm} || 'RS256';
    return $self;
}

sub interpret_json {
    my ( $self, $data ) = @_;
    my @keys;
    foreach my $id ( sort keys %$data ) {
        my $cert_str = $data->{$id};
        my $der_key = Google::Auth::IDTokens::OpenSSL::get_pubkey_from_x509($cert_str);
        my $pk;
        if ( $self->{algorithm} =~ /^RS/ ) {
            $pk = Crypt::PK::RSA->new();
        }
        else {
            $pk = Crypt::PK::ECC->new();
        }
        $pk->import_key( \$der_key );
        push @keys, Google::Auth::IDTokens::KeyInfo->new(
            {
                id        => $id,
                key       => $pk,
                algorithm => $self->{algorithm},
            }
        );
    }
    return @keys;
}

1;

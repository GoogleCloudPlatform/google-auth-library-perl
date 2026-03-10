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

package Google::Auth::ServiceAccountCredentials;

use strict;
use warnings;
use Moo;
use JSON::XS;
use Google::Auth::Credentials;
use Google::Auth::Codec;
use Google::Auth::IDTokens::OpenSSL;

extends 'Google::Auth::Credentials';

our $VERSION = '0.02';

my $JSON = JSON::XS->new()->utf8();

has project_id => ( is => 'ro' );
has client_email => ( is => 'ro' );
has private_key => ( is => 'ro' );
has token_uri => ( is => 'ro', default => 'https://oauth2.googleapis.com/token' );
has scopes => ( is => 'rw' );

sub from_json {
    my ($class, $json_text, %args) = @_;
    my $data = $JSON->decode($json_text);
    return $class->from_hash($data, %args);
}

sub from_hash {
    my ($class, $data, %args) = @_;
    return $class->new(
        project_id   => $data->{project_id},
        client_email => $data->{client_email},
        private_key  => $data->{private_key},
        token_uri    => $data->{token_uri} // 'https://oauth2.googleapis.com/token',
        scopes       => $args{scopes},
    );
}

sub refresh {
    my ($self, $transport) = @_;

    my $now = time();
    my $assertion = $self->_create_assertion($now);
    
    my $response = $transport->request(
        url => $self->token_uri,
        method => 'POST',
        headers => { 'Content-Type' => 'application/x-www-form-urlencoded' },
        body => "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=$assertion",
    );

    if ($response->status != 200) {
        die "Failed to refresh token: " . $response->data;
    }

    my $token_data = $JSON->decode($response->data);
    $self->token($token_data->{access_token});
    $self->expiry($now + $token_data->{expires_in});
    
    return $self->token;
}

sub _create_assertion {
    my ($self, $now) = @_;

    my $header = {
        alg => 'RS256',
        typ => 'JWT',
    };

    my $payload = {
        iss   => $self->client_email,
        sub   => $self->client_email,
        aud   => $self->token_uri,
        iat   => $now,
        exp   => $now + 3600,
        scope => join(' ', @{$self->scopes // []}),
    };

    my $header_b64 = Google::Auth::Codec::base64url_encode($JSON->encode($header));
    my $payload_b64 = Google::Auth::Codec::base64url_encode($JSON->encode($payload));

    my $message = "$header_b64.$payload_b64";
    my $signature = Google::Auth::IDTokens::OpenSSL::sign_rs256($message, $self->private_key);
    my $signature_b64 = Google::Auth::Codec::base64url_encode($signature);

    return "$message.$signature_b64";
}

1;

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

package Google::Auth::ImpersonatedServiceAccountCredentials;

use strict;
use warnings;

use Moo;
use JSON::PP;
use LWP::UserAgent;
use Google::Auth::Exceptions;

our $VERSION = '0.02';

has base_credentials => (
    is       => 'ro',
    required => 0,
);

has source_credentials => (
    is       => 'ro',
    required => 0,
);

has impersonation_url => (
    is       => 'ro',
    required => 1,
);

has scope => (
    is       => 'ro',
    required => 1,
);

has access_token => (
    is  => 'rw',
);

has expires_at => (
    is  => 'rw',
);

has ua => (
    is      => 'ro',
    default => sub { LWP::UserAgent->new( timeout => 10 ) },
);

around BUILDARGS => sub {
    my ( $orig, $class, @args ) = @_;
    my $args = $class->$orig(@args);

    if ( my $json = $args->{json_key} ) {
        $args->{impersonation_url} //= $json->{service_account_impersonation_url};
        $args->{scope}             //= $json->{scopes};
        if ( my $source_creds_info = $json->{source_credentials} ) {
            require Google::Auth::DefaultCredentials;
            $args->{source_credentials} //= Google::Auth::DefaultCredentials->make_creds(
                json_key => $source_creds_info,
            );
        }
    }

    if ( !defined $args->{source_credentials} && !defined $args->{base_credentials} ) {
        die 'Missing required option: either source_credentials or base_credentials must be provided';
    }

    $args->{source_credentials} //= $args->{base_credentials};

    return $args;
};

sub fetch_access_token {
    my ( $self, %options ) = @_;

    my $source_creds = $self->source_credentials;
    my $source_token;

    if ( $source_creds->can('access_token') && defined $source_creds->access_token ) {
        $source_token = $source_creds->access_token;
    }
    elsif ( $source_creds->can('fetch_access_token') ) {
        $source_token = $source_creds->fetch_access_token(%options);
    }
    else {
        Google::Auth::Error->throw('Source credentials do not have a valid access token or fetch_access_token method');
    }

    my $req_body = encode_json({
        scope => ref $self->scope eq 'ARRAY' ? $self->scope : [ $self->scope ]
    });

    my $ua = $self->ua;
    my $response = $ua->post(
        $self->impersonation_url,
        'Content-Type'  => 'application/json',
        'Authorization' => 'Bearer ' . $source_token,
        'Content'       => $req_body
    );

    if ( !$response->is_success ) {
        Google::Auth::Error->throw(
            'Service account impersonation failed with status ' . $response->code . ': ' . $response->decoded_content
        );
    }

    my $res_data = decode_json($response->decoded_content);
    $self->access_token($res_data->{accessToken});
    $self->expires_at($res_data->{expireTime});

    return $res_data->{accessToken};
}

1;

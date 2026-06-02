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

package Google::Auth::ExternalAccountCredentials;

use strict;
use warnings;

use Moo;
use JSON::PP;
use LWP::UserAgent;
use Google::Auth::Exceptions;

our $VERSION = '0.02';

has audience => (
    is       => 'ro',
    required => 1,
);

has subject_token_type => (
    is       => 'ro',
    required => 1,
);

has token_url => (
    is       => 'ro',
    required => 1,
);

has credential_source => (
    is       => 'ro',
    required => 1,
);

has service_account_impersonation_url => (
    is       => 'ro',
    required => 0,
);

has scope => (
    is       => 'ro',
    required => 0,
);

has universe_domain => (
    is      => 'ro',
    default => sub { 'googleapis.com' },
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
        $args->{audience}                          //= $json->{audience};
        $args->{subject_token_type}                //= $json->{subject_token_type};
        $args->{token_url}                         //= $json->{token_url};
        $args->{credential_source}                 //= $json->{credential_source};
        $args->{service_account_impersonation_url} //= $json->{service_account_impersonation_url};
        $args->{universe_domain}                   //= $json->{universe_domain};
    }

    return $args;
};

sub BUILD {
    my ($self) = @_;

    my $source = $self->credential_source;
    if ( !defined $source ) {
        Google::Auth::Error->throw('Missing credential_source. A \'file\' or \'url\' must be provided.');
    }

    if ( exists $source->{environment_id} && defined $source->{environment_id} ) {
        Google::Auth::Error->throw('Invalid Identity Pool credential_source field \'environment_id\'');
    }

    my $file = $source->{file};
    my $url  = $source->{url};

    if ( defined $file && defined $url ) {
        Google::Auth::Error->throw('Ambiguous credential_source. \'file\' is mutually exclusive with \'url\'.');
    }

    if ( !defined $file && !defined $url ) {
        Google::Auth::Error->throw('Missing credential_source. A \'file\' or \'url\' must be provided.');
    }

    my $format = $source->{format} // {};
    my $format_type = $format->{type} // 'text';

    if ( $format_type ne 'text' && $format_type ne 'json' ) {
        Google::Auth::Error->throw('Invalid credential_source format ' . $format_type);
    }

    if ( $format_type eq 'json' && !defined $format->{subject_token_field_name} ) {
        Google::Auth::Error->throw('Missing subject_token_field_name for JSON credential_source format');
    }
}

sub retrieve_subject_token {
    my ($self) = @_;

    my $source = $self->credential_source;
    my $content;
    my $source_name;

    if ( defined $source->{file} ) {
        $source_name = $source->{file};
        if ( ! -f $source_name ) {
            Google::Auth::Error->throw('Credential source file ' . $source_name . ' not found');
        }
        open( my $fh, '<:encoding(UTF-8)', $source_name )
          or Google::Auth::Error->throw('Could not open credential source file ' . $source_name . ': ' . $!);
        local $/;
        $content = <$fh>;
        close($fh);
    }
    else {
        $source_name = $source->{url};
        my $headers = $source->{headers} // {};
        my $ua = $self->ua;
        
        my @header_list;
        while ( my ( $k, $v ) = each %$headers ) {
            push @header_list, $k => $v;
        }

        my $response = $ua->get( $source_name, @header_list );
        if ( !$response->is_success ) {
            Google::Auth::Error->throw('Failed to retrieve subject token from URL ' . $source_name . ': ' . $response->status_line);
        }
        $content = $response->decoded_content;
    }

    my $format = $source->{format} // {};
    my $format_type = $format->{type} // 'text';

    if ( $format_type eq 'text' ) {
        return $content;
    }
    else {
        my $field = $format->{subject_token_field_name};
        my $data = eval { decode_json($content) };
        if ($@) {
            Google::Auth::Error->throw('Failed to parse JSON from credential resource ' . $source_name . ': ' . $@);
        }
        my $token = $data->{$field};
        if ( !defined $token ) {
            Google::Auth::Error->throw('Missing field ' . $field . ' in OIDC JSON response');
        }
        return $token;
    }
}

sub fetch_access_token {
    my ( $self, %options ) = @_;

    my $subject_token = $self->retrieve_subject_token();

    my $scopes = $self->scope // ['https://www.googleapis.com/auth/cloud-platform'];
    my @scopes_list = ref $scopes eq 'ARRAY' ? @$scopes : ($scopes);

    my $sts_payload = {
        grant_type           => 'urn:ietf:params:oauth:grant-type:token-exchange',
        audience             => $self->audience,
        subject_token        => $subject_token,
        subject_token_type   => $self->subject_token_type,
        requested_token_type => 'urn:ietf:params:oauth:token-type:access_token',
        scope                => join( ' ', @scopes_list ),
    };

    my $ua = $self->ua;
    my $response = $ua->post(
        $self->token_url,
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Content'      => $sts_payload
    );

    if ( !$response->is_success ) {
        Google::Auth::Error->throw('Token exchange failed with status ' . $response->code . ': ' . $response->decoded_content);
    }

    my $sts_data = decode_json($response->decoded_content);
    my $sts_token = $sts_data->{access_token};

    if ( $self->service_account_impersonation_url ) {
        my $impersonation_body = encode_json({
            scope => \@scopes_list
        });

        my $impers_res = $ua->post(
            $self->service_account_impersonation_url,
            'Content-Type'  => 'application/json',
            'Authorization' => 'Bearer ' . $sts_token,
            'Content'       => $impersonation_body
        );

        if ( !$impers_res->is_success ) {
            Google::Auth::Error->throw('Service account impersonation failed with status ' . $impers_res->code . ': ' . $impers_res->decoded_content);
        }

        my $impers_data = decode_json($impers_res->decoded_content);
        $self->access_token($impers_data->{accessToken});
        $self->expires_at($impers_data->{expireTime});
        return $impers_data->{accessToken};
    }

    $self->access_token($sts_token);
    
    my $expires_in = $sts_data->{expires_in} // 3600;
    my @t = gmtime( time + $expires_in );
    my $expire_iso = sprintf('%04d-%02d-%02dT%02d:%02d:%02dZ', $t[5]+1900, $t[4]+1, $t[3], $t[2], $t[1], $t[0]);
    $self->expires_at($expire_iso);

    return $sts_token;
}

1;

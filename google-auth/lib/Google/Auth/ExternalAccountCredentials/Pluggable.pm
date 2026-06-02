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

package Google::Auth::ExternalAccountCredentials::Pluggable;

use strict;
use warnings;

use Moo;
extends 'Google::Auth::ExternalAccountCredentials';

use JSON::PP;
use Google::Auth::Exceptions;
use Capture::Tiny qw(capture);

our $VERSION = '0.02';

sub retrieve_subject_token {
    my ($self) = @_;

    my $source = $self->credential_source;
    my $exec   = $source->{executable};
    if ( !defined $exec ) {
        Google::Auth::Error->throw('Missing executable configuration in credential_source');
    }

    my $command = $exec->{command};
    if ( !defined $command ) {
        Google::Auth::Error->throw('Missing command in executable configuration');
    }

    my $env_vars = $exec->{environment_variables} // {};
    local %ENV = %ENV;
    while ( my ( $k, $v ) = each %$env_vars ) {
        $ENV{$k} = $v;
    }

    my ($stdout, $stderr, $exit) = capture {
        system($command);
    };

    if ($exit != 0) {
        my $exit_code = $exit >> 8;
        Google::Auth::Error->throw('Pluggable credential command failed with exit code ' . $exit_code . ': ' . $stderr);
    }

    my $format      = $source->{format} // {};
    my $format_type = $format->{type} // 'json';

    my $token;
    if ( $format_type eq 'json' ) {
        my $data = eval { decode_json($stdout) };
        if ($@) {
            Google::Auth::Error->throw('Failed to parse JSON from pluggable command output: ' . $@);
        }
        my $field = $format->{subject_token_field_name} // 'id_token';
        $token = $data->{$field};
    }
    elsif ( $format_type eq 'text' ) {
        $token = $stdout;
        $token =~ s/\r?\n$//;
    }
    else {
        Google::Auth::Error->throw('Invalid credential_source format: ' . $format_type);
    }

    if ( !defined $token ) {
        Google::Auth::Error->throw('Pluggable credential command did not return a valid subject token');
    }

    return $token;
}

1;

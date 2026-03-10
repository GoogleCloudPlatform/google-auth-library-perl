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

package Google::Auth::IDTokens::KeySource::Http;

use strict;
use warnings;

use JSON::XS;
use Google::Auth::Transport::LWP;

our $VERSION = '0.01';
our $DEFAULT_RETRY_INTERVAL = 3600;

my $coder = JSON::XS->new->ascii->allow_nonref;

##
# A base key source that downloads keys from a URI.
#

sub new {
    my ( $class, $params ) = @_;
    die "uri is a required parameter" unless $params->{uri};

    my $self = bless {
        uri              => $params->{uri},
        retry_interval   => $params->{retry_interval} || $DEFAULT_RETRY_INTERVAL,
        allow_refresh_at => 0, # epoch
        current_keys     => [],
        transport        => $params->{transport} || Google::Auth::Transport::LWP->new(),
    }, $class;

    return $self;
}

sub uri          { return $_[0]->{uri} }
sub current_keys { return @{ $_[0]->{current_keys} } }

sub refresh_keys {
    my ($self) = @_;
    my $now = time();

    if ( $now < $self->{allow_refresh_at} ) {
        return @{ $self->{current_keys} };
    }

    my $response = $self->{transport}->request(
        url    => $self->{uri},
        method => 'GET',
    );

    if ( $response->status != 200 ) {
        die "KeySourceError: Unable to retrieve data from $self->{uri}: " . $response->status;
    }

    my $data = eval { $coder->decode( $response->data ) };
    die "KeySourceError: Unable to parse JSON: $@" if $@;

    my @keys = $self->interpret_json($data);
    $self->{current_keys} = \@keys;
    $self->{allow_refresh_at} = $now + $self->{retry_interval};

    return @keys;
}

sub interpret_json {
    my ( $self, $data ) = @_;
    die "interpret_json must be implemented by subclass";
}

1;

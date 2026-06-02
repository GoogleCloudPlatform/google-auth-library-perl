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

package Google::Auth::Credentials;

use strict;
use warnings;

use Moo;
use Time::Piece;
use Google::Auth::Exceptions;
use Time::HiRes;

our $VERSION = '0.02';

has access_token => (
    is  => 'rw',
);

has expires_at => (
    is  => 'rw',
);

has universe_domain => (
    is      => 'ro',
    default => sub { 'googleapis.com' },
);

has clock_skew => (
    is      => 'ro',
    default => sub { 300 },
);

has is_refreshing => (
    is      => 'rw',
    default => sub { 0 },
);

sub fetch_access_token {
    my ( $self, %options ) = @_;
    Google::Auth::Error->throw('fetch_access_token must be implemented by subclasses');
}

sub is_expired {
    my ( $self, %options ) = @_;
    my $expires = $self->expires_at;
    return 1 if !defined $expires;

    my $skew = $options{clock_skew} // $self->clock_skew;

    my $expiry_epoch;
    if ( $expires =~ /^\d+$/ ) {
        $expiry_epoch = $expires;
    }
    else {
        my $tp = eval { Time::Piece->strptime($expires, '%Y-%m-%dT%H:%M:%SZ') };
        if ($@ || !$tp) {
            $tp = eval { Time::Piece->strptime($expires, '%Y-%m-%dT%H:%M:%S.%fZ') };
        }
        $expiry_epoch = $tp ? $tp->epoch : time();
    }

    return ( time + $skew >= $expiry_epoch ) ? 1 : 0;
}

sub get_token {
    my ( $self, %options ) = @_;

    if ( $self->is_refreshing ) {
        my $limit = 30;
        while ( $self->is_refreshing && $limit-- > 0 ) {
            if ( exists $INC{'Coro.pm'} ) {
                Coro::cede();
            }
            elsif ( exists $INC{'threads.pm'} ) {
                threads->yield();
            }
            else {
                Time::HiRes::sleep(0.1);
            }
        }
        return $self->access_token;
    }

    if ( $self->is_expired(%options) || !defined $self->access_token ) {
        $self->is_refreshing(1);
        eval {
            $self->fetch_access_token(%options);
        };
        my $err = $@;
        $self->is_refreshing(0);
        if ($err) {
            die $err;
        }
    }
    return $self->access_token;
}

sub apply {
    my ( $self, $req_or_headers, %options ) = @_;
    my $token = $self->get_token(%options);

    if ( ref $req_or_headers eq 'HASH' ) {
        $req_or_headers->{Authorization} = 'Bearer ' . $token;
    }
    elsif ( eval { $req_or_headers->isa('HTTP::Request') } ) {
        $req_or_headers->header( Authorization => 'Bearer ' . $token );
    }
    else {
        Google::Auth::Error->throw('apply expected a HASH reference or HTTP::Request object');
    }
}

1;

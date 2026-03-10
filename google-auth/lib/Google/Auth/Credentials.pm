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

our $VERSION = '0.01';

has token => ( is => 'rw' );
has expiry => ( is => 'rw' );

sub refresh {
    my ($self, $request) = @_;
    die "refresh() must be implemented by subclass";
}

sub apply {
    my ($self, $headers) = @_;
    my $token = $self->token;
    if ($token) {
        $headers->{'Authorization'} = "Bearer $token";
    }
}

sub before_request {
    my ($self, $request, $method, $url, $headers) = @_;
    $self->refresh($request) if $self->requires_refresh;
    $self->apply($headers);
}

sub requires_refresh {
    my ($self) = @_;
    return 1 unless $self->token;
    return 1 if $self->expiry && $self->expiry < time();
    return 0;
}

1;

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

package Google::Auth::IDTokens::KeySource::Static;

use strict;
use warnings;

use Google::Auth::IDTokens::KeyInfo;

our $VERSION = '0.01';

##
# A key source that contains a static set of keys.
#

sub new {
    my ( $class, $params ) = @_;
    my $keys = $params->{keys} || [];
    my $self = bless { current_keys => [ @$keys ] }, $class;
    return $self;
}

sub current_keys { return @{ $_[0]->{current_keys} } }
sub refresh_keys { return $_[0]->current_keys }

sub from_jwk {
    my ( $class, $jwk ) = @_;
    my $key_info = Google::Auth::IDTokens::KeyInfo->from_jwk($jwk);
    return $class->new( { keys => [$key_info] } );
}

sub from_jwk_set {
    my ( $class, $jwk_set ) = @_;
    my $key_infos = Google::Auth::IDTokens::KeyInfo->from_jwk_set($jwk_set);
    return $class->new( { keys => $key_infos } );
}

1;

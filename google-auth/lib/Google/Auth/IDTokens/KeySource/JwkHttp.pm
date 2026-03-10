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

package Google::Auth::IDTokens::KeySource::JwkHttp;

use strict;
use warnings;

use Google::Auth::IDTokens::KeySource::Http;
use Google::Auth::IDTokens::KeyInfo;

our @ISA = qw(Google::Auth::IDTokens::KeySource::Http);
our $VERSION = '0.01';

##
# A key source that downloads a JWK set.
#

sub interpret_json {
    my ( $self, $data ) = @_;
    my $key_infos = Google::Auth::IDTokens::KeyInfo->from_jwk_set($data);
    return @$key_infos;
}

1;

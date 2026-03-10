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

package Google::Auth::IDTokens::KeySources;

use strict;
use warnings;

use Google::Auth::IDTokens::KeyInfo;
use Google::Auth::IDTokens::KeySource::Static;
use Google::Auth::IDTokens::KeySource::Http;
use Google::Auth::IDTokens::KeySource::X509CertHttp;
use Google::Auth::IDTokens::KeySource::JwkHttp;
use Google::Auth::IDTokens::KeySource::Aggregate;

our $VERSION = '0.03';

1;

package Google::Auth::IDTokens::StaticKeySource;
use base 'Google::Auth::IDTokens::KeySource::Static';
1;

package Google::Auth::IDTokens::HttpKeySource;
use base 'Google::Auth::IDTokens::KeySource::Http';
1;

package Google::Auth::IDTokens::X509CertHttpKeySource;
use base 'Google::Auth::IDTokens::KeySource::X509CertHttp';
1;

package Google::Auth::IDTokens::JwkHttpKeySource;
use base 'Google::Auth::IDTokens::KeySource::JwkHttp';
1;

package Google::Auth::IDTokens::AggregateKeySource;
use base 'Google::Auth::IDTokens::KeySource::Aggregate';
1;

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

package Google::Auth::DefaultCredentials;

use strict;
use warnings;
use JSON::XS;
use Log::Any qw($log);

use Google::Auth::ServiceAccountCredentials;
use Google::Auth::ComputeEngineCredentials;
use Google::Auth::EnvironmentVars;

our $VERSION = '0.02';

my $JSON = JSON::XS->new()->utf8();

sub get_application_default {
    my ($class, %args) = @_;

    # 1. Environment variable
    my $env_vars = Google::Auth::EnvironmentVars->new();
    my $file = $env_vars->CREDENTIALS;
    if ($file && -f $file) {
        return $class->_from_file($file, %args);
    }

    # 2. Well-known file (e.g. Cloud SDK path)
    # TODO: Implement well-known paths check

    # 3. Compute Engine
    # We should probably check if we are on GCE first, but often we just try the request.
    # For now, return a GCE credentials object as fallback.
    return Google::Auth::ComputeEngineCredentials->new(%args);
}

sub _from_file {
    my ($class, $file, %args) = @_;
    open my $fh, '<', $file or die 'Can\'t open ' . $file . ': ' . $!;
    my $content = do { local $/; <$fh> };
    close $fh;

    my $data = $JSON->decode($content);
    if ($data->{type} eq 'service_account') {
        return Google::Auth::ServiceAccountCredentials->from_hash($data, %args);
    }
    
    die 'Unsupported credential type: ' . $data->{type};
}

1;

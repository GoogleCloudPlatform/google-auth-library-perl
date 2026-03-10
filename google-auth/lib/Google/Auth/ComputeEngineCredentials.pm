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

package Google::Auth::ComputeEngineCredentials;

use strict;
use warnings;
use Moo;
use JSON::XS;
use Log::Any qw($log);
use Google::Auth::Credentials;

extends 'Google::Auth::Credentials';

our $VERSION = '0.01';

my $JSON = JSON::XS->new()->utf8();
my $METADATA_IP = '169.254.169.254';
my $TOKEN_PATH = '/computeMetadata/v1/instance/service-accounts/default/token';

sub refresh {
    my ($self, $transport) = @_;

    my $url = 'http://' . $METADATA_IP . $TOKEN_PATH;
    my $response = $transport->request(
        url => $url,
        method => 'GET',
        headers => { 'Metadata-Flavor' => 'Google' },
    );

    if ($response->status != 200) {
        $log->error('Failed to refresh GCE token: ' . $response->data);
        return;
    }

    my $token_data = $JSON->decode($response->data);
    $self->token($token_data->{access_token});
    $self->expiry(time() + $token_data->{expires_in});
    
    return $self->token;
}

1;

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

package Google::Auth::Transport;

use strict;
use warnings;

our $VERSION = '0.01';

##
# Interface for a transport that makes HTTP requests.
#
# Specific transport implementations should provide an implementation of
# this that adapts their specific request / response API.
#

=head1 NAME

Google::Auth::Transport - Interface for HTTP transport adapters

=head1 SYNOPSIS

    my $transport = Google::Auth::Transport::LWP->new();
    my $response = $transport->request(
        url     => 'https://example.com',
        method  => 'GET',
        headers => { 'Authorization' => 'Bearer ...' },
    );

    print $response->status;
    print $response->data;

=head1 METHODS

=head2 request

Makes an HTTP request.

Parameters (passed as a hash):

=over 4

=item * url (required): The URL to request.

=item * method: The HTTP method (default: 'GET').

=item * body: The request body.

=item * headers: A hash ref of request headers.

=item * timeout: Request timeout in seconds.

=back

Returns an object that responds to C<status>, C<headers>, and C<data>.

=cut

sub request {
    my ( $self, %args ) = @_;
    die 'request() must be implemented by subclass';
}

1;

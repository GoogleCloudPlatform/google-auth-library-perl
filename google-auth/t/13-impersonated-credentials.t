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

use strict;
use warnings;

use Test::More;
use Test::LWP::UserAgent;
use HTTP::Response;
use JSON::PP;

BEGIN
{
    use_ok('Google::Auth::ImpersonatedServiceAccountCredentials') || print "Bail out!\n";
}

subtest 'Impersonated Credentials Loading and Token Exchange' => sub {
    my $mock_ua = Test::LWP::UserAgent->new();
    
    package MockSource;
    use Moo;
    has access_token => ( is => 'ro', default => sub { 'mock-source-token' } );
    package main;

    my $source_creds = MockSource->new();

    my $creds = Google::Auth::ImpersonatedServiceAccountCredentials->new(
        source_credentials => $source_creds,
        impersonation_url => 'https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/test-sa@google.com:generateAccessToken',
        scope             => 'https://www.googleapis.com/auth/cloud-platform',
        ua                => $mock_ua,
    );

    ok( defined $creds, 'credentials object created' );
    is( $creds->impersonation_url, 'https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/test-sa@google.com:generateAccessToken', 'impersonation URL matches' );

    $mock_ua->map_response(
        sub {
            my ($request) = @_;
            return $request->url eq 'https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/test-sa@google.com:generateAccessToken'
               && $request->header('Authorization') eq 'Bearer mock-source-token'
               && $request->header('Content-Type') eq 'application/json';
        },
        HTTP::Response->new(
            200, 'OK',
            [ 'Content-Type' => 'application/json' ],
            encode_json({
                accessToken => 'mock-impersonated-token',
                expireTime  => '2026-06-02T08:30:00Z'
            })
        )
    );

    my $token = $creds->fetch_access_token();
    is( $token, 'mock-impersonated-token', 'exchanged token matches' );
    is( $creds->access_token, 'mock-impersonated-token', 'cached token matches' );
    is( $creds->expires_at, '2026-06-02T08:30:00Z', 'expiration time matches' );
};

subtest 'Load from JSON configuration' => sub {
    my $json_config = {
        type                            => 'impersonated_service_account',
        service_account_impersonation_url => 'https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/target-sa@google.com:generateAccessToken',
        scopes                          => [ 'https://www.googleapis.com/auth/compute' ],
        source_credentials              => {
            type         => 'service_account',
            project_id   => 'test-project',
            client_email => 'source-sa@google.com',
            private_key  => 'some-private-key',
        }
    };

    require Google::Auth::DefaultCredentials;
    my $creds = Google::Auth::DefaultCredentials->make_creds(
        json_key => $json_config,
    );

    ok( defined $creds, 'loaded credentials successfully' );
    isa_ok( $creds, 'Google::Auth::ImpersonatedServiceAccountCredentials' );
    is( $creds->impersonation_url, 'https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/target-sa@google.com:generateAccessToken', 'impersonation URL parsed' );
    is_deeply( $creds->scope, [ 'https://www.googleapis.com/auth/compute' ], 'scope parsed' );
    ok( defined $creds->source_credentials, 'source credentials loaded' );
    isa_ok( $creds->source_credentials, 'Google::Auth::ServiceAccountCredentials' );
    is( $creds->source_credentials->client_email, 'source-sa@google.com', 'source email matches' );
};

done_testing();

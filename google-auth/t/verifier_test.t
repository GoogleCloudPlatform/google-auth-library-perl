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
use Test::Exception;
use Test::Deep;

use Log::Any::Test;
use Log::Any qw($log);
use Log::Any::Adapter;

Log::Any::Adapter->set('Test', min_level => 'trace');

use Google::Auth::IDTokens::Verifier;
use Google::Auth::IDTokens::KeySource::Static;
use Google::Auth::IDTokens::KeyInfo;

# Mock JWT decoding to avoid Crypt::JWT dependency in tests
# MUST be done after loading Verifier.pm to override the real sub
{
    no strict 'refs';
    no warnings 'redefine';
    *Google::Auth::IDTokens::Verifier::_jwt_decode_and_verify = sub {
        my ($self, $token, $keys) = @_;
        $log->tracef('Mock decoding token: %s', $token);
        if ($token eq 'valid-token') {
            return {
                iss => 'https://accounts.google.com',
                sub => '12345',
                aud => 'my-client-id',
                exp => time() + 3600,
            };
        }
        $log->trace('Mock throwing Token not verified error');
        Google::Auth::Error->throw('Token not verified as issued by Google');
    };
}

subtest 'Verifier Basics' => sub {
    my $key1 = Google::Auth::IDTokens::KeyInfo->new({ id => 'k1', key => 'pub1', algorithm => 'RS256' });
    my $source = Google::Auth::IDTokens::KeySource::Static->new({ keys => [$key1] });
    
    my $verifier = Google::Auth::IDTokens::Verifier->new({
        key_source => $source,
        iss => 'https://accounts.google.com',
        aud => 'my-client-id',
    });
    
    my $payload;
    lives_ok { $payload = $verifier->verify('valid-token') } 'verifies valid token';
    is($payload->{sub}, '12345', 'payload content correct');
    
    throws_ok { $verifier->verify('invalid-token') } qr/Token not verified as issued by Google/, 'fails on invalid token';
    done_testing();
};

subtest 'Audience Mismatch' => sub {
    my $key1 = Google::Auth::IDTokens::KeyInfo->new({ id => 'k1', key => 'pub1', algorithm => 'RS256' });
    my $source = Google::Auth::IDTokens::KeySource::Static->new({ keys => [$key1] });
    
    my $verifier = Google::Auth::IDTokens::Verifier->new({
        key_source => $source,
        aud => 'wrong-client-id',
    });
    
    throws_ok { $verifier->verify('valid-token') } qr/Audience mismatch/, 'fails on aud mismatch';
    done_testing();
};

subtest 'Issuer Mismatch' => sub {
    my $key1 = Google::Auth::IDTokens::KeyInfo->new({ id => 'k1', key => 'pub1', algorithm => 'RS256' });
    my $source = Google::Auth::IDTokens::KeySource::Static->new({ keys => [$key1] });
    
    my $verifier = Google::Auth::IDTokens::Verifier->new({
        key_source => $source,
        iss => 'https://wrong.issuer.com',
    });
    
    throws_ok { $verifier->verify('valid-token') } qr/Issuer mismatch/, 'fails on iss mismatch';
    done_testing();
};

done_testing();

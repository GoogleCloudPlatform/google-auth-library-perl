use strict;
use warnings;
use Test::More;
use Log::Any::Test;
use Log::Any qw($log);
use Log::Any::Adapter;

Log::Any::Adapter->set('Test', min_level => 'trace');

use Google::Auth;
use Google::Auth::Credentials;
use Google::Auth::ServiceAccountCredentials;
use Google::Auth::ComputeEngineCredentials;
use Google::Auth::DefaultCredentials;
use JSON::XS;

subtest 'Credentials Base Class' => sub {
    my $creds = Google::Auth::Credentials->new(token => 'abc', expiry => time() + 3600);
    ok(!$creds->requires_refresh, "Does not require refresh if token is valid");
    $creds->expiry(time() - 10);
    ok($creds->requires_refresh, "Requires refresh if expired");
    
    my $headers = {};
    $creds->token('foo');
    $creds->apply($headers);
    is($headers->{Authorization}, "Bearer foo", "Apply adds Authorization header");
};

subtest 'Default Credentials (ADC)' => sub {
    # Mock environment variable
    local $ENV{GOOGLE_APPLICATION_CREDENTIALS} = 'nonexistent.json';
    my $creds = Google::Auth->default();
    isa_ok($creds, 'Google::Auth::ComputeEngineCredentials', "Fallbacks to GCE if file missing");
};

done_testing();

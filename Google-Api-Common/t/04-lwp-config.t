use strict;
use warnings;
use Test::More;

use Google::Cloud::Transport::Adapter::LWP;
use Google::Cloud::Transport::Configuration;

subtest 'Default User Agent' => sub {
    # Instantiate without user_agent to trigger builder
    my $adapter = Google::Cloud::Transport::Adapter::LWP->new();
    
    ok($adapter->user_agent, 'Default user agent built');
    isa_ok($adapter->user_agent, 'LWP::UserAgent', 'Correct class');
    
    # Test with custom configuration
    my $config = Google::Cloud::Transport::Configuration->new(
        timeout         => 10,
        ssl_verify_host => 0,
    );
    my $adapter2 = Google::Cloud::Transport::Adapter::LWP->new(configuration => $config);
    my $ua = $adapter2->user_agent;
    
    is($ua->timeout, 10, 'Timeout set from configuration');
    is($ua->ssl_opts('verify_hostname'), 0, 'SSL verify hostname set from configuration');
};

done_testing();

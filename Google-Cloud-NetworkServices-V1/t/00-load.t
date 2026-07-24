#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 2;

BEGIN {
    use_ok( 'Google::Cloud::NetworkServices::V1::DepServiceClient' ) || print "Bail out!\n";
    use_ok( 'Google::Cloud::NetworkServices::V1::NetworkServicesClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::NetworkServices::V1::DepServiceClient $Google::Cloud::NetworkServices::V1::DepServiceClient::VERSION, Perl $], $^X" );

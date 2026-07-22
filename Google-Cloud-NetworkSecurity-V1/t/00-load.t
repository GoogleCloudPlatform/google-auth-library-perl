#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::NetworkSecurity::V1::NetworkSecurityClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::NetworkSecurity::V1::NetworkSecurityClient $Google::Cloud::NetworkSecurity::V1::NetworkSecurityClient::VERSION, Perl $], $^X" );

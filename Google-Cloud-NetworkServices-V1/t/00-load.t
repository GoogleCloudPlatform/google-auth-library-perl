#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::NetworkServices::V1::NetworkServicesClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::NetworkServices::V1::NetworkServicesClient $Google::Cloud::NetworkServices::V1::NetworkServicesClient::VERSION, Perl $], $^X" );

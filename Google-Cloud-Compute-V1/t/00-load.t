#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::Compute::V1::InstancesClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::Compute::V1::InstancesClient $Google::Cloud::Compute::V1::InstancesClient::VERSION, Perl $], $^X" );

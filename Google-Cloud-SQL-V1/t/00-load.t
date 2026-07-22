#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::SQL::V1::SqlInstancesServiceClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::SQL::V1::SqlInstancesServiceClient $Google::Cloud::SQL::V1::SqlInstancesServiceClient::VERSION, Perl $], $^X" );

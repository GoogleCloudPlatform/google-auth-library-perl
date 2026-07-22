#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::IAM::V1::IAMPolicyClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::IAM::V1::IAMPolicyClient $Google::Cloud::IAM::V1::IAMPolicyClient::VERSION, Perl $], $^X" );

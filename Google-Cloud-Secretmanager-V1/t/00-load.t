#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::Secretmanager::V1::SecretManagerServiceClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::Secretmanager::V1::SecretManagerServiceClient $Google::Cloud::Secretmanager::V1::SecretManagerServiceClient::VERSION, Perl $], $^X" );

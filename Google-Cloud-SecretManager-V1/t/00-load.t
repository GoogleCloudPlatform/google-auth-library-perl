#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::SecretManager::V1::SecretManagerServiceClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::SecretManager::V1::SecretManagerServiceClient $Google::Cloud::SecretManager::V1::SecretManagerServiceClient::VERSION, Perl $], $^X" );

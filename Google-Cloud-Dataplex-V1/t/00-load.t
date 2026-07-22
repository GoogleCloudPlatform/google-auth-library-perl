#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::Dataplex::V1::DataplexServiceClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::Dataplex::V1::DataplexServiceClient $Google::Cloud::Dataplex::V1::DataplexServiceClient::VERSION, Perl $], $^X" );

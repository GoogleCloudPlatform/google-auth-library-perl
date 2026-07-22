#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::DataFusion::V1::DataFusionClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::DataFusion::V1::DataFusionClient $Google::Cloud::DataFusion::V1::DataFusionClient::VERSION, Perl $], $^X" );

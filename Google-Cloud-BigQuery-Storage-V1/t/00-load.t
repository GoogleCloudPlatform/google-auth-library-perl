#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::BigQuery::Storage::V1::BigQueryReadClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::BigQuery::Storage::V1::BigQueryReadClient $Google::Cloud::BigQuery::Storage::V1::BigQueryReadClient::VERSION, Perl $], $^X" );

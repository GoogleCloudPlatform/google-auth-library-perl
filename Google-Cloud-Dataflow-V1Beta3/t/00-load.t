#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client $Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client::VERSION, Perl $], $^X" );

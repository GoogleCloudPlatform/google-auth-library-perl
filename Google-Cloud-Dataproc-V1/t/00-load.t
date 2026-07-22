#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::Dataproc::V1::ClusterControllerClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::Dataproc::V1::ClusterControllerClient $Google::Cloud::Dataproc::V1::ClusterControllerClient::VERSION, Perl $], $^X" );

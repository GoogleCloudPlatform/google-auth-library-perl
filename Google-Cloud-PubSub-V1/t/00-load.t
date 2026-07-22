#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Google::Cloud::PubSub::V1::PublisherClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::PubSub::V1::PublisherClient $Google::Cloud::PubSub::V1::PublisherClient::VERSION, Perl $], $^X" );

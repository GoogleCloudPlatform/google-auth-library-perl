#!perl
use 5.008003;
use strict;
use warnings;
use Test::More;

plan tests => 6;

BEGIN {
    use_ok( 'Google::Cloud::Dataflow::V1Beta3::FlexTemplatesServiceClient' ) || print "Bail out!\n";
    use_ok( 'Google::Cloud::Dataflow::V1Beta3::JobsV1Beta3Client' ) || print "Bail out!\n";
    use_ok( 'Google::Cloud::Dataflow::V1Beta3::MessagesV1Beta3Client' ) || print "Bail out!\n";
    use_ok( 'Google::Cloud::Dataflow::V1Beta3::MetricsV1Beta3Client' ) || print "Bail out!\n";
    use_ok( 'Google::Cloud::Dataflow::V1Beta3::SnapshotsV1Beta3Client' ) || print "Bail out!\n";
    use_ok( 'Google::Cloud::Dataflow::V1Beta3::TemplatesServiceClient' ) || print "Bail out!\n";
}

diag( "Testing Google::Cloud::Dataflow::V1Beta3::FlexTemplatesServiceClient $Google::Cloud::Dataflow::V1Beta3::FlexTemplatesServiceClient::VERSION, Perl $], $^X" );

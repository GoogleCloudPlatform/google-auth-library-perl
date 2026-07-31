#!/usr/bin/env perl
use strict;
use warnings;


use blib;
require Google::Auth;
my $v = $Google::Auth::VERSION;
if (!defined $v || !length $v) {
    die "RELEASE LINT ERROR: VERSION not set in Google::Auth\n";
}

open my $fh, '<', 'Changes' or die "RELEASE LINT ERROR: Cannot read Changes: $!\n";
my $has_entry = 0;
while (<$fh>) {
    if (/^\Q$v\E\b/) {
        $has_entry = 1;
        last;
    }
}
close $fh;

if (!$has_entry) {
    die "RELEASE LINT ERROR: No Changes entry found for version $v in Changes file!\n";
}

print "RELEASE LINT PASS: Version $v verified in Changes.\n";
exit 0;

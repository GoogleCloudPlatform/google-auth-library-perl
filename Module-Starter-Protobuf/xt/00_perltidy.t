#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

unless ( $ENV{AUTHOR_TESTING} || $ENV{RELEASE_TESTING} ) {
    plan( skip_all => 'Author/Release tests not required for installation' );
}

eval 'use Test::PerlTidy';
plan( skip_all => 'Test::PerlTidy required for checking code formatting' ) if $@;

run_tests();

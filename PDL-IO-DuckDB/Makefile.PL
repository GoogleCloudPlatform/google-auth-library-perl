use 5.010;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use PDL::Core::Dev;

if (!-f '/usr/include/duckdb.h' && !-f '/usr/local/include/duckdb.h') {
    warn "libduckdb-dev (duckdb.h) is required to build PDL::IO::DuckDB.\n";
    exit 0;
}

my $pdl_inc = PDL::Core::Dev::PDL_INCLUDE();
$pdl_inc =~ s/^"|"$//g;

WriteMakefile(
    NAME               => 'PDL::IO::DuckDB',
    AUTHOR             => q{C.J. Collier <cjac@google.com>},
    VERSION_FROM       => 'lib/PDL/IO/DuckDB.pm',
    ABSTRACT_FROM      => 'lib/PDL/IO/DuckDB.pm',
    LICENSE            => 'apache_2_0',
    MIN_PERL_VERSION   => '5.010',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
        'PDL'                 => '2.080',
    },
    TEST_REQUIRES => {
        'Test::More' => '0.88',
    },
    PREREQ_PM => {
        'PDL' => '2.080',
    },
    INC   => "-I. $pdl_inc",
    XSMULTI => 1,
    LIBS  => ['-lduckdb'],
    clean => { FILES => 'PDL-IO-DuckDB-* *.o DuckDB.bs DuckDB.c' },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources   => {
            repository => {
                type => 'git',
                url  => 'https://github.com/GoogleCloudPlatform/google-auth-library-perl.git',
                web  => 'https://github.com/GoogleCloudPlatform/google-auth-library-perl',
            },
            bugtracker => {
                web => 'https://github.com/GoogleCloudPlatform/google-auth-library-perl/issues',
            },
        },
    },
);

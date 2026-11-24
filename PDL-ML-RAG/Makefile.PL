use 5.010;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'PDL::ML::RAG',
    AUTHOR             => q{C.J. Collier <cjac@google.com>},
    VERSION_FROM       => 'lib/PDL/ML/RAG.pm',
    ABSTRACT_FROM      => 'lib/PDL/ML/RAG.pm',
    LICENSE            => 'apache_2_0',
    MIN_PERL_VERSION   => '5.010',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
    },
    TEST_REQUIRES => {
        'Test::More' => '0.88',
    },
    PREREQ_PM => {
        'PDL' => '2.080',
    },
    clean => { FILES => 'PDL-ML-RAG-*' },
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

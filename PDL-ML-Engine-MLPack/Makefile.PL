use 5.010;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use PDL::Core::Dev;

if (!-f '/usr/include/mlpack.hpp' && !-f '/usr/local/include/mlpack.hpp') {
    warn "libmlpack-dev (mlpack.hpp) is required to build PDL::ML::Engine::MLPack.\n";
    exit 0;
}

my $pdl_inc = PDL::Core::Dev::PDL_INCLUDE();
$pdl_inc =~ s/^"|"$//g;

use ExtUtils::CppGuess;
my $guess        = ExtUtils::CppGuess->new();
my %cpp_opts     = $guess->makemaker_options();
my $cpp_compiler = $guess->compiler_command() || 'g++';
my $cpp_libs     = $guess->linker_flags()     || '-lstdc++';
my $cpp_flags    = ($cpp_opts{CCFLAGS} || '') . ' -std=c++17';

WriteMakefile(
    NAME               => 'PDL::ML::Engine::MLPack',
    AUTHOR             => q{C.J. Collier <cjac@google.com>},
    VERSION_FROM       => 'lib/PDL/ML/Engine/MLPack.pm',
    ABSTRACT_FROM      => 'lib/PDL/ML/Engine/MLPack.pm',
    LICENSE            => 'apache_2_0',
    MIN_PERL_VERSION   => '5.010',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
        'ExtUtils::CppGuess'  => '0.26',
        'PDL'                 => '2.080',
    },
    TEST_REQUIRES => {
        'Test::More' => '0.88',
    },
    PREREQ_PM => {
        'PDL' => '2.080',
    },
    INC    => "-I. $pdl_inc",
    LIBS   => ["-larmadillo -lblas -llapack $cpp_libs"],
    OBJECT => 'MLPack$(OBJ_EXT) mlpack_bridge$(OBJ_EXT)',
    XS     => { 'MLPack.xs' => 'MLPack.c' },
    clean  => { FILES => 'PDL-ML-Engine-MLPack-* *.o MLPack.bs MLPack.c' },
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

package MY;

sub postamble {
    return <<"END_MAKE";
CXX = $cpp_compiler
CXXFLAGS = $cpp_flags -O2 -fPIC

mlpack_bridge\$(OBJ_EXT): mlpack_bridge.cc mlpack_bridge.h
\t\$(CXX) \$(CXXFLAGS) -I. -c mlpack_bridge.cc -o mlpack_bridge\$(OBJ_EXT)
END_MAKE
}

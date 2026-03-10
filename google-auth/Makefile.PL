# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use Config;

my @XS_HELPER_C_FILES = glob('xs/*.c');
my @XS_HELPER_O_FILES = map { my $o = $_; $o =~ s/\.c$/$Config{obj_ext}/; $o } @XS_HELPER_C_FILES;
my $XS_HELPER_O_STRING = join(' ', @XS_HELPER_O_FILES);

WriteMakefile(
    NAME             => 'Google::Auth',
    AUTHOR           => q{C.J. Collier <CJCOLLIER@CPAN.ORG>},
    VERSION_FROM     => 'lib/Google/Auth.pm',
    ABSTRACT         => 'Google Auth Library for Perl',
    LICENSE          => 'apache_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => '5.006',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
    },
    PREREQ_PM => {
        'Moo'                => 0,
        'Crypt::PK::ECC'     => 0,
        'Crypt::PK::RSA'     => 0,
        'Crypt::JWT'         => 0,
        'JSON::XS'           => 0,
        'JSON::PP'           => 0,
        'LWP::UserAgent'     => 0,
        'LWP::Protocol::https' => 0,
        'URI'                => 0,
        'Throwable::Error'   => 0,
        'Log::Any'           => 0,
    },
    TEST_REQUIRES => {
        'Test::More'         => 0,
        'Test::Deep'         => 0,
        'Test::Exception'    => 0,
        'Test::LWP::UserAgent' => 0,
        'Log::Any::Test'     => 0,
        'Log::Any::Adapter'  => 0,
    },
    XSMULTI          => 1,
    LIBS             => ['-lcrypto'],
    INC              => '-I. -Ixs',
    MYEXTLIB         => $XS_HELPER_O_STRING,
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => "Google-Auth-Library-Perl-* @XS_HELPER_O_FILES" },
);

package MY;

sub postamble {
    my $make_frag = '';
    foreach my $o_file (@XS_HELPER_O_FILES) {
        my $c_file = $o_file;
        $c_file =~ s/\.o$/.c/;
        $make_frag .= "$o_file: $c_file\n";
        $make_frag .= "\t\$(CCCMD) \$(CCCDLFLAGS) \"-I\$(PERL_INC)\" \$(PASTHRU_DEFINE) \$(DEFINE) $c_file -o $o_file\n\n";
    }
    return $make_frag;
}

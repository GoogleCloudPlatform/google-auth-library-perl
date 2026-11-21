use 5.008003;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Spec;

my %WriteMakefileArgs = (
    NAME             => 'Google::Api::Common',
    AUTHOR           => ['Google LLC'],
    VERSION_FROM     => 'lib/Google/Api/Common.pm',
    ABSTRACT_FROM    => 'lib/Google/Api/Common.pm',
    LICENSE          => 'apache_2',
    MIN_PERL_VERSION => '5.008003',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
    },
    TEST_REQUIRES => {
        'Test::More' => '0',
    },
    PREREQ_PM => {
        'Protobuf'       => '0.01',
        'Moo'            => '0',
        'Future'         => '0',
        'LWP::UserAgent' => '0',
        'JSON::MaybeXS'  => '0',
        'HTTP::Request'  => '0',
        'Log::Any'       => '0',
    },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        prereqs => {
            runtime => {
                recommends => {
                    'AnyEvent'            => '0',
                    'Net::HTTP2::nghttp2' => '0',
                    'Net::Curl'           => '0',
                },
            },
        },
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Google-Api-Common-* pm_to_blib_protos.stamp' },
);

package MY;
sub postamble {
    my $g3_candidate = File::Spec->rel2abs(File::Spec->catdir('..', '..', '..', '..'));
    my $default_proto_root = (-f File::Spec->catfile($g3_candidate, 'google', 'api', 'annotations.proto'))
        ? $g3_candidate
        : '';
    return <<"MAKE_FRAG";
PROTO_ROOT ?= $default_proto_root
PROTOC ?= protoc

pure_all :: pm_to_blib_protos.stamp

pm_to_blib_protos.stamp : pm_to_blib
\t\@if [ -n "\$(PROTO_ROOT)" ] && [ -d "\$(PROTO_ROOT)/google/api" ] && command -v protoc-gen-perl-pb >/dev/null 2>&1; then \\
\t\techo "Auto-generating google/{api,longrunning,rpc,type} Perl modules into \$(INST_LIB)..."; \\
\t\t\$(PROTOC) --proto_path="\$(PROTO_ROOT)" --perl-pb_out="\$(INST_LIB)" \\
\t\t\t"\$(PROTO_ROOT)"/google/api/*.proto \\
\t\t\t"\$(PROTO_ROOT)"/google/longrunning/operations.proto \\
\t\t\t"\$(PROTO_ROOT)"/google/rpc/status.proto \\
\t\t\t"\$(PROTO_ROOT)"/google/type/*.proto; \\
\tfi
\t\@\$(TOUCH) pm_to_blib_protos.stamp
MAKE_FRAG
}
package main;

WriteMakefile(%WriteMakefileArgs);

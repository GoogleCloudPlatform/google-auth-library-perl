#!/usr/bin/env perl
use 5.006;
use strict;
use warnings;
use Config;
use File::Basename qw(dirname);
use File::Spec;
use File::Find qw(find);
use File::Path qw(rmtree);

my $sep = $^O eq 'MSWin32' ? ';' : ':';
if ($^O eq 'MSWin32') {
    my $perl_dir = dirname($^X);
    my $c_bin = File::Spec->catdir(dirname($perl_dir), "c", "bin");
    my @path_parts = split(/;/, $ENV{PATH} || '');
    @path_parts = grep { $_ !~ /msys/i && $_ !~ /Git\\usr\\bin/i } @path_parts;
    $ENV{PATH} = join(';', $perl_dir, $c_bin, @path_parts);
} else {
    my $perl_dir = dirname($^X);
    $ENV{PATH} = join(':', $perl_dir, $ENV{PATH} || '');
}
$ENV{PACKAGE_STASH_IMPLEMENTATION} = "PP";
$ENV{MOO_XS_DISABLE} = "1";
$ENV{TEMPLATE_STASH} = "pureperl";
eval { require Template::Config; $Template::Config::STASH = "Template::Stash"; };

my $make = $Config{make} || "make";

if ($^O eq 'MSWin32') {
    $ENV{PERL_CPANM_OPT} = "--prefer-source";
    for my $lib_dir (@INC) {
        for my $pkg (qw(Package/Stash/XS Clone Params/Util List/MoreUtils/XS Protobuf Auth)) {
            my $xs_dir = File::Spec->catdir($lib_dir, "auto", split(/\//, $pkg));
            if (-d $xs_dir) {
                eval { rmtree($xs_dir); };
            }
        }
    }
}

my $root_dir = File::Spec->rel2abs(".");
my $home_dir = $ENV{HOME} || $ENV{USERPROFILE} || $root_dir;
my $local_dir = File::Spec->catdir($home_dir, "perl5");
eval {
    require local::lib;
    local::lib->import($local_dir);
};

my @dirs = @ARGV ? @ARGV : qw(
    Protobuf Google-Auth Google-Api-Common Google-gRPC Module-Starter-Protobuf
    Google-Cloud-BigQuery-Storage-V1 Google-Cloud-Bigquery-V2 Google-Cloud-Build-V1
    Google-Cloud-Composer-V1 Google-Cloud-Compute-V1 Google-Cloud-Dataflow-V1Beta3
    Google-Cloud-DataFusion-V1 Google-Cloud-Dataplex-V1 Google-Cloud-Dataproc-V1
    Google-Cloud-IAM-V1 Google-Cloud-Metastore-V1 Google-Cloud-NetworkSecurity-V1
    Google-Cloud-NetworkServices-V1 Google-Cloud-PrivateCA-V1 Google-Cloud-PubSub-V1
    Google-Cloud-SecretManager-V1 Google-Cloud-Spanner-V1 Google-Cloud-SQL-V1
    Google-Cloud-Storage-V2
);
for my $d (@dirs) {
    chdir $root_dir or die "Cannot chdir to $root_dir: $!";
    build_package($d);
}

sub build_package {
    my ($d) = @_;
    print "=== Building $d ===\n";
    chdir $d or die "Cannot chdir to $d: $!";
    if (-f "Makefile") {
        eval { system("$make clean"); };
        unlink "Makefile";
    }
    unlink "MYMETA.yml", "MYMETA.json", "pm_to_blib";
    eval { rmtree("blib"); };
    eval { rmtree("_inline"); };
    find(sub { unlink $_ if /\.(o|obj|so|dll|def|bs|a|lib|csc|xsc)$/i || $_ eq "Protobuf.c" || $_ eq "Auth.c" || $_ eq "XS.c" }, ".");
    my $top_dir = File::Spec->rel2abs("..");
    find(sub { unlink $_ if /\.(so|dll)$/i }, $top_dir);

    unless ($ENV{CI_SKIP_DEPS}) {
        my @cpanm_cmd = ($^O eq 'MSWin32') ? ($^X, '-S', 'cpanm') : ('cpanm');
        system(@cpanm_cmd, '--notest', '--installdeps', '.');
    }
    system("$^X Makefile.PL") == 0 or die "Makefile.PL failed in $d";
    system("$make") == 0 or die "$make failed in $d";

    my %seen;
    my @dll_dirs;
    for my $dir (map { File::Spec->catdir($_, "auto") } @INC) {
        if (-d $dir && !$seen{$dir}++) {
            my $canon = File::Spec->canonpath(File::Spec->rel2abs($dir));
            $canon =~ s/\//\\/g if $^O eq 'MSWin32';
            push @dll_dirs, $canon;
        }
    }

    my $abs_arch = File::Spec->rel2abs("blib/arch/auto");
    my $abs_cur = File::Spec->rel2abs(".");
    $abs_arch =~ s/\//\\/g if $^O eq "MSWin32";
    $abs_cur =~ s/\//\\/g if $^O eq "MSWin32";

    my $old_path = $ENV{PATH};
    $ENV{PATH} = join($sep, $abs_arch, $abs_cur, @dll_dirs, $old_path);
    my $top_abs = File::Spec->rel2abs($top_dir);
    my @libs = (
        File::Spec->rel2abs('blib/lib'),
        File::Spec->rel2abs('blib/arch'),
        File::Spec->rel2abs('t/lib'),
        File::Spec->catdir($top_abs, 'local', 'lib', 'perl5'),
        File::Spec->catdir($top_abs, 'local', 'lib', 'perl5', $Config{archname}),
        File::Spec->catdir($top_abs, 'Protobuf', 'blib', 'lib'),
        File::Spec->catdir($top_abs, 'Protobuf', 'blib', 'arch'),
        File::Spec->catdir($top_abs, 'Google-Auth', 'blib', 'lib'),
        File::Spec->catdir($top_abs, 'Google-Auth', 'blib', 'arch'),
        File::Spec->catdir($top_abs, 'Google-gRPC', 'blib', 'lib'),
        File::Spec->catdir($top_abs, 'Google-gRPC', 'blib', 'arch'),
        File::Spec->catdir($top_abs, 'Google-Api-Common', 'blib', 'lib'),
        File::Spec->catdir($top_abs, 'Google-Api-Common', 'blib', 'arch'),
        File::Spec->catdir($top_abs, 'Module-Starter-Protobuf', 'blib', 'lib'),
        File::Spec->catdir($top_abs, 'Module-Starter-Protobuf', 'blib', 'arch'),
        File::Spec->rel2abs('local/lib/perl5'),
        File::Spec->rel2abs('../local/lib/perl5')
    );
    if ($^O eq 'MSWin32') {
        s{\\}{/}g for @libs;
    }
    local $ENV{PERL5LIB} = join($sep, @libs, $ENV{PERL5LIB} || ());
    my $res = system($^X, '-S', 'prove', '-b', '-It/lib', 't/');
    $ENV{PATH} = $old_path;
    die "prove failed in $d with exit code $res" if $res != 0;

    system("$make install") == 0 or die "$make install failed in $d";
    chdir ".." or die "Cannot chdir to ..: $!";
}

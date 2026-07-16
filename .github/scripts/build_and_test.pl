#!/usr/bin/env perl
use 5.006;
use strict;
use warnings;
use Config;
use File::Basename qw(dirname);
use File::Spec;
use File::Find qw(find);
use File::Path qw(rmtree);

my $perl_dir = dirname($^X);
my $c_bin = File::Spec->catdir(dirname($perl_dir), "c", "bin");
my $sep = $^O eq 'MSWin32' ? ';' : ':';
$ENV{PATH} = join($sep, $perl_dir, $c_bin, $ENV{PATH});
$ENV{PACKAGE_STASH_IMPLEMENTATION} = "PP";
$ENV{MOO_XS_DISABLE} = "1";
$ENV{TEMPLATE_STASH} = "pureperl";
eval { require Template::Config; $Template::Config::STASH = "Template::Stash"; };

my $make = $Config{make} || "make";

# Remove any pre-installed Package::Stash::XS DLLs that cause Perl ABI handshake key mismatch
for my $lib_dir (@INC) {
    my $xs_dir = File::Spec->catdir($lib_dir, "auto", "Package", "Stash", "XS");
    if (-d $xs_dir) {
        eval { rmtree($xs_dir); };
    }
}

my @dirs = @ARGV ? @ARGV : qw(Protobuf Google-Auth Google-Api-Common Google-gRPC Module-Starter-Protobuf);
for my $d (@dirs) {
    print "=== Building $d ===\n";
    chdir $d or die "Cannot chdir to $d: $!";
    system("$make distclean") if -f "Makefile";
    find(sub { unlink $_ if /\.(o|obj|so|dll|def|bs|a|lib|csc|xsc)$/i || $_ eq "Protobuf.c" || $_ eq "Auth.c" || $_ eq "XS.c" }, ".");
    eval { rmtree("blib"); };
    system("$^X Makefile.PL") == 0 or die "Makefile.PL failed in $d";
    system("$make") == 0 or die "$make failed in $d";

    my $top_dir = File::Spec->rel2abs("..");
    my %seen;
    my @dll_dirs;
    my @search_dirs = ($top_dir);
    for my $inc (@INC) {
        my $auto = File::Spec->catdir($inc, "auto");
        push @search_dirs, $auto if -d $auto;
    }
    File::Find::find({
        wanted => sub {
            if (-f $_ && /\.(?:dll|so|dylib)$/i) {
                my $dir = File::Spec->rel2abs($File::Find::dir);
                $dir = File::Spec->canonpath($dir);
                if (!$seen{$dir}++) {
                    $dir =~ s/\//\\/g if $^O eq 'MSWin32';
                    push @dll_dirs, $dir;
                }
            }
        },
        no_chdir => 1
    }, @search_dirs);

    my $abs_arch = File::Spec->rel2abs("blib/arch/auto");
    my $abs_cur = File::Spec->rel2abs(".");
    $abs_arch =~ s/\//\\/g if $^O eq "MSWin32";
    $abs_cur =~ s/\//\\/g if $^O eq "MSWin32";

    my $old_path = $ENV{PATH};
    $ENV{PATH} = join($sep, $abs_arch, $abs_cur, @dll_dirs, $old_path);
    my $res;
    if ($^O eq 'MSWin32') {
        local $ENV{PERL5LIB} = join($sep, File::Spec->rel2abs('blib/lib'), File::Spec->rel2abs('blib/arch'), File::Spec->rel2abs('t/lib'), $ENV{PERL5LIB} || ());
        my $perl_bin = $^X;
        $perl_bin =~ s{\\}{/}g;
        $res = system($^X, '-S', 'prove', '--exec', $perl_bin, '-b', 't/');
    } else {
        $res = system("$^X -S prove -b -It/lib t/");
    }
    $ENV{PATH} = $old_path;
    die "prove failed in $d with exit code $res" if $res != 0;

    system("$make install") == 0 or die "$make install failed in $d";
    chdir ".." or die "Cannot chdir to ..: $!";
}

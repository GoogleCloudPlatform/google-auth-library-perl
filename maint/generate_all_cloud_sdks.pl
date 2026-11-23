#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename qw(basename);
use File::Find     qw(find);
use File::Path     qw(make_path remove_tree);
use File::Copy     qw(move);
use Getopt::Long   qw(GetOptions);
use POSIX          qw(:sys_wait_h);

my $proto_root = '/tmp/googleapis';
my $dest_dir   = '/usr/local/google/home/cjac/notes/cjac-promo-2026/cpan-release-tarballs/2026-11-22/generated';
my $version    = '0.06';
my $jobs       = 6;
my $author     = 'C.J. Collier <cjac@google.com>';
my $sec_link   = 'https://bughunters.google.com/';
my $filter     = '';
my $keep_dirs  = 0;
my $resume     = 0;

GetOptions(
    'proto-root=s' => \$proto_root,
    'dest=s'       => \$dest_dir,
    'version=s'    => \$version,
    'jobs=i'       => \$jobs,
    'author=s'     => \$author,
    'filter=s'     => \$filter,
    'keep-dirs!'   => \$keep_dirs,
    'resume!'      => \$resume,
) or die "Usage: perl maint/generate_all_cloud_sdks.pl [--proto-root=DIR] [--dest=DIR] [--version=0.01] [--jobs=6] [--filter=REGEX] [--resume]\n";

if (!-d $proto_root . '/google/spanner/v1') {
    system('git', 'clone', '--depth', '1', 'https://github.com/googleapis/googleapis.git', $proto_root) == 0
        or die 'Failed to clone googleapis into ' . $proto_root;
}

make_path($dest_dir);
my $work_root  = $dest_dir . '/_build_sdks';
my $log_dir    = $dest_dir . '/_build_logs';
my $staged_lib = $dest_dir . '/_staged_lib';
make_path($work_root, $log_dir, $staged_lib);

my $nproc = `nproc 2>/dev/null`;
chomp($nproc) if defined $nproc;
$nproc = ($nproc && $nproc =~ /^\d+$/) ? $nproc : 4;

my $google_root = $proto_root . '/google';
my %products;

my %shared_wave0_dirs = map { $_ => 1 } (
    'logging/type',
    'cloud/common',
    'cloud/oslogin/common',
    'identity/accesscontextmanager/type',
    'identity/accesscontextmanager/v1',
    'apps/script/type',
    'apps/script/type/calendar',
    'apps/script/type/docs',
    'apps/script/type/drive',
    'apps/script/type/gmail',
    'apps/script/type/sheets',
    'apps/script/type/slides',
);

sub prod_from_rel {
    my ($rel) = @_;
    my @parts = split m{/}, $rel;
    pop @parts;
    return unless @parts;

    my $full_dir = join('/', @parts);
    return $full_dir if $shared_wave0_dirs{$full_dir};

    return if $parts[0] =~ /\A(?:api|rpc|type|longrunning|protobuf|bytestream|geo|maps|ads|shopping|chrome|marketingplatform|analytics|apps|area120|chat|example|home|identity|streetview)\z/;

    # Group by versioned API directory (e.g. cloud/spanner/v1, iam/v2beta, ai/generativelanguage/v1beta)
    for (my $i = $#parts; $i >= 0; $i--) {
        if ($parts[$i] =~ /\Av\d+(?:(?:alpha|beta|p)\d*)?\z/) {
            return join('/', @parts[0 .. $i]);
        }
    }
    return;
}

find(
    {
        no_chdir => 1,
        wanted   => sub {
            return unless -f $_ && /\.proto\z/;
            (my $rel = $_) =~ s{\A\Q$google_root\E/}{};
            my $prod = prod_from_rel($rel);
            return unless defined $prod;
            push @{ $products{$prod} }, $_;
        },
    },
    $google_root
);

for my $extra_root ('grafeas/v1', 'backstory') {
    my $dir = $proto_root . '/' . $extra_root;
    if (-d $dir) {
        find(
            {
                no_chdir => 1,
                wanted   => sub {
                    return unless -f $_ && /\.proto\z/;
                    push @{ $products{$extra_root} }, $_;
                },
            },
            $dir
        );
    }
}

sub to_camel {
    my ($s) = @_;
    return join('', map { ucfirst(lc($_)) } split /[^a-zA-Z0-9]+/, $s);
}

sub prod_to_mod_dist {
    my ($prod) = @_;
    my @parts = split m{/}, $prod;
    my @ns;
    if ($parts[0] eq 'cloud') {
        shift @parts;
        @ns = ('Google', 'Cloud', map { to_camel($_) } @parts);
    } elsif ($parts[0] eq 'ai') {
        shift @parts;
        @ns = ('Google', 'Ai', map { to_camel($_) } @parts);
    } elsif ($parts[0] eq 'grafeas' || $parts[0] eq 'backstory') {
        @ns = map { to_camel($_) } @parts;
    } else {
        @ns = ('Google', 'Cloud', map { to_camel($_) } @parts);
    }
    my $mod  = join('::', @ns);
    my $dist = join('-',  @ns);
    return ($mod, $dist);
}

sub detect_default_host {
    my ($protos) = @_;
    for my $p (@$protos) {
        open my $fh, '<:encoding(UTF-8)', $p or next;
        while (<$fh>) {
            if (/option\s+\(google\.api\.default_host\)\s*=\s*"([^"]+)"/) {
                my $host = $1;
                close $fh;
                return $host =~ /:\d+\z/ ? $host : $host . ':443';
            }
        }
        close $fh;
    }
    return;
}

# Build inter-product dependency graph from .proto imports
my %deps;
for my $prod (keys %products) {
    $deps{$prod} = {};
    for my $p (@{ $products{$prod} }) {
        open my $fh, '<:encoding(UTF-8)', $p or next;
        while (<$fh>) {
            if (/^\s*import\s+(?:public\s+)?"(google\/[^"]+|grafeas\/v1\/[^"]+|backstory\/[^"]+)";/) {
                my $imp = $1;
                my $imp_prod = ($imp =~ m{\Agrafeas/v1/}) ? 'grafeas/v1'
                             : ($imp =~ m{\Abackstory/})   ? 'backstory'
                             : do { (my $r = $imp) =~ s{\Agoogle/}{}; prod_from_rel($r) };
                if (defined $imp_prod && $imp_prod ne $prod && exists $products{$imp_prod}) {
                    $deps{$prod}{$imp_prod} = 1;
                }
            }
        }
        close $fh;
    }
}

# Topological sort into waves
my %remaining = map { $_ => 1 } keys %products;
if (length $filter) {
    %remaining = map { $_ => 1 } grep { /$filter/i } keys %remaining;
}
my @waves;
while (%remaining) {
    my @wave = sort grep {
        my $p = $_;
        !grep { $remaining{$_} } keys %{ $deps{$p} };
    } keys %remaining;

    if (!@wave) {
        # Break any cycles by running remaining products in a final wave
        @wave = sort keys %remaining;
    }
    push @waves, \@wave;
    delete $remaining{$_} for @wave;
}

print 'Discovered ' . scalar(keys %products) . ' Google Cloud products across ' . scalar(@waves) . " dependency waves (jobs=$jobs, nproc=$nproc)\n";

# Prepend staged lib to PERL5LIB for all child processes
$ENV{PERL5LIB} = defined $ENV{PERL5LIB} && length $ENV{PERL5LIB}
    ? $staged_lib . ':' . $ENV{PERL5LIB}
    : $staged_lib;

my @all_results;

for my $w_idx (0 .. $#waves) {
    my @wave = @{ $waves[$w_idx] };
    print '=== Wave ' . ($w_idx + 1) . '/' . scalar(@waves) . ' (' . scalar(@wave) . " products) ===\n";

    my %running;
    my $launch_one = sub {
        my ($prod) = @_;
        my @protos = sort @{ $products{$prod} };
        my ($mod, $dist) = prod_to_mod_dist($prod);
        my $expected_tar = $dest_dir . '/' . $dist . '-' . $version . '.tar.gz';

        # If --resume and tarball already exists, stage its lib/ and skip rebuild
        if ($resume && -f $expected_tar) {
            my $tmp_ext = $work_root . '/_ext_' . $dist;
            remove_tree($tmp_ext) if -d $tmp_ext;
            make_path($tmp_ext);
            system('tar', '-xzf', $expected_tar, '-C', $tmp_ext);
            my ($top) = glob($tmp_ext . '/*');
            if ($top && -d $top . '/lib') {
                system('cp', '-a', $top . '/lib/.', $staged_lib . '/');
            }
            remove_tree($tmp_ext);
            push @all_results, { prod => $prod, dist => $dist, mod => $mod, protos => scalar(@protos), log => $log_dir . '/' . $dist . '.log', ok => 1 };
            return;
        }

        my $target = detect_default_host(\@protos);
        if (!$target) {
            (my $short = $prod) =~ s{\Acloud/}{};
            $target = $short . '.googleapis.com:443';
        }

        my $dir = $work_root . '/' . $dist;
        my $log = $log_dir . '/' . $dist . '.log';

        my $pid = fork();
        die 'fork failed: ' . $! unless defined $pid;

        if ($pid == 0) {
            open STDOUT, '>', $log or die $!;
            open STDERR, '>&', \*STDOUT or die $!;

            remove_tree($dir) if -d $dir;
            my $rc = system(
                'protobuf-starter',
                '--module=' . $mod,
                '--protos=' . join(',', @protos),
                '--import-path=' . $proto_root,
                '--grpc-target=' . $target,
                '--dir=' . $dir,
                '--module-version=' . $version,
                '--license=apache_2_0',
                '--security-link=' . $sec_link,
                '--author=' . $author,
                '--force',
            );
            if ($rc != 0) {
                print "FAILED: protobuf-starter exited $rc\n";
                exit 1;
            }

            chdir $dir or do { print "FAILED: chdir $dir: $!\n"; exit 1; };
            for my $cmd (
                ['perl', 'Makefile.PL'],
                ['make', '-j' . $nproc],
                ['prove', '-b', '-j' . $nproc, 't/'],
                ['make', 'dist'],
            ) {
                my $crc = system(@$cmd);
                if ($crc != 0) {
                    print 'FAILED: ' . join(' ', @$cmd) . " exited $crc\n";
                    exit 1;
                }
            }

            # Stage compiled blib/lib for downstream waves
            if (-d 'blib/lib') {
                system('cp', '-a', 'blib/lib/.', $staged_lib . '/');
            }

            my @tars = glob('*.tar.gz');
            if (!@tars) {
                print "FAILED: no .tar.gz produced\n";
                exit 1;
            }
            for my $t (@tars) {
                move($t, $dest_dir . '/' . basename($t)) or do {
                    print "FAILED: move $t: $!\n";
                    exit 1;
                };
            }
            chdir '/';
            remove_tree($dir) unless $keep_dirs;
            exit 0;
        }

        $running{$pid} = { prod => $prod, dist => $dist, mod => $mod, protos => scalar(@protos), log => $log };
    };

    my $reap_one = sub {
        my $pid = waitpid(-1, 0);
        return if $pid <= 0;
        my $status = $?;
        my $info   = delete $running{$pid};
        $info->{ok} = ($status == 0) ? 1 : 0;
        push @all_results, $info;
    };

    for my $prod (@wave) {
        while (scalar(keys %running) >= $jobs) {
            $reap_one->();
        }
        $launch_one->($prod);
    }
    while (keys %running) {
        $reap_one->();
    }
}

@all_results = sort { $a->{dist} cmp $b->{dist} } @all_results;
my @pass = grep { $_->{ok} } @all_results;
my @fail = grep { !$_->{ok} } @all_results;

my $summary_file = $dest_dir . '/sdk-generation-summary.txt';
open my $sfh, '>:encoding(UTF-8)', $summary_file or die $!;
print {$sfh} 'Total=' . scalar(@all_results) . ' PASS=' . scalar(@pass) . ' FAIL=' . scalar(@fail) . "\n\n";
if (@fail) {
    print {$sfh} "=== FAILURES ===\n";
    for my $f (@fail) {
        print {$sfh} $f->{dist} . ' (' . $f->{prod} . ', ' . $f->{protos} . ' protos) -> ' . $f->{log} . "\n";
    }
    print {$sfh} "\n";
}
print {$sfh} "=== PASSED ===\n";
for my $p (@pass) {
    print {$sfh} $p->{dist} . ' (' . $p->{prod} . ', ' . $p->{protos} . " protos)\n";
}
close $sfh;

remove_tree($work_root) if !$keep_dirs && -d $work_root;

print 'SDK generation complete! Total=' . scalar(@all_results)
    . ' PASS=' . scalar(@pass)
    . ' FAIL=' . scalar(@fail)
    . ' (summary: ' . $summary_file . ")\n";

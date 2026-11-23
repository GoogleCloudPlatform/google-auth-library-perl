#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename qw(dirname);
use File::Find     qw(find);
use File::Path     qw(make_path);
use File::Spec;

my $root = $ARGV[0] || $ENV{GALP_RENDERED_DIR} || 'tmp/rendered';
my $out  = $ARGV[1] || 'tmp/audit_rendered_docs.out';
die 'Rendered docs directory not found: ' . $root unless -d $root;

my @html_files;
find(
    {
        no_chdir => 1,
        wanted   => sub {
            return unless -f $_ && /\.html\z/;
            push @html_files, $_;
        },
    },
    $root
);
@html_files = sort @html_files;

my (@broken_links, @missing_local_pod, @empty_or_stub, @dup_name, @markdown_leaks);

for my $file (@html_files) {
    open my $fh, '<:encoding(UTF-8)', $file or die 'Cannot read ' . $file . ': ' . $!;
    local $/;
    my $html = <$fh>;
    close $fh;

    (my $rel = $file) =~ s{\A\Q$root\E/}{};
    my $dir = dirname($file);

    while ($html =~ /href="([^"]+)"/g) {
        my $href = $1;
        next if $href =~ /\A(?:#|https?:|mailto:)/;
        (my $target = $href) =~ s/#.*\z//;
        next unless length $target;
        my $full = File::Spec->rel2abs($target, $dir);
        if (!-f $full) {
            push @broken_links, $rel . ' -> ' . $href;
        }
    }

    while ($html =~ m{href="https://metacpan\.org/pod/([^"#]+)}g) {
        my $mod = $1;
        if ($mod =~ /\A(?:Google::(?:Auth|Api|Cloud|gRPC|Protobuf|Longrunning|Rpc|Type)|Protobuf|Module::Starter::Protobuf)(?:::|\z)/) {
            push @missing_local_pod, $rel . ' -> ' . $mod;
        }
    }

    next if $rel eq 'index.html';

    my @names = ($html =~ m{<h1[^>]*>NAME</h1>}gi);
    if (@names > 1) {
        push @dup_name, $rel . ' (' . scalar(@names) . ' NAME headings)';
    }

    if ($html =~ /Quick summary of what the module does|Perhaps a little code snippet|==\s+(?:Class|Instance)\s+Methods|\*\*[A-Za-z][^*]{1,40}\*\*/) {
        push @markdown_leaks, $rel;
    }

    (my $body = $html) =~ s{.*?</style></head><body>}{}s;
    $body =~ s{<[^>]+>}{ }g;
    $body =~ s{\s+}{ }g;
    if (length($body) < 180) {
        push @empty_or_stub, $rel . ' (' . length($body) . ' chars)';
    }
}

make_path(dirname($out));
open my $ofh, '>:encoding(UTF-8)', $out or die 'Cannot write ' . $out . ': ' . $!;
print {$ofh} 'Audited ' . scalar(@html_files) . " HTML files\n\n";
print {$ofh} '=== BROKEN RELATIVE LINKS (' . scalar(@broken_links) . ") ===\n";
print {$ofh} join("\n", @broken_links) . "\n\n" if @broken_links;

my %uniq_missing;
@uniq_missing{@missing_local_pod} = ();
my @missing_sorted = sort keys %uniq_missing;
print {$ofh} '=== OWN-NAMESPACE METACPAN LINKS / MISSING LOCAL POD (' . scalar(@missing_sorted) . ") ===\n";
print {$ofh} join("\n", @missing_sorted) . "\n\n" if @missing_sorted;

print {$ofh} '=== DUPLICATE NAME HEADINGS (' . scalar(@dup_name) . ") ===\n";
print {$ofh} join("\n", @dup_name) . "\n\n" if @dup_name;

print {$ofh} '=== MARKDOWN / BOILERPLATE LEAKS (' . scalar(@markdown_leaks) . ") ===\n";
print {$ofh} join("\n", @markdown_leaks) . "\n\n" if @markdown_leaks;

print {$ofh} '=== EMPTY OR STUB PAGES <180 CHARS (' . scalar(@empty_or_stub) . ") ===\n";
print {$ofh} join("\n", @empty_or_stub) . "\n\n" if @empty_or_stub;
close $ofh;

print 'Audit complete! Files=' . scalar(@html_files)
    . ' BrokenLinks=' . scalar(@broken_links)
    . ' MissingLocalPod=' . scalar(@missing_sorted)
    . ' DupName=' . scalar(@dup_name)
    . ' MarkdownLeaks=' . scalar(@markdown_leaks)
    . ' EmptyOrStub=' . scalar(@empty_or_stub)
    . ' (report: ' . $out . ")\n";

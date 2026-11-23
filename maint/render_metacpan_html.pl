#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename qw(dirname);
use File::Find     qw(find);
use File::Path     qw(make_path remove_tree);
use MetaCPAN::Pod::XHTML;

my $out_dir       = $ARGV[0] || $ENV{GALP_RENDERED_DIR} || 'tmp/rendered';
my $extra_lib_dir = $ARGV[1] || $ENV{GALP_EXTRA_LIB_DIR} || '';
remove_tree($out_dir) if -d $out_dir;
make_path($out_dir);

my @dists = qw(
    Protobuf
    Google-Api-Common
    Google-Auth
    Google-gRPC
    Module-Starter-Protobuf
);

my @sources;
for my $dist (@dists) {
    for my $sub (qw(lib pod bin)) {
        my $root = $dist . '/' . $sub;
        next unless -d $root;
        find(
            {
                no_chdir => 1,
                wanted   => sub {
                    return unless -f $_ && !-B $_;
                    return if $sub ne 'bin' && !/\.(?:pm|pod)\z/;
                    return if $sub eq 'bin' && /\.(?:PL|ps1|bak)\z/;
                    return if m{/lib/(?:Conformance|Protobuf_test_messages)/};
                    my $src = $_;
                    (my $rel = $src) =~ s{\A\Q$root\E/}{};
                    (my $mod = $rel) =~ s{\.(?:pm|pod)\z}{};
                    $mod =~ s{/}{::}g;
                    (my $slug = $mod) =~ s{::}{-}g;
                    my $rel_out = $dist . '/' . $slug . '.html';
                    push @sources, [ $src, $rel_out, $mod, $dist ];
                },
            },
            $root
        );
    }
}

if (length $extra_lib_dir && -d $extra_lib_dir) {
    push @dists, 'Generated-SDKs';
    find(
        {
            no_chdir => 1,
            wanted   => sub {
                return unless -f $_ && !-B $_ && /\.(?:pm|pod)\z/;
                my $src = $_;
                (my $rel = $src) =~ s{\A\Q$extra_lib_dir\E/}{};
                (my $mod = $rel) =~ s{\.(?:pm|pod)\z}{};
                $mod =~ s{/}{::}g;
                (my $slug = $mod) =~ s{::}{-}g;
                my $rel_out = 'Generated-SDKs/' . $slug . '.html';
                push @sources, [ $src, $rel_out, $mod, 'Generated-SDKs' ];
            },
        },
        $extra_lib_dir
    );
}

@sources = sort { $a->[3] cmp $b->[3] || $a->[2] cmp $b->[2] } @sources;
my %local_map = map { $_->[2] => '../' . $_->[1] } @sources;

my $css = <<'CSS';
body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; max-width: 960px; margin: 2rem auto; padding: 0 1.5rem; line-height: 1.6; color: #222; }
pre { background: #f6f8fa; border: 1px solid #e1e4e8; border-radius: 6px; padding: 1rem; overflow-x: auto; }
code { background: #f6f8fa; padding: 0.15em 0.35em; border-radius: 3px; font-size: 0.92em; }
pre code { background: none; padding: 0; }
h1, h2, h3 { border-bottom: 1px solid #eaecef; padding-bottom: 0.3em; margin-top: 1.5em; }
a { color: #0366d6; text-decoration: none; }
a:hover { text-decoration: underline; }
#index { background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 6px; padding: 1rem 1.5rem; margin-bottom: 2rem; }
CSS

my %by_dist;
my $rendered_count = 0;

for my $item (@sources) {
    my ($src, $rel_out, $title, $dist) = @$item;

    my $parser = MetaCPAN::Pod::XHTML->new();
    $parser->perldoc_url_prefix('https://metacpan.org/pod/');
    $parser->index(1);
    $parser->html_header(
        '<!DOCTYPE html><html><head><meta charset="utf-8"><title>'
        . $title
        . ' - MetaCPAN Preview</title><style>'
        . $css
        . '</style></head><body><p><a href="../index.html">&larr; Back to Index</a></p>'
    );
    $parser->html_footer('</body></html>');

    my $html = '';
    $parser->output_string(\$html);
    $parser->parse_file($src);
    next unless $parser->content_seen;

    $html =~ s{href="https://metacpan\.org/pod/([^"#]+)(#[^"]*)?"}{
        my ($mod, $frag) = ($1, $2 // '');
        exists $local_map{$mod} ? 'href="' . $local_map{$mod} . $frag . '"' : 'href="https://metacpan.org/pod/' . $mod . $frag . '"';
    }ge;

    my $dest = $out_dir . '/' . $rel_out;
    make_path(dirname($dest));
    open my $fh, '>:encoding(UTF-8)', $dest or die 'Cannot write ' . $dest . ': ' . $!;
    print {$fh} $html;
    close $fh or die 'Cannot close ' . $dest . ': ' . $!;

    push @{ $by_dist{$dist} }, '<li><a href="' . $rel_out . '">' . $title . '</a></li>';
    $rendered_count++;
}

my $sections = '';
for my $dist (@dists) {
    next unless $by_dist{$dist} && @{ $by_dist{$dist} };
    $sections .= '<h2>' . $dist . '</h2><ul>' . join("\n", @{ $by_dist{$dist} }) . '</ul>';
}

my $index_html = '<!DOCTYPE html><html><head><meta charset="utf-8"><title>GALP MetaCPAN POD Preview</title><style>'
    . $css
    . '</style></head><body><h1>GALP MetaCPAN POD Preview</h1>'
    . $sections
    . '</body></html>';

my $index_file = $out_dir . '/index.html';
open my $ifh, '>:encoding(UTF-8)', $index_file or die 'Cannot write ' . $index_file . ': ' . $!;
print {$ifh} $index_html;
close $ifh or die 'Cannot close ' . $index_file . ': ' . $!;

print 'Rendered ' . $rendered_count . ' pages across ' . scalar(@dists) . ' distributions to ' . $out_dir . "\n";

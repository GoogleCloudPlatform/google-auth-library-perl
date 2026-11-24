use strict;
use warnings;
use Test::More;
use PDL;

use_ok('PDL::ML::RAG', qw(chunk_text render_prompt normalize_vec));

my @chunks = chunk_text('abcdefghij', chunk_size => 4, overlap => 2);
is_deeply(\@chunks, ['abcd', 'cdef', 'efgh', 'ghij'], 'chunk_text splits with overlap');

my $prompt = render_prompt('Ctx: {{context}} | Q: {{question}}', { context => 'A', question => 'B' });
is($prompt, 'Ctx: A | Q: B', 'render_prompt substitutes placeholders');

# Deterministic bag-of-keywords embedder for unit testing
my $embedder = sub {
    my ($text) = @_;
    my $lc = lc($text);
    return float([
        ($lc =~ /pdl|array|matrix/ ? 1.0 : 0.0),
        ($lc =~ /sql|duckdb|table/ ? 1.0 : 0.0),
        ($lc =~ /gpu|cuda|torch/   ? 1.0 : 0.0),
    ]);
};

my $rag = PDL::ML::RAG::Pipeline->new(
    embedder  => $embedder,
    generator => sub {
        my ($p, $hits) = @_;
        return 'TOP:' . $hits->[0]->{metadata}->{src};
    },
    chunk_size => 200,
    overlap    => 20,
);

my $n = $rag->ingest([
    { text => 'PDL provides fast n-dimensional array math.', metadata => { src => 'pdl' } },
    { text => 'DuckDB executes vectorized SQL queries.',     metadata => { src => 'duckdb' } },
    { text => 'Torch runs CUDA GPU tensor operations.',      metadata => { src => 'torch' } },
]);
is($n, 3, 'ingested 3 chunks');
is($rag->store->count(), 3, 'store contains 3 documents');

my $res = $rag->query('How do I run SQL?', k => 2);
is($res->{hits}->[0]->{metadata}->{src}, 'duckdb', 'top retrieved hit is duckdb');
is($res->{answer}, 'TOP:duckdb', 'generator received top hit and produced answer');
like($res->{prompt}, qr/DuckDB executes vectorized SQL/, 'rendered prompt includes retrieved context');

done_testing();

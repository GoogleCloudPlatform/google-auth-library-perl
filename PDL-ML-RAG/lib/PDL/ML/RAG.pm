package PDL::ML::RAG;

use strict;
use warnings;
use Exporter 'import';
use Carp qw(croak);
use PDL::Core;
use PDL::Types;
use PDL::Slices;
use PDL::Ufunc;

our $VERSION = '0.011';

our @EXPORT_OK = qw(
    chunk_text
    render_prompt
    normalize_vec
);

sub chunk_text {
    my ($text, %opts) = @_;
    return () unless defined $text && length $text;
    my $chunk_size = $opts{chunk_size} || 512;
    my $overlap    = exists $opts{overlap} ? $opts{overlap} : 64;
    croak 'overlap must be smaller than chunk_size' if $overlap >= $chunk_size;

    my @chunks;
    my $len = length($text);
    my $pos = 0;
    my $step = $chunk_size - $overlap;
    while ($pos < $len) {
        my $chunk = substr($text, $pos, $chunk_size);
        push @chunks, $chunk;
        last if $pos + $chunk_size >= $len;
        $pos += $step;
    }
    return @chunks;
}

sub render_prompt {
    my ($template, $vars) = @_;
    croak 'template is required' unless defined $template;
    $vars ||= {};
    my $out = $template;
    $out =~ s/\{\{\s*([a-zA-Z0-9_]+)\s*\}\}/defined $vars->{$1} ? $vars->{$1} : ''/ge;
    return $out;
}

sub normalize_vec {
    my ($pdl) = @_;
    my $f    = $pdl->float();
    my $norm = sqrt(($f * $f)->sumover());
    return $norm > 0 ? ($f / $norm) : $f;
}

package PDL::ML::RAG::Store;

use strict;
use warnings;
use Carp qw(croak);
use PDL::Core;
use PDL::Ufunc;

sub new {
    my ($class, %args) = @_;
    return bless {
        docs => [],
        vecs => [],
    }, $class;
}

sub count {
    my ($self) = @_;
    return scalar(@{ $self->{docs} });
}

sub add {
    my ($self, $text, $embedding, $metadata) = @_;
    croak 'text is required'      unless defined $text;
    croak 'embedding is required' unless defined $embedding;
    push @{ $self->{docs} }, {
        text     => $text,
        metadata => $metadata || {},
    };
    push @{ $self->{vecs} }, PDL::ML::RAG::normalize_vec($embedding);
    return $self;
}

sub search {
    my ($self, $query_vec, $k) = @_;
    $k ||= 3;
    my $n = scalar(@{ $self->{docs} });
    return () if $n == 0;

    my $q = PDL::ML::RAG::normalize_vec($query_vec);
    my @scored;
    for my $i (0 .. $n - 1) {
        my $score = ($q * $self->{vecs}->[$i])->sum()->sclr();
        push @scored, {
            index    => $i,
            score    => $score,
            text     => $self->{docs}->[$i]->{text},
            metadata => $self->{docs}->[$i]->{metadata},
        };
    }
    @scored = sort { $b->{score} <=> $a->{score} } @scored;
    my $limit = $k < scalar(@scored) ? $k : scalar(@scored);
    return @scored[ 0 .. $limit - 1 ];
}

package PDL::ML::RAG::Pipeline;

use strict;
use warnings;
use Carp qw(croak);

my $DEFAULT_TEMPLATE = "Context:\n{{context}}\n\nQuestion: {{question}}\nAnswer:";

sub new {
    my ($class, %args) = @_;
    croak 'embedder CODE ref is required' unless ref($args{embedder}) eq 'CODE';
    return bless {
        embedder   => $args{embedder},
        generator  => $args{generator},
        store      => $args{store}      || PDL::ML::RAG::Store->new(),
        template   => $args{template}   || $DEFAULT_TEMPLATE,
        chunk_size => $args{chunk_size} || 512,
        overlap    => exists $args{overlap} ? $args{overlap} : 64,
    }, $class;
}

sub store { return $_[0]->{store}; }

sub ingest {
    my ($self, $docs) = @_;
    croak 'docs must be an ARRAY ref' unless ref($docs) eq 'ARRAY';
    my $added = 0;
    for my $doc (@{$docs}) {
        my ($text, $meta) = ref($doc) eq 'HASH'
            ? ($doc->{text}, $doc->{metadata} || {})
            : ($doc, {});
        my @chunks = PDL::ML::RAG::chunk_text(
            $text,
            chunk_size => $self->{chunk_size},
            overlap    => $self->{overlap},
        );
        for my $i (0 .. $#chunks) {
            my $vec = $self->{embedder}->($chunks[$i]);
            $self->{store}->add(
                $chunks[$i],
                $vec,
                { %{$meta}, chunk_index => $i },
            );
            $added++;
        }
    }
    return $added;
}

sub retrieve {
    my ($self, $question, %opts) = @_;
    my $k    = $opts{k} || 3;
    my $qvec = $self->{embedder}->($question);
    return $self->{store}->search($qvec, $k);
}

sub query {
    my ($self, $question, %opts) = @_;
    my @hits    = $self->retrieve($question, %opts);
    my $context = join("\n---\n", map { $_->{text} } @hits);
    my $prompt  = PDL::ML::RAG::render_prompt(
        $opts{template} || $self->{template},
        { context => $context, question => $question },
    );
    my $answer = ref($self->{generator}) eq 'CODE'
        ? $self->{generator}->($prompt, \@hits)
        : undef;
    return {
        question => $question,
        prompt   => $prompt,
        hits     => \@hits,
        answer   => $answer,
    };
}

1;

__END__

=encoding UTF-8

=head1 NAME

PDL::ML::RAG - Retrieval-Augmented Generation (chunking, vector store, prompt chains) for PDL

=head1 SYNOPSIS

    use PDL;
    use PDL::ML::RAG qw(chunk_text render_prompt);

    my $rag = PDL::ML::RAG::Pipeline->new(
        embedder  => sub { my ($text) = @_; ... }, # returns 1D PDL float vector
        generator => sub { my ($prompt, $hits) = @_; ... },
    );

    $rag->ingest([
        { text => 'PDL provides fast n-dimensional arrays for Perl.', metadata => { src => 'pdl' } },
        { text => 'DuckDB runs vectorized SQL queries in-process.',   metadata => { src => 'duckdb' } },
    ]);

    my $res = $rag->query('How do I run SQL?', k => 1);
    print $res->{answer}, "\n";

=head1 DESCRIPTION

C<PDL::ML::RAG> provides a lightweight, Perl-native Retrieval-Augmented Generation
(RAG) orchestration layer on top of L<PDL>: sliding-window document chunking,
normalized cosine-similarity vector storage (C<PDL::ML::RAG::Store>), prompt
templating, and pluggable embedding/generation pipelines
(C<PDL::ML::RAG::Pipeline>) compatible with L<PDL::Llama>, L<PDL::Torch>,
L<PDL::ONNX>, L<PDL::FAISS>, and L<Google::gRPC::Client>.

=head1 FUNCTIONS

=head2 chunk_text

=for ref

Split text into overlapping chunks of length C<chunk_size> with C<overlap>.

=for usage

    @chunks = chunk_text($text, chunk_size => 512, overlap => 64);

=head2 render_prompt

=for ref

Render C<{{var}}> placeholders in a prompt template.

=for usage

    $prompt = render_prompt($template, { context => $ctx, question => $q });

=head2 normalize_vec

=for ref

Return the L2-normalized float L<PDL> vector.

=for usage

    $unit = normalize_vec($pdl);

=head1 TYPES

Supports standard real numeric PDL types (C<byte>, C<short>, C<long>, C<longlong>, C<float>, C<double> as supported by the underlying library). Complex types (C<cfloat>, C<cdouble>) are not supported by this backend.

=head1 SEE ALSO

L<PDL>, L<PDL::FAISS>, L<PDL::DuckDB>, L<PDL::Llama>, L<PDL::Torch>, L<Google::gRPC::Client>

=head1 AUTHOR

C.J. Collier <cjac@google.com>

=head1 LICENSE

Licensed under the Apache License, Version 2.0.

=cut

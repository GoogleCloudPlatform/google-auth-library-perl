use strict;
use warnings;
use Test::More;
use File::Temp qw(tempfile);
use JSON::MaybeXS qw(encode_json);
use PDL::ML::Token::Tokenisers;

my $tok = PDL::ML::Token::Tokenisers->new(
    vocab => {
        '<unk>' => 0,
        'h'     => 1,
        'e'     => 2,
        'l'     => 3,
        'o'     => 4,
        'he'    => 5,
        'll'    => 6,
        'hello' => 7,
        'world' => 8,
    },
    merges => [ 'h e', 'l l', 'he ll', 'hell o' ],
);

is($tok->vocab_size, 9, 'vocab_size == 9');
my $ids = $tok->encode('hello world');
ok($ids->isa('PDL'), 'encode returns PDL');
is_deeply([ $ids->list ], [7, 8], 'encoded IDs match');
is($tok->decode($ids), 'hello world', 'decode round-trips');

my (undef, $jf) = tempfile(SUFFIX => '.json', UNLINK => 1);
open my $fh, '>', $jf or die $!;
print {$fh} encode_json({ model => { vocab => { '<unk>' => 0, 'perl' => 1 }, merges => [] } });
close $fh;

my $tok2 = PDL::ML::Token::Tokenisers->from_file($jf);
is_deeply([ $tok2->encode('perl')->list ], [1], 'from_file loads tokenizer.json');

done_testing();

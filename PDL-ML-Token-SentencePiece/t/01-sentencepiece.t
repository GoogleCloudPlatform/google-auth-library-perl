use strict;
use warnings;
use Test::More;

use_ok('PDL::ML::Token::SentencePiece');

my $sp = PDL::ML::Token::SentencePiece->new();
isa_ok($sp, 'PDL::ML::Token::SentencePiece');
is($sp->piece_size, 0, 'unloaded processor has piece_size 0');

eval { $sp->load('/nonexistent/model.spm') };
like($@, qr/Failed to load SentencePiece model/, 'missing model croaks cleanly');

done_testing();

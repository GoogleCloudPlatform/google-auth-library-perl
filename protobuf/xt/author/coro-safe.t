use strict;
use warnings;
use Test::More;
use Coro;
use File::Spec;
use blib;

# TODO: Add more tests as more C functions become available

plan tests => 1;

my $is_coro_safe = 1;

subtest 'Coro Safety Test' => sub {
    plan tests => 1;

    my @threads;
    for my $i (1..5) {
        push @threads, async {
            # Inside coro thread
            # TODO: Call some C functions that interact with arenas or object cache
            # Example: my $arena = Protobuf::Arena->new();
        };
    }

    $_->join for @threads;

    ok($is_coro_safe, "Coro threads completed without apparent issues");
};

done_testing();

use strict;
use warnings;
use Test::More;

use Protobuf::Arena;

subtest 'Arena Creation and Destruction' => {
    my $arena = Protobuf::Arena->new();
    ok(blessed($arena) && $arena->isa('Protobuf::Arena'), 'Arena object created and blessed');
    $arena = undef; # Trigger DESTROY
    ok(1, 'Arena object destroyed without error');
};

done_testing();

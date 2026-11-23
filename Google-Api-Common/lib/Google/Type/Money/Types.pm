package Google::Type::Money::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'Money',
    as InstanceOf['Google::Type::Money::Money'];

coerce 'Money',
    from HashRef, via { 'Google::Type::Money::Money'->new($_) };

declare 'RepeatedMoney',
    as ArrayRef[Money()];

coerce 'RepeatedMoney',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::Money::Money'->new($_) } @$_ ] };

declare 'MapStringMoney',
    as HashRef[Money()];

1;

__END__

=head1 NAME

Google::Type::Money::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

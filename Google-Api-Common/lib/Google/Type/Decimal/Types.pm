package Google::Type::Decimal::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'Decimal',
    as InstanceOf['Google::Type::Decimal::Decimal'];

coerce 'Decimal',
    from HashRef, via { 'Google::Type::Decimal::Decimal'->new($_) };

declare 'RepeatedDecimal',
    as ArrayRef[Decimal()];

coerce 'RepeatedDecimal',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::Decimal::Decimal'->new($_) } @$_ ] };

declare 'MapStringDecimal',
    as HashRef[Decimal()];

1;

__END__

=head1 NAME

Google::Type::Decimal::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

package Google::Type::Fraction::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'Fraction',
    as InstanceOf['Google::Type::Fraction::Fraction'];

coerce 'Fraction',
    from HashRef, via { 'Google::Type::Fraction::Fraction'->new($_) };

declare 'RepeatedFraction',
    as ArrayRef[Fraction()];

coerce 'RepeatedFraction',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::Fraction::Fraction'->new($_) } @$_ ] };

declare 'MapStringFraction',
    as HashRef[Fraction()];

1;

__END__

=head1 NAME

Google::Type::Fraction::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

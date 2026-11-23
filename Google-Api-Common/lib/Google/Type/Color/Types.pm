package Google::Type::Color::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'Color',
    as InstanceOf['Google::Type::Color::Color'];

coerce 'Color',
    from HashRef, via { 'Google::Type::Color::Color'->new($_) };

declare 'RepeatedColor',
    as ArrayRef[Color()];

coerce 'RepeatedColor',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::Color::Color'->new($_) } @$_ ] };

declare 'MapStringColor',
    as HashRef[Color()];

1;

__END__

=head1 NAME

Google::Type::Color::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

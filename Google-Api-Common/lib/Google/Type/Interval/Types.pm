package Google::Type::Interval::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'Interval',
    as InstanceOf['Google::Type::Interval::Interval'];

coerce 'Interval',
    from HashRef, via { 'Google::Type::Interval::Interval'->new($_) };

declare 'RepeatedInterval',
    as ArrayRef[Interval()];

coerce 'RepeatedInterval',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::Interval::Interval'->new($_) } @$_ ] };

declare 'MapStringInterval',
    as HashRef[Interval()];

1;

__END__

=head1 NAME

Google::Type::Interval::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

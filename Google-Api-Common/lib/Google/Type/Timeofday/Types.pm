package Google::Type::Timeofday::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'TimeOfDay',
    as InstanceOf['Google::Type::Timeofday::TimeOfDay'];

coerce 'TimeOfDay',
    from HashRef, via { 'Google::Type::Timeofday::TimeOfDay'->new($_) };

declare 'RepeatedTimeOfDay',
    as ArrayRef[TimeOfDay()];

coerce 'RepeatedTimeOfDay',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::Timeofday::TimeOfDay'->new($_) } @$_ ] };

declare 'MapStringTimeOfDay',
    as HashRef[TimeOfDay()];

1;

__END__

=head1 NAME

Google::Type::Timeofday::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

package Google::Type::Date::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'Date',
    as InstanceOf['Google::Type::Date::Date'];

coerce 'Date',
    from HashRef, via { 'Google::Type::Date::Date'->new($_) };

declare 'RepeatedDate',
    as ArrayRef[Date()];

coerce 'RepeatedDate',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::Date::Date'->new($_) } @$_ ] };

declare 'MapStringDate',
    as HashRef[Date()];

1;

__END__

=head1 NAME

Google::Type::Date::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

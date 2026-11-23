package Google::Type::Datetime::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'DateTime',
    as InstanceOf['Google::Type::Datetime::DateTime'];

coerce 'DateTime',
    from HashRef, via { 'Google::Type::Datetime::DateTime'->new($_) };

declare 'RepeatedDateTime',
    as ArrayRef[DateTime()];

coerce 'RepeatedDateTime',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::Datetime::DateTime'->new($_) } @$_ ] };

declare 'MapStringDateTime',
    as HashRef[DateTime()];

declare 'TimeZone',
    as InstanceOf['Google::Type::Datetime::TimeZone'];

coerce 'TimeZone',
    from HashRef, via { 'Google::Type::Datetime::TimeZone'->new($_) };

declare 'RepeatedTimeZone',
    as ArrayRef[TimeZone()];

coerce 'RepeatedTimeZone',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::Datetime::TimeZone'->new($_) } @$_ ] };

declare 'MapStringTimeZone',
    as HashRef[TimeZone()];

1;

__END__

=head1 NAME

Google::Type::Datetime::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

package Google::Type::PostalAddress::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'PostalAddress',
    as InstanceOf['Google::Type::PostalAddress::PostalAddress'];

coerce 'PostalAddress',
    from HashRef, via { 'Google::Type::PostalAddress::PostalAddress'->new($_) };

declare 'RepeatedPostalAddress',
    as ArrayRef[PostalAddress()];

coerce 'RepeatedPostalAddress',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::PostalAddress::PostalAddress'->new($_) } @$_ ] };

declare 'MapStringPostalAddress',
    as HashRef[PostalAddress()];

1;

__END__

=head1 NAME

Google::Type::PostalAddress::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

package Google::Type::Latlng::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'LatLng',
    as InstanceOf['Google::Type::Latlng::LatLng'];

coerce 'LatLng',
    from HashRef, via { 'Google::Type::Latlng::LatLng'->new($_) };

declare 'RepeatedLatLng',
    as ArrayRef[LatLng()];

coerce 'RepeatedLatLng',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::Latlng::LatLng'->new($_) } @$_ ] };

declare 'MapStringLatLng',
    as HashRef[LatLng()];

1;

__END__

=head1 NAME

Google::Type::Latlng::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

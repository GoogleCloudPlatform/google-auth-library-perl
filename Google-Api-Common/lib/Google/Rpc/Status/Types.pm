package Google::Rpc::Status::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'Status',
    as InstanceOf['Google::Rpc::Status::Status'];

coerce 'Status',
    from HashRef, via { 'Google::Rpc::Status::Status'->new($_) };

declare 'RepeatedStatus',
    as ArrayRef[Status()];

coerce 'RepeatedStatus',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::Status::Status'->new($_) } @$_ ] };

declare 'MapStringStatus',
    as HashRef[Status()];

1;

__END__

=head1 NAME

Google::Rpc::Status::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

package Google::Type::Expr::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'Expr',
    as InstanceOf['Google::Type::Expr::Expr'];

coerce 'Expr',
    from HashRef, via { 'Google::Type::Expr::Expr'->new($_) };

declare 'RepeatedExpr',
    as ArrayRef[Expr()];

coerce 'RepeatedExpr',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::Expr::Expr'->new($_) } @$_ ] };

declare 'MapStringExpr',
    as HashRef[Expr()];

1;

__END__

=head1 NAME

Google::Type::Expr::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

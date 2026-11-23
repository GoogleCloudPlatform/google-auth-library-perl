package Google::Type::LocalizedText::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'LocalizedText',
    as InstanceOf['Google::Type::LocalizedText::LocalizedText'];

coerce 'LocalizedText',
    from HashRef, via { 'Google::Type::LocalizedText::LocalizedText'->new($_) };

declare 'RepeatedLocalizedText',
    as ArrayRef[LocalizedText()];

coerce 'RepeatedLocalizedText',
    from ArrayRef[HashRef], via { [ map { 'Google::Type::LocalizedText::LocalizedText'->new($_) } @$_ ] };

declare 'MapStringLocalizedText',
    as HashRef[LocalizedText()];

1;

__END__

=head1 NAME

Google::Type::LocalizedText::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

package Google::Rpc::Http::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'HttpRequest',
    as InstanceOf['Google::Rpc::Http::HttpRequest'];

coerce 'HttpRequest',
    from HashRef, via { 'Google::Rpc::Http::HttpRequest'->new($_) };

declare 'RepeatedHttpRequest',
    as ArrayRef[HttpRequest()];

coerce 'RepeatedHttpRequest',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::Http::HttpRequest'->new($_) } @$_ ] };

declare 'MapStringHttpRequest',
    as HashRef[HttpRequest()];

declare 'HttpResponse',
    as InstanceOf['Google::Rpc::Http::HttpResponse'];

coerce 'HttpResponse',
    from HashRef, via { 'Google::Rpc::Http::HttpResponse'->new($_) };

declare 'RepeatedHttpResponse',
    as ArrayRef[HttpResponse()];

coerce 'RepeatedHttpResponse',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::Http::HttpResponse'->new($_) } @$_ ] };

declare 'MapStringHttpResponse',
    as HashRef[HttpResponse()];

declare 'HttpHeader',
    as InstanceOf['Google::Rpc::Http::HttpHeader'];

coerce 'HttpHeader',
    from HashRef, via { 'Google::Rpc::Http::HttpHeader'->new($_) };

declare 'RepeatedHttpHeader',
    as ArrayRef[HttpHeader()];

coerce 'RepeatedHttpHeader',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::Http::HttpHeader'->new($_) } @$_ ] };

declare 'MapStringHttpHeader',
    as HashRef[HttpHeader()];

1;

__END__

=head1 NAME

Google::Rpc::Http::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

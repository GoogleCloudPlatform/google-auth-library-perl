package Google::Api::Common;

use strict;
use warnings;

use Google::Cloud::ClientBase;
use Google::Cloud::REST::Client;

our $VERSION = '0.05';

1;

__END__

=head1 NAME

Google::Api::Common - Transport and REST client base for Google Cloud Services

=head1 DESCRIPTION

Provides L<Google::Cloud::ClientBase>, L<Google::Cloud::REST::Client>, and pluggable
HTTP/1.1 and HTTP/2 transport adapters for Google Cloud Perl client libraries.
Common C<googleapis> Protocol Buffers schema classes (C<Google::Api::*>, C<Google::Type::*>,
C<Google::Longrunning::*>, and C<Google::Rpc::*>) are generated automatically at build time
from C<.proto> definitions.

=head1 COPYRIGHT AND LICENSE

Copyright 2026 Google LLC

Licensed under the Apache License, Version 2.0.

=cut

package Google::Api::Common;

use strict;
use warnings;

use Google::Cloud::ClientBase;
use Google::Cloud::REST::Client;

our $VERSION = '0.06';

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Api::Common - Core transport, REST client, and googleapis schemas

=head1 VERSION

Version 0.06

=head1 SYNOPSIS

    use Google::Auth;
    use Google::Cloud::REST::Client;
    use Google::Cloud::Transport::Configuration;
    use Google::Cloud::Transport::Adapter::LWP;

    my $auth  = Google::Auth->default();
    my $token = $auth->get_token();

    # Configure transport timeouts, TLS, and proxy settings
    my $config = Google::Cloud::Transport::Configuration->new(
        timeout         => 30,
        ssl_verify_host => 1,
    );

    my $transport = Google::Cloud::Transport::Adapter::LWP->new(
        configuration => $config,
    );

    my $rest = Google::Cloud::REST::Client->new(
        target     => 'storage.googleapis.com',
        auth_token => $token,
        transport  => $transport,
    );

    # Synchronous REST call (with automatic retries on 502/503/504)
    my $result = $rest->call({
        http_method => 'GET',
        path        => '/storage/v1/b/my-bucket',
    });

    # Asynchronous REST call returning a Future
    my $future = $rest->call_async({
        http_method => 'GET',
        path        => '/storage/v1/b/my-bucket',
    });
    my $async_result = $future->get();

=head1 DESCRIPTION

C<Google::Api::Common> is the Perl counterpart to Google's shared API core
libraries (such as Python's C<google-api-core> + C<googleapis-common-protos>,
Ruby's C<gapic-common>, Go's C<gax-go>, and Java's C<gax-java>).

It provides the shared runtime foundation used by generated C<Google::Cloud::*>
and C<Google::Ai::*> client libraries:

=over 4

=item * B<Pluggable Transport Architecture:> Unified bytes-only transport adapters returning L<Future> objects, decoupling calling-layer serialization from HTTP/1.1 and HTTP/2 wire engines.

=item * B<Async-Ready REST Client:> L<Google::Cloud::REST::Client> with OAuth 2.0 Bearer token injection, safe URI query percent-encoding, JSON/Protobuf payload encoding/decoding, and exponential backoff retries (non-blocking via L<AnyEvent> when async).

=item * B<Streaming Support:> Standardized C<< $stream->read() >> returning L<Future> for server-streaming and bi-directional streaming downloads/uploads.

=item * B<Bundled Common C<googleapis> Protobuf Schemas:> Standard C<Google::Api::*>, C<Google::Type::*>, C<Google::Longrunning::*>, and C<Google::Rpc::*> message classes compiled from C<.proto> definitions.

=back

=head1 CORE COMPONENTS

=head2 Client & Streaming Base

=over 4

=item * L<Google::Cloud::ClientBase> - Reference base class handling payload serialization/deserialization (JSON and Protobuf) and stream wrapping.

=item * L<Google::Cloud::ClientBase::Stream> - High-level streaming wrapper exposing C<read()>, C<write()>, C<close_write()>, and C<get_metadata()>.

=item * L<Google::Cloud::REST::Client> - Synchronous (C<call>) and asynchronous (C<call_async>) HTTP/REST client with automatic retry/backoff.

=back

=head2 Transport Adapters & Configuration

=over 4

=item * L<Google::Cloud::Transport::Configuration> - Shared transport settings (C<timeout>, C<ssl_verify_host>, C<ssl_ca_file>, proxy configuration).

=item * L<Google::Cloud::Transport::Adapter::LWP> - Default blocking HTTP/1.1 adapter backed by L<LWP::UserAgent>.

=item * L<Google::Cloud::Transport::Adapter::NetCurl> - High-performance libcurl / C<Net::Curl::Multi> adapter supporting HTTP/1.1 and HTTP/2.

=item * L<Google::Cloud::Transport::Adapter::Nghttp2> - Non-blocking HTTP/2 adapter backed by L<Net::HTTP2::nghttp2> and L<AnyEvent>, with full bi-directional streaming and sensitive header redaction in trace logs.

=item * L<Google::Cloud::Transport::Role::Adapter> / L<Google::Cloud::Transport::Role::Stream> - Moo roles defining the pluggable transport contract.

=back

=head1 BUNDLED COMMON SCHEMAS

This distribution includes compiled L<Protobuf> schema classes for common
C<googleapis> types:

=over 4

=item * C<Google::Api::*> (HTTP annotations, resource descriptors, quotas, metrics, monitored resources, services)

=item * C<Google::Type::*> (C<Date>, C<DateTime>, C<Money>, C<LatLng>, C<PostalAddress>, C<Color>, C<Expr>, C<Interval>, etc.)

=item * C<Google::Longrunning::Operations> (Long-Running Operations)

=item * C<Google::Rpc::Status> (Standard RPC error status payloads)

=back

=head1 SEE ALSO

L<Google::Auth>, L<Google::gRPC>, L<Google::gRPC::Client>, L<Protobuf>,
L<Module::Starter::Protobuf>, L<Future>

=head1 SUPPORT AND BUG TRACKING

Report bugs or feature requests via GitHub:

L<https://github.com/GoogleCloudPlatform/google-auth-library-perl/issues>

or CPAN RT:

L<https://rt.cpan.org/Dist/Display.html?Name=Google-Api-Common>

=head1 AUTHOR

C.J. Collier E<lt>cjac@google.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2026 Google LLC and contributors.

Licensed under the Apache License, Version 2.0.

=cut

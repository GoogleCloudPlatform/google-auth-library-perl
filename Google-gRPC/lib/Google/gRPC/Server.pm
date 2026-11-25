package Google::gRPC::Server;

use strict;
use warnings;
use Moo;
use Carp qw(croak);
use Scalar::Util qw(blessed weaken);
use Protocol::HTTP2::Server;
use Google::gRPC::Framing;
use Google::gRPC::Status;

my $GRPC_CONTENT_TYPE = 'application/grpc';
my $PERL_LOCATION_RE  = qr/ at \S+ line [0-9]+\.?\z/;
my $TRAILER_NAMES     = 'grpc-status, grpc-message';

our $VERSION = '0.11';

has host => (
    is      => 'ro',
    default => sub { '127.0.0.1' },
);

has port => (
    is      => 'rw',
    default => sub { 0 },
);

has max_receive_message_length => (
    is      => 'ro',
    default => sub { 4 * 1024 * 1024 },
);

has _handlers => (
    is      => 'ro',
    default => sub { {} },
);

has _listener => (
    is      => 'rw',
    clearer => '_clear_listener',
);

has _stop_cv => (
    is      => 'rw',
    clearer => '_clear_stop_cv',
);

sub register_method {
    my ($self, $service, $method, $handler, $opts) = @_;
    croak 'service is required' unless defined $service && length $service;
    croak 'method is required'  unless defined $method  && length $method;
    croak 'handler must be a CODE ref' unless ref($handler) eq 'CODE';

    $opts ||= {};
    my $path = '/' . $service . '/' . $method;
    $self->_handlers->{$path} = {
        service       => $service,
        method        => $method,
        handler       => $handler,
        request_class => $opts->{request_class},
    };
    return $self;
}

sub register_service {
    my ($self, $service, $methods) = @_;
    croak 'service is required'          unless defined $service && length $service;
    croak 'methods must be a HASH ref'   unless ref($methods) eq 'HASH';

    for my $method (sort keys %{$methods}) {
        my $entry = $methods->{$method};
        if (ref($entry) eq 'CODE') {
            $self->register_method($service, $method, $entry);
        }
        elsif (ref($entry) eq 'HASH') {
            $self->register_method($service, $method, $entry->{handler}, $entry);
        }
        else {
            croak 'Invalid method entry for ' . $method;
        }
    }
    return $self;
}

sub dispatch_path {
    my ($self, $path) = @_;
    return undef unless defined $path;
    return $self->_handlers->{$path};
}

sub handle_unary {
    my ($self, $path, $payload, $metadata) = @_;
    my $spec = $self->dispatch_path($path);
    if (!$spec) {
        return (12, 'Unimplemented method: ' . ($path // ''), undef);
    }

    my $req = $payload;
    if (my $req_class = $spec->{request_class}) {
        my $decoded = eval { $req_class->decode($payload) };
        if ($@) {
            return (13, 'Invalid request payload: ' . _client_message($@), undef);
        }
        $req = $decoded;
    }

    my $ctx = {
        path     => $path,
        service  => $spec->{service},
        method   => $spec->{method},
        metadata => $metadata || {},
    };

    my $resp = eval { $spec->{handler}->($req, $ctx) };
    if ($@) {
        my $err = $@;
        if (blessed($err) && $err->isa('Google::gRPC::Status')) {
            return ($err->code, $err->message, undef);
        }
        return (2, _client_message($err), undef);
    }

    # An encode failure becomes a status instead of escaping into the event loop
    my $resp_bytes = eval {
        !defined $resp                             ? ''
            : blessed($resp) && $resp->can('encode') ? $resp->encode()
            :                                          $resp;
    };
    if ($@) {
        return (13, 'Failed to encode response: ' . _client_message($@), undef);
    }

    return (0, '', $resp_bytes);
}

# First line of a Perl error, without the " at FILE line N." suffix
sub _client_message {
    my ($err) = @_;
    my ($first) = split /\n/, "$err";
    $first //= '';
    $first =~ s/$PERL_LOCATION_RE//;
    return $first;
}

# The grpc-message value is percent-encoded UTF-8 (gRPC over HTTP/2, Responses)
sub _percent_encode {
    my ($text) = @_;
    my $bytes = $text;
    utf8::encode($bytes) if utf8::is_utf8($bytes);
    $bytes =~ s/([^\x20-\x24\x26-\x7e])/sprintf '%%%02X', ord $1/ge;
    # A field value must not start or end with a space (RFC 9113, 8.2.1)
    $bytes =~ s/\A /%20/;
    $bytes =~ s/ \z/%20/;
    return $bytes;
}

# A unary request body must be exactly one complete, uncompressed message
sub _read_unary_request {
    my ($body, $encoding, $max_len) = @_;
    my $buf = defined $body ? $body : '';
    if ($max_len && length($buf) > $max_len + 5) {
        return (8, 'Received message larger than max (' . length($buf) . ' vs. ' . $max_len . ')', undef);
    }
    my @frames = Google::gRPC::Framing::unpack_frame(\$buf);
    if (length $buf) {
        return (13, 'Truncated request message', undef);
    }
    if (@frames != 1) {
        return (12, 'Unary request must carry exactly one message', undef);
    }
    if ($max_len && length($frames[0]->{payload}) > $max_len) {
        return (8, 'Received message larger than max (' . length($frames[0]->{payload}) . ' vs. ' . $max_len . ')', undef);
    }
    if ($frames[0]->{compressed}) {
        if (!defined $encoding || $encoding eq '' || $encoding eq 'identity') {
            return (13, 'Compressed flag set without grpc-encoding', undef);
        }
        return (12, 'Unsupported grpc-encoding ' . $encoding, undef);
    }
    return (0, '', $frames[0]->{payload});
}

sub _extract_metadata {
    my ($headers_ref) = @_;
    my %meta;
    return \%meta unless ref($headers_ref) eq 'ARRAY';

    for (my $i = 0; $i < @{$headers_ref}; $i += 2) {
        my $k = lc($headers_ref->[$i]);
        my $v = $headers_ref->[$i + 1];
        $meta{$k} = $v;
    }
    return \%meta;
}

sub new_session {
    my ($self) = @_;
    my $session;
    my $weak_session;
    $session = Google::gRPC::Server::Session->new(
        on_request => sub {
            my ($stream_id, $headers_ref, $data) = @_;
            my $meta = _extract_metadata($headers_ref);
            my $path = $meta->{':path'} // '';

            # Unknown methods get UNIMPLEMENTED from handle_unary without the framing check
            my ($code, $message, $resp_bytes) = (0, '', undef);
            if ($self->dispatch_path($path)) {
                ($code, $message, $resp_bytes)
                    = _read_unary_request($data, $meta->{'grpc-encoding'}, $self->max_receive_message_length);
            }
            if ($code == 0) {
                ($code, $message, $resp_bytes)
                    = $self->handle_unary($path, $resp_bytes, $meta);
            }
            $weak_session->send_unary_response($stream_id, $code, $message, $resp_bytes);
        },
        on_error => sub {
            my ($err) = @_;
        },
    );
    $weak_session = $session;
    weaken($weak_session);
    return $session;
}

sub listen {
    my ($self, %opts) = @_;
    require AnyEvent;
    require AnyEvent::Socket;
    require AnyEvent::Handle;

    my $host = exists $opts{host} ? $opts{host} : $self->host;
    my $port = exists $opts{port} ? $opts{port} : $self->port;

    my $guard = AnyEvent::Socket::tcp_server(
        $host,
        $port,
        sub {
            my ($fh) = @_;
            my $session = $self->new_session();
            my $handle;
            $handle = AnyEvent::Handle->new(
                fh       => $fh,
                on_error => sub {
                    $handle->destroy if $handle;
                    undef $handle;
                },
                on_eof => sub {
                    $handle->destroy if $handle;
                    undef $handle;
                },
                on_read => sub {
                    my ($hdl) = @_;
                    my $chunk = delete $hdl->{rbuf};
                    $session->feed($chunk) if defined $chunk && length $chunk;
                    while (defined(my $frame = $session->next_frame)) {
                        $hdl->push_write($frame);
                    }
                    if ($session->shutdown) {
                        $hdl->push_shutdown;
                    }
                },
            );
            while (defined(my $frame = $session->next_frame)) {
                $handle->push_write($frame);
            }
        },
        sub {
            my ($fh, $bound_host, $bound_port) = @_;
            $self->port($bound_port);
            return 128;
        },
    );

    $self->_listener($guard);
    return $self->port;
}

sub stop {
    my ($self) = @_;
    $self->_clear_listener;
    if (my $cv = $self->_stop_cv) {
        $cv->send;
        $self->_clear_stop_cv;
    }
    return $self;
}

sub run {
    my ($self, %opts) = @_;
    require AnyEvent;
    $self->listen(%opts) unless $self->_listener;
    my $cv = AnyEvent->condvar;
    $self->_stop_cv($cv);
    $cv->recv;
    return $self;
}

package Google::gRPC::Server::Session;

use strict;
use warnings;
use parent -norequire, 'Protocol::HTTP2::Server';
use Protocol::HTTP2::Constants qw(:states);

# Headers, the message, then grpc-status in trailers; Trailers-Only when there is no message
sub send_unary_response {
    my ($self, $stream_id, $code, $message, $resp_bytes) = @_;
    my $con    = $self->{con};
    my @status = ('grpc-status' => $code);
    if (defined $message && length $message) {
        push @status, 'grpc-message' => Google::gRPC::Server::_percent_encode($message);
    }

    if (!defined $resp_bytes) {
        $con->send_headers($stream_id, [':status' => 200, 'content-type' => $GRPC_CONTENT_TYPE, @status], 1);
        return;
    }

    $con->send_headers($stream_id,
        [':status' => 200, 'content-type' => $GRPC_CONTENT_TYPE, 'trailer' => $TRAILER_NAMES], 0);
    $con->send_data($stream_id, Google::gRPC::Framing::pack_frame($resp_bytes), 0);
    $self->{_grpc_trailers}->{$stream_id} = \@status;
    $self->_flush_trailers;
    return;
}

# Trailers wait until flow control has released all of the stream's DATA
sub _flush_trailers {
    my ($self) = @_;
    my $con     = $self->{con};
    my $pending = $self->{_grpc_trailers} or return;
    for my $stream_id (sort { $a <=> $b } keys %{$pending}) {
        my $state = $con->stream_state($stream_id);
        if (!defined $state || $state == CLOSED) {
            delete $pending->{$stream_id};
            next;
        }
        my $blocked = $con->stream_blocked_data($stream_id);
        next if defined $blocked && length $blocked;
        $con->send_headers($stream_id, delete $pending->{$stream_id}, 1);
    }
    return;
}

sub feed {
    my ($self, @args) = @_;
    my $res = $self->SUPER::feed(@args);
    $self->_flush_trailers;
    return $res;
}

1;

__END__

=encoding UTF-8

=head1 NAME

Google::gRPC::Server - HTTP/2 gRPC server for Perl

=head1 SYNOPSIS

    use Google::gRPC::Server;

    my $server = Google::gRPC::Server->new(
        host => '127.0.0.1',
        port => 50051,
    );

    $server->register_method(
        'helloworld.Greeter',
        'SayHello',
        sub {
            my ($req, $ctx) = @_;
            return 'Hello, ' . $req;
        },
    );

    $server->run();

=head1 DESCRIPTION

C<Google::gRPC::Server> implements a gRPC-over-HTTP/2 server in Perl using
L<Protocol::HTTP2::Server>, L<AnyEvent::Socket>, L<Google::gRPC::Framing>, and
L<Google::gRPC::Status>.

=head1 ATTRIBUTES

=head2 host

Bind address for L</listen> (default: C<127.0.0.1>).

=head2 port

TCP port for L</listen> (default: C<0>, which binds an ephemeral port and
updates C<port> to the assigned port number).

=head2 max_receive_message_length

Maximum unary request payload size in bytes (default: C<4194304>, i.e. 4 MiB,
matching C<grpc-go>). Set to C<0> to disable the limit. Requests exceeding this
limit are rejected with C<RESOURCE_EXHAUSTED> (status code C<8>).

=head1 METHODS

=head2 register_method( $service, $method, \&handler, \%opts )

Registers a unary RPC handler for C</$service/$method>. Optional
C<$opts-E<gt>{request_class}> automatically decodes incoming request payloads
via C<< $request_class->decode($bytes) >>.

=head2 register_service( $service, \%methods )

Registers multiple methods for C<$service>. Each value in C<%methods> may be a
C<CODE> reference or a hashref with C<handler> and optional C<request_class>.

=head2 dispatch_path( $path )

Returns the registered handler specification hashref for C<$path>, or C<undef>
if no handler is registered.

=head2 handle_unary( $path, $payload, \%metadata )

Invokes the registered handler for C<$path> and returns
C<($grpc_status_code, $grpc_message, $response_bytes)>.

=head2 new_session()

Returns a L<Protocol::HTTP2::Server> instance wired to this server's gRPC
dispatcher and framing layer, suitable for both live sockets and in-memory
testing.

=head2 listen( %opts )

Binds a TCP listener via L<AnyEvent::Socket::tcp_server> and returns the bound
port number.

=head2 run( %opts )

Calls L</listen> if not already listening and blocks in the L<AnyEvent> event
loop until L</stop> is called.

=head2 stop()

Closes the TCP listener and unblocks L</run>.

=head1 SEE ALSO

L<Google::gRPC>, L<Google::gRPC::Client>, L<Google::gRPC::Framing>,
L<Google::gRPC::Status>

=head1 AUTHOR

C.J. Collier <cjac@google.com>

=head1 LICENSE

Licensed under the Apache License, Version 2.0.

=cut

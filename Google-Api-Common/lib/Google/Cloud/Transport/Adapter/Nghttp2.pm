package Google::Cloud::Transport::Adapter::Nghttp2;

use strict;
use warnings;
use Moo;
use AnyEvent;
use AnyEvent::Handle;
use Net::SSLeay;
use Net::HTTP2::nghttp2;
use Net::HTTP2::nghttp2::Session;
use URI;
use Carp qw(croak);
use Log::Any qw($log);
use Scalar::Util qw(weaken);
use Future;

use Google::Cloud::Transport::Configuration;

our $VERSION = '0.13';

with 'Google::Cloud::Transport::Role::Adapter';

has configuration => (
    is      => 'ro',
    default => sub { Google::Cloud::Transport::Configuration->new() },
);

# Map of "host:port" -> { handle => $h, session => $s }
has _sessions => (
    is      => 'ro',
    default => sub { {} },
);

# Map of "host:port" -> Future (in-progress connection)
has _connection_futures => (
    is      => 'ro',
    default => sub { {} },
);

# Map of "host:port" -> AnyEvent::Handle (to keep them alive while connecting)
has _connecting_handles => (
    is      => 'ro',
    default => sub { {} },
);

sub request {
    my ($self, %args) = @_;
    
    my $url = $args{url} || $args{path};
    unless ($url) {
        return Google::Cloud::Transport::Adapter::Nghttp2::Future->fail('URL/Path is required', 'Transport');
    }
    
    my $uri = URI->new($url);
    my $host = $uri->host;
    my $port = $uri->port || ($uri->scheme eq 'https' ? 443 : 80);
    my $scheme = $uri->scheme;
    
    my $session_key = $host . ':' . $port;
    
    if (my $conn = $self->_sessions->{$session_key}) {
        my $future = Google::Cloud::Transport::Adapter::Nghttp2::Future->new;
        $self->_submit_request($conn->{session}, $conn->{handle}, $future, %args);
        return $future;
    }
    
    if (my $conn_future = $self->_connection_futures->{$session_key}) {
        return $conn_future->then(sub {
            my ($conn) = @_;
            my $future = Google::Cloud::Transport::Adapter::Nghttp2::Future->new;
            $self->_submit_request($conn->{session}, $conn->{handle}, $future, %args);
            return $future;
        });
    }
    
    my $conn_future = Google::Cloud::Transport::Adapter::Nghttp2::Future->new;
    $self->_connection_futures->{$session_key} = $conn_future;
    
    $self->_create_connection($host, $port, $scheme, $session_key);
    
    return $conn_future->then(sub {
        my ($conn) = @_;
        my $future = Google::Cloud::Transport::Adapter::Nghttp2::Future->new;
        $self->_submit_request($conn->{session}, $conn->{handle}, $future, %args);
        return $future;
    });
}

sub _create_connection {
    my ($self, $host, $port, $scheme, $session_key) = @_;
    
    $log->debugf('Creating connection to %s:%s', $host, $port) if $log;
    my $handle;
    $handle = AnyEvent::Handle->new(
        connect => [$host, $port],
        tls     => $scheme eq 'https' ? 'connect' : undef,
        tls_ctx => {
            verify => $self->configuration->ssl_verify_host,
            verify_peername => $self->configuration->ssl_verify_host ? 'http' : undef,
            (defined $self->configuration->ssl_ca_file ? (ca_file => $self->configuration->ssl_ca_file) : ()),
            prepare => sub {
                my ($tls) = @_;
                my $ctx = $tls->ctx;
                $log->debugf('Preparing TLS CTX for %s', $session_key) if $log;
                Net::SSLeay::CTX_set_alpn_protos($ctx, ['h2', 'http/1.1']);
            },
        },
        on_starttls => sub {
            my ($h, $success, $error) = @_;
            $log->debugf('on_starttls for %s: success=%s', $session_key, $success) if $log;
            delete $self->_connecting_handles->{$session_key};
            if ($success) {
                my $ssl = $h->{tls};
                my $alpn = Net::SSLeay::P_alpn_selected($ssl);
                $log->debugf('Negotiated ALPN for %s: %s', $session_key, $alpn // 'undef') if $log;
                if (defined $alpn && $alpn eq 'h2') {
                    $self->_setup_session($h, $session_key);
                } else {
                    my $conn_future = delete $self->_connection_futures->{$session_key};
                    $conn_future->fail('Failed to negotiate HTTP/2 (h2)', 'Transport');
                    $h->destroy;
                }
            } else {
                my $conn_future = delete $self->_connection_futures->{$session_key};
                $conn_future->fail('TLS Handshake Failed: ' . $error, 'Transport');
                $h->destroy;
            }
        },
        on_error => sub {
            my ($h, $fatal, $msg) = @_;
            $log->errorf('AnyEvent Error on %s: %s', $session_key, $msg) if $log;
            delete $self->_connecting_handles->{$session_key};
            if (my $conn_future = delete $self->_connection_futures->{$session_key}) {
                $conn_future->fail('Connection failed: ' . $msg, 'Transport');
            }
            delete $self->_sessions->{$session_key};
            $h->destroy;
        },
    );
    
    $self->_connecting_handles->{$session_key} = $handle;
}

sub _setup_session {
    my ($self, $h, $session_key) = @_;
    
    $log->debugf('Setting up HTTP/2 session for %s', $session_key) if $log;
    my $session;
    
    my %callbacks = (
        on_header => sub {
            my ($stream_id, $name, $value, $flags) = @_;
            $log->tracef('Stream %d Header: %s = %s', $stream_id, $name, $value) if $log;
            my $stream_data = $session->get_stream_user_data($stream_id);
            if ($stream_data) {
                $stream_data->{headers}{$name} = $value;
                if ($stream_data->{is_streaming} && $stream_data->{stream_handle}) {
                    $stream_data->{stream_handle}->headers->{$name} = $value;
                }
            }
            return 0;
        },
        on_data_chunk_recv => sub {
            my ($stream_id, $data, $flags) = @_;
            $log->tracef('Stream %d Data Chunk: %d bytes', $stream_id, length($data)) if $log;
            my $stream_data = $session->get_stream_user_data($stream_id);
            if ($stream_data) {
                if ($stream_data->{is_streaming}) {
                    $stream_data->{on_data}->($data) if $stream_data->{on_data};
                } else {
                    $stream_data->{body} .= $data;
                }
            }
            return 0;
        },
        on_stream_close => sub {
            my ($stream_id, $error_code) = @_;
            $log->debugf('Stream %d closed with code %d', $stream_id, $error_code) if $log;
            my $stream_data = $session->get_stream_user_data($stream_id);
            if ($stream_data) {
                my $raw_status = $stream_data->{headers} ? $stream_data->{headers}{':status'} : undef;
                my $http_status = (defined $raw_status && $raw_status =~ /\A(\d{3})\z/) ? int($1) : undef;
                my $is_http_err = defined $http_status && ($http_status < 200 || $http_status >= 300);

                if ($stream_data->{is_streaming}) {
                    if ($error_code != 0) {
                        $stream_data->{on_error}->('Stream closed with error: ' . $error_code) if $stream_data->{on_error};
                    } elsif ($is_http_err) {
                        $stream_data->{on_error}->('HTTP error: ' . $http_status) if $stream_data->{on_error};
                    } else {
                        $stream_data->{on_eof}->() if $stream_data->{on_eof};
                    }
                } else {
                    if ($error_code == 0) {
                        my $headers_obj;
                        if (eval { require HTTP::Headers; 1 }) {
                            $headers_obj = HTTP::Headers->new(%{ $stream_data->{headers} });
                        } else {
                            $headers_obj = $stream_data->{headers};
                        }
                        if ($is_http_err) {
                            $stream_data->{future}->fail(
                                'HTTP ' . $http_status,
                                'Transport',
                                {
                                    code    => $http_status,
                                    body    => $stream_data->{body},
                                    headers => $headers_obj,
                                },
                            );
                        } else {
                            $stream_data->{future}->done($stream_data->{body}, $headers_obj);
                        }
                    } else {
                        $stream_data->{future}->fail('Stream closed with error: ' . $error_code, 'Transport');
                    }
                }
            }
            return 0;
        },
        on_invalid_frame_recv => sub {
            my ($frame, $lib_error_code) = @_;
            $log->errorf('Invalid frame received: type=%s, error=%d', $frame->{type}, $lib_error_code) if $log;
            return 0;
        },
        on_frame_recv => sub {
            my ($frame) = @_;
            $log->tracef('Received H2 Frame: type=%s, flags=%s, stream=%d, len=%d', $frame->{type}, $frame->{flags}, $frame->{stream_id}, $frame->{length}) if $log;
            return 0;
        },
        on_frame_send => sub {
            my ($frame) = @_;
            $log->tracef('Sent H2 Frame: type=%s, flags=%s, stream=%d, len=%d', $frame->{type}, $frame->{flags}, $frame->{stream_id}, $frame->{length}) if $log;
            return 0;
        },
        on_error => sub {
            my ($lib_error_code, $msg) = @_;
            $log->errorf('nghttp2 session error: code=%d, msg=%s', $lib_error_code, $msg) if $log;
            return 0;
        },
    );
    
    $session = Net::HTTP2::nghttp2::Session->new_client(callbacks => \%callbacks);
    $session->send_connection_preface();
    
    my $conn = { handle => $h, session => $session };
    $self->_sessions->{$session_key} = $conn;
    
    $h->on_read(sub {
        my ($handle) = @_;
        my $buf = $handle->{rbuf};
        $handle->{rbuf} = '';
        $log->tracef('Read %d bytes from wire for %s', length($buf), $session_key) if $log;
        if ($session) {
            $session->mem_recv($buf);
            $self->_flush_send($conn);
        }
    });
    
    $self->_flush_send($conn);
    
    if (my $conn_future = delete $self->_connection_futures->{$session_key}) {
        $conn_future->done($conn);
    }
}

sub _submit_request {
    my ($self, $session, $h, $future, %args) = @_;
    
    my $method  = uc($args{method} || 'GET');
    my $url     = $args{url} || $args{path};
    my $headers = $args{headers} || {};
    my $body    = $args{body};
    
    $log->debugf('Submitting %s request to %s', $method, $url) if $log;
    
    my $uri = URI->new($url);
    my $path = $uri->path;
    $path = '/' unless length $path;
    $path .= '?' . $uri->query if defined $uri->query && length $uri->query;
    
    my $authority = $uri->host;
    my $port = $uri->port;
    if ($port && $port != ($uri->scheme eq 'https' ? 443 : 80)) {
        $authority .= ':' . $port;
    }
    
    my @h2_headers;
    
    while (my ($k, $v) = each %$headers) {
        push @h2_headers, [lc($k), $v];
    }
    
    if ($log) {
        my %sensitive = map { $_ => 1 } qw(
            authorization
            proxy-authorization
            x-goog-api-key
            cookie
            set-cookie
        );
        for my $h (@h2_headers) {
            my $val = $sensitive{lc($h->[0])} ? '[REDACTED]' : $h->[1];
            $log->tracef('Sending H2 Header: %s = %s', $h->[0], $val);
        }
    }
    
    my $stream_data = {
        future  => $future,
        headers => {},
        body    => '',
    };
    
    my %submit_args = (
        method    => $method,
        path      => $path,
        scheme    => $uri->scheme,
        authority => $authority,
        headers   => \@h2_headers,
    );
    
    if (defined $body) {
        $submit_args{body} = ref($body) eq 'SCALAR' ? $$body : $body;
    }
    
    my $stream_id = $session->submit_request(%submit_args);
    
    $session->set_stream_user_data($stream_id, $stream_data);
    
    $self->_flush_send({ handle => $h, session => $session });
}

sub _flush_send {
    my ($self, $conn) = @_;
    my $session = $conn->{session};
    my $h = $conn->{handle};
    
    while ($session->want_write) {
        if (my $out = $session->mem_send) {
            $log->tracef('Sending %d bytes to wire', length($out)) if $log;
            $h->push_write($out);
        } else {
            last;
        }
    }
}

sub start_stream {
    my ($self, %args) = @_;
    
    my $url = $args{url} || $args{path};
    unless ($url) {
        croak 'URL/Path is required';
    }
    
    my $uri = URI->new($url);
    my $host = $uri->host;
    my $port = $uri->port || ($uri->scheme eq 'https' ? 443 : 80);
    my $scheme = $uri->scheme;
    
    my $session_key = $host . ':' . $port;
    
    my $stream_handle = Google::Cloud::Transport::Adapter::Nghttp2::StreamHandle->new(
        adapter     => $self,
        session_key => $session_key,
    );

    if (my $conn = $self->_sessions->{$session_key}) {
        $self->_submit_streaming_request($conn->{session}, $conn->{handle}, $stream_handle, %args);
        return $stream_handle;
    }
    
    if (my $conn_future = $self->_connection_futures->{$session_key}) {
        $conn_future->on_done(sub {
            my ($conn) = @_;
            $self->_submit_streaming_request($conn->{session}, $conn->{handle}, $stream_handle, %args);
        });
        $conn_future->on_fail(sub {
            my ($error) = @_;
            $args{on_error}->($error) if $args{on_error};
        });
        return $stream_handle;
    }
    
    my $conn_future = Google::Cloud::Transport::Adapter::Nghttp2::Future->new;
    $self->_connection_futures->{$session_key} = $conn_future;
    
    $self->_create_connection($host, $port, $scheme, $session_key);
    
    $conn_future->on_done(sub {
        my ($conn) = @_;
        $self->_submit_streaming_request($conn->{session}, $conn->{handle}, $stream_handle, %args);
    });
    $conn_future->on_fail(sub {
        my ($error) = @_;
        $args{on_error}->($error) if $args{on_error};
    });

    return $stream_handle;
}

sub _submit_streaming_request {
    my ($self, $session, $h, $stream_handle, %args) = @_;
    
    my $method  = uc($args{method} || 'GET');
    my $url     = $args{url} || $args{path};
    my $headers = $args{headers} || {};
    my $body    = $args{body};
    
    $log->debugf('Submitting streaming %s request to %s', $method, $url) if $log;
    
    my $uri = URI->new($url);
    my $path = $uri->path;
    $path = '/' unless length $path;
    $path .= '?' . $uri->query if defined $uri->query && length $uri->query;
    
    my $authority = $uri->host;
    my $port = $uri->port;
    if ($port && $port != ($uri->scheme eq 'https' ? 443 : 80)) {
        $authority .= ':' . $port;
    }
    
    my @h2_headers;
    while (my ($k, $v) = each %$headers) {
        push @h2_headers, [lc($k), $v];
    }
    
    my $stream_data = {
        stream_handle => $stream_handle,
        on_data       => $args{on_data},
        on_eof        => $args{on_eof},
        on_error      => $args{on_error},
        headers       => {},
        is_streaming  => 1,
    };
    
    my %submit_args = (
        method    => $method,
        path      => $path,
        scheme    => $uri->scheme,
        authority => $authority,
        headers   => \@h2_headers,
    );
    
    if (defined $body) {
        if (ref($body) eq 'CODE') {
             $submit_args{body} = $body;
        } else {
             $submit_args{body} = ref($body) eq 'SCALAR' ? $$body : $body;
        }
    } else {
        # Default data provider for StreamHandle->write()
        $submit_args{body} = sub {
            my ($stream_id, $max_len) = @_;
            my $queue = $stream_handle->_send_queue;
            if (@$queue) {
                my $chunk = shift @$queue;
                my $eof = 0;
                if ($stream_handle->_eof && !@$queue) {
                    $eof = 1;
                }
                return ($chunk, $eof);
            } else {
                if ($stream_handle->_eof) {
                    return ('', 1);
                }
                return; # DEFER
            }
        };
    }
    
    my $stream_id = $session->submit_request(%submit_args);
    
    $stream_handle->stream_id($stream_id);
    $session->set_stream_user_data($stream_id, $stream_data);
    
    $self->_flush_send({ handle => $h, session => $session });
}

package Google::Cloud::Transport::Adapter::Nghttp2::StreamHandle;
use Moo;
with 'Google::Cloud::Transport::Role::Stream';
use Carp qw(croak);
use Log::Any qw($log);

has adapter => ( is => 'ro', required => 1 );
has session_key => ( is => 'ro', required => 1 );
has stream_id => ( is => 'rw' );
has headers => ( is => 'rw', default => sub { {} } );

# Queued data to be sent (written)
has _send_queue => ( is => 'ro', default => sub { [] } );
has _eof => ( is => 'rw', default => 0 );

sub write {
    my ($self, $data) = @_;
    push @{$self->_send_queue}, $data;
    
    if ($self->stream_id) {
        if (my $conn = $self->adapter->_sessions->{$self->session_key}) {
            $conn->{session}->resume_stream($self->stream_id);
            $self->adapter->_flush_send($conn);
        }
    }
    
    return Future->done;
}

sub close_write {
    my ($self) = @_;
    $self->_eof(1);
    if ($self->stream_id) {
        if (my $conn = $self->adapter->_sessions->{$self->session_key}) {
            $conn->{session}->resume_stream($self->stream_id);
            $self->adapter->_flush_send($conn);
        }
    }
}

sub get_metadata {
    my ($self, $type) = @_;
    if ($type eq 'headers') {
        return $self->headers;
    }
    return {};
}

package Google::Cloud::Transport::Adapter::Nghttp2::Future;
use base 'Future';
use AnyEvent;
use Log::Any qw($log);

sub await {
    my ($self) = @_;
    return $self if $self->is_ready;
    $log->debugf('Entering Future::await') if $log;
    my $cv = AnyEvent->condvar;
    $self->on_ready(sub {
        $log->debugf('Future is ready, sending condvar') if $log;
        $cv->send;
    });
    $cv->recv;
    $log->debugf('Exiting Future::await') if $log;
    return $self;
}

1;

__END__

=encoding UTF-8

=head1 NAME

Google::Cloud::Transport::Adapter::Nghttp2 - Non-blocking HTTP/2 transport adapter backed by Net::HTTP2::nghttp2 and AnyEvent

=head1 SYNOPSIS

    use Google::Cloud::Transport::Configuration;
    use Google::Cloud::Transport::Adapter::Nghttp2;

    my $config = Google::Cloud::Transport::Configuration->new(
        timeout         => 30,
        ssl_verify_host => 1,
    );

    my $adapter = Google::Cloud::Transport::Adapter::Nghttp2->new(
        configuration => $config,
    );

    # Unary HTTP/2 request returning a Future
    my $future = $adapter->request(
        method  => 'GET',
        url     => 'https://storage.googleapis.com/storage/v1/b/my-bucket',
        headers => { Authorization => 'Bearer ' . $token },
    );
    my ($body, $headers) = $future->get();

    # Streaming HTTP/2 request
    my $handle = $adapter->start_stream(
        method   => 'GET',
        url      => 'https://storage.googleapis.com/storage/v1/b/my-bucket/o/file?alt=media',
        headers  => { Authorization => 'Bearer ' . $token },
        on_data  => sub { my ($chunk) = @_; ... },
        on_eof   => sub { ... },
        on_error => sub { my ($err) = @_; ... },
    );

=head1 DESCRIPTION

C<Google::Cloud::Transport::Adapter::Nghttp2> implements
L<Google::Cloud::Transport::Role::Adapter> over native HTTP/2 multiplexing
using L<Net::HTTP2::nghttp2> and L<AnyEvent>. It pools persistent TLS+ALPN
(C<h2>) connections per C<scheme://host:port>, supports both unary requests and
bi-directional streaming uploads/downloads, fails Futures / triggers C<on_error>
on non-2xx HTTP status codes, and redacts sensitive headers
(C<authorization>, C<proxy-authorization>, C<x-goog-api-key>, C<cookie>,
C<set-cookie>) in trace logs.

=head1 ATTRIBUTES

=over 4

=item * B<configuration> - L<Google::Cloud::Transport::Configuration> object controlling TLS verification (C<ssl_verify_host>, C<ssl_ca_file>) and timeouts.

=back

=head1 METHODS

=head2 request( %args )

Dispatches a unary HTTP/2 request (C<method>, C<url>, C<headers>, C<body>) and
returns a L<Future> resolving to C<($body, $headers)>.

=head2 start_stream( %args )

Initiates a streaming HTTP/2 request with C<on_data>, C<on_eof>, and
C<on_error> callbacks and returns a stream handle supporting C<write()>,
C<close_write()>, and C<get_metadata('headers')>.

=head1 SEE ALSO

L<Google::Api::Common>, L<Google::Cloud::ClientBase>,
L<Google::Cloud::Transport::Configuration>,
L<Google::Cloud::Transport::Role::Adapter>,
L<Google::Cloud::Transport::Adapter::LWP>,
L<Google::Cloud::Transport::Adapter::NetCurl>

=head1 AUTHOR

C.J. Collier E<lt>cjac@google.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2026 Google LLC and contributors.

Licensed under the Apache License, Version 2.0.

=cut

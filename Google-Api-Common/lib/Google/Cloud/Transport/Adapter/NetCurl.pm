package Google::Cloud::Transport::Adapter::NetCurl;

use strict;
use warnings;
use Moo;
use Scalar::Util qw(refaddr);
use Net::Curl::Easy qw(:constants);
use Net::Curl::Multi qw(:constants);
use Future;
use Carp qw(croak);
use Log::Any qw($log);

use Google::Cloud::Transport::Configuration;

our $VERSION = '0.13';

with 'Google::Cloud::Transport::Role::Adapter';

has configuration => (
    is      => 'ro',
    default => sub { Google::Cloud::Transport::Configuration->new() },
);

sub timeout {
    my ($self) = @_;
    return $self->configuration->timeout;
}

has _pid => (
    is      => 'rw',
    default => sub { $$ },
);

# Map of auth_context_id -> Net::Curl::Multi handle
has _multi_handles => (
    is      => 'ro',
    default => sub { {} },
);

our @LEAKED_HANDLES;

sub _get_multi_handle {
    my ($self, $auth_context_id) = @_;
    $auth_context_id //= 'default';
    
    if ($self->_pid != $$) {
        $log->warnf('Fork detected in child %s! Re-initializing multi handles.', $$) if $log;
        
        # Abandon old handles to prevent graceful teardown in child
        push @LEAKED_HANDLES, values %{ $self->_multi_handles };
        
        %{ $self->_multi_handles } = ();
        $self->_pid($$);
    }
    
    return $self->_multi_handles->{$auth_context_id} //= Net::Curl::Multi->new();
}



# In a fully async environment, something needs to drive this Multi handle.
# For now, we implement a blocking fallback/driver internally if no external
# event loop integration is provided.

sub request {
    my ($self, %args) = @_;

    my $method  = uc($args{method} || 'GET');
    my $url     = $args{url} || $args{path};
    my $headers = $args{headers} || {};
    my $body    = $args{body};
    my $timeout = $args{timeout} // $self->timeout;

    unless ($url) {
        return Future->fail('URL/Path is required', 'Transport');
    }

    my $easy = Net::Curl::Easy->new();
    $easy->setopt(CURLOPT_URL, $url);
    
    # Enforce secure defaults from configuration
    $easy->setopt(CURLOPT_SSL_VERIFYPEER, $self->configuration->ssl_verify_host);
    $easy->setopt(CURLOPT_SSL_VERIFYHOST, $self->configuration->ssl_verify_host ? 2 : 0);
    
    if (my $ca_file = $self->configuration->ssl_ca_file) {
        $easy->setopt(CURLOPT_CAINFO, $ca_file);
    }
    
    if ($method eq 'POST') {
        $easy->setopt(CURLOPT_POST, 1);
    } elsif ($method ne 'GET') {
        $easy->setopt(CURLOPT_CUSTOMREQUEST, $method);
    }

    my @curl_headers;
    while (my ($k, $v) = each %$headers) {
        if (ref($v) eq 'ARRAY') {
            for my $val (@$v) {
                push @curl_headers, $k . ': ' . $val;
            }
        } else {
            push @curl_headers, $k . ': ' . $v;
        }
    }
    $easy->setopt(CURLOPT_HTTPHEADER, \@curl_headers) if @curl_headers;

    if (defined $body) {
        my $body_str = ref($body) eq 'SCALAR' ? $$body : $body;
        $easy->setopt(CURLOPT_POSTFIELDS, $body_str);
        $easy->setopt(CURLOPT_POSTFIELDSIZE, length($body_str));
    }

    $easy->setopt(CURLOPT_TIMEOUT, $timeout) if defined $timeout;

    # Configure HTTP version based on ALPN preferences
    my $alpn = $self->configuration->alpn_protocols;
    if (grep { $_ eq 'h2' } @$alpn) {
        eval { $easy->setopt(CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_2_0); };
    } elsif (grep { $_ eq 'http/1.1' } @$alpn) {
        $easy->setopt(CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
    }

    my $response_body = '';
    $easy->setopt(CURLOPT_WRITEFUNCTION, sub {
        my ($easy, $data) = @_;
        $response_body .= $data;
        return length($data);
    });

    my %response_headers;
    $easy->setopt(CURLOPT_HEADERFUNCTION, sub {
        my ($easy, $header_line) = @_;
        if ($header_line =~ /^([^:]+):\s*(.*)\r\n$/) {
            my ($key, $val) = (lc($1), $2);
            # Handle duplicate headers if needed
            $response_headers{$key} = $val;
        }
        return length($header_line);
    });

    my $future = Future->new;

    # BLOCKING FALLBACK USING MULTI
    # This prepares the code for multi-handling but retains synchronous behavior.
    # To make this truly non-blocking, we would return the future immediately
    # and have an external event loop drive $self->multi.



    my $auth_context_id = $args{auth_context_id};
    my $multi = $self->_get_multi_handle($auth_context_id);

    $log->debugf('Net::Curl: Dispatching %s %s [Auth Context: %s]', $method, $url, $auth_context_id // 'default') if $log;

    $multi->add_handle($easy);

    my $active = 1;
    while ($active) {
        $active = $multi->perform();
        if ($active) {
            my $timeout = $multi->timeout();
            $timeout = 1000 if $timeout < 0; # wait up to 1s if no timeout specified
            $multi->wait($timeout);
        }
    }

    my $curl_err;
    while (my ($msg, $msg_easy, $result) = $multi->info_read()) {
        if ($msg == CURLMSG_DONE && refaddr($msg_easy) == refaddr($easy)) {
            if ($result != CURLE_OK) {
                $curl_err = 'Curl error ' . $result;
            }
        }
    }

    $multi->remove_handle($easy);


    if ($curl_err) {
        $future->fail('Net::Curl perform failed: ' . $curl_err, 'Transport');
    } else {
        my $code = $easy->getinfo(CURLINFO_RESPONSE_CODE);
        if ($code >= 200 && $code < 300) {
            # Success
            # Wrap headers in a simple object or hash similar to LWP adapter
            # For consistency, let's use a simple hash or HTTP::Headers look-alike if needed.
            # But the role just says "headers", maybe a HashRef is fine.
            # The LWP adapter passes $res->headers which is an HTTP::Headers object.
            # We should probably be consistent.
            
            # Let's try to load HTTP::Headers for consistency if available,
            # otherwise just pass the HashRef.
            my $headers_obj;
            if (eval { require HTTP::Headers; 1 }) {
                $headers_obj = HTTP::Headers->new(%response_headers);
            } else {
                $headers_obj = \%response_headers;
            }

            $future->done($response_body, $headers_obj);
        } else {
            $future->fail('HTTP Error ' . $code, 'Transport', {
                code    => $code,
                body    => $response_body,
                headers => \%response_headers,
            });
        }
    }

    return $future;
}

sub start_stream {
    my ($self, %args) = @_;
    
    my $method  = uc($args{method} || 'GET');
    my $url     = $args{url} || $args{path};
    my $headers = $args{headers} || {};
    my $body    = $args{body};
    my $timeout = $args{timeout} // $self->timeout;
    
    my $on_data  = $args{on_data} or croak 'on_data callback is required';
    my $on_eof   = $args{on_eof};
    my $on_error = $args{on_error};

    unless ($url) {
        croak 'URL/Path is required';
    }

    my $easy = Net::Curl::Easy->new();
    $easy->setopt(CURLOPT_URL, $url);
    
    # Enforce secure defaults from configuration
    $easy->setopt(CURLOPT_SSL_VERIFYPEER, $self->configuration->ssl_verify_host);
    $easy->setopt(CURLOPT_SSL_VERIFYHOST, $self->configuration->ssl_verify_host ? 2 : 0);
    
    if (my $ca_file = $self->configuration->ssl_ca_file) {
        $easy->setopt(CURLOPT_CAINFO, $ca_file);
    }
    
    if ($method eq 'POST') {
        $easy->setopt(CURLOPT_POST, 1);
    } elsif ($method ne 'GET') {
        $easy->setopt(CURLOPT_CUSTOMREQUEST, $method);
    }

    my @curl_headers;
    while (my ($k, $v) = each %$headers) {
        if (ref($v) eq 'ARRAY') {
            for my $val (@$v) {
                push @curl_headers, $k . ': ' . $val;
            }
        } else {
            push @curl_headers, $k . ': ' . $v;
        }
    }
    $easy->setopt(CURLOPT_HTTPHEADER, \@curl_headers) if @curl_headers;

    if (defined $body) {
        my $body_str = ref($body) eq 'SCALAR' ? $$body : $body;
        $easy->setopt(CURLOPT_POSTFIELDS, $body_str);
        $easy->setopt(CURLOPT_POSTFIELDSIZE, length($body_str));
    }

    $easy->setopt(CURLOPT_TIMEOUT, $timeout) if defined $timeout;

    # Configure HTTP version based on ALPN preferences
    my $alpn = $self->configuration->alpn_protocols;
    if (grep { $_ eq 'h2' } @$alpn) {
        eval { $easy->setopt(CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_2_0); };
    } elsif (grep { $_ eq 'http/1.1' } @$alpn) {
        $easy->setopt(CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
    }

    $easy->setopt(CURLOPT_WRITEFUNCTION, sub {
        my ($easy, $data) = @_;
        my $continue = $on_data->($data);
        if (defined $continue && !$continue) {
            croak 'Pause not supported in blocking mode of NetCurl adapter';
        }
        return length($data);
    });

    my %response_headers;
    $easy->setopt(CURLOPT_HEADERFUNCTION, sub {
        my ($easy, $header_line) = @_;
        if ($header_line =~ /^([^:]+):\s*(.*)\r\n$/) {
            my ($key, $val) = (lc($1), $2);
            $response_headers{$key} = $val;
        }
        return length($header_line);
    });

    my $auth_context_id = $args{auth_context_id};
    my $multi = $self->_get_multi_handle($auth_context_id);

    $multi->add_handle($easy);

    my $active = 1;
    while ($active) {
        $active = $multi->perform();
        if ($active) {
            my $timeout_ms = $multi->timeout();
            $timeout_ms = 1000 if $timeout_ms < 0;
            $multi->wait($timeout_ms);
        }
    }

    my $curl_err;
    while (my ($msg, $msg_easy, $result) = $multi->info_read()) {
        if ($msg == CURLMSG_DONE && refaddr($msg_easy) == refaddr($easy)) {
            if ($result != CURLE_OK) {
                $curl_err = 'Curl error ' . $result;
            }
        }
    }

    $multi->remove_handle($easy);

    if ($curl_err) {
        $on_error->($curl_err) if $on_error;
    } else {
        $on_eof->() if $on_eof;
    }

    return Google::Cloud::Transport::Adapter::NetCurl::StreamHandle->new(
        headers => \%response_headers,
    );
}

package Google::Cloud::Transport::Adapter::NetCurl::StreamHandle;
use Moo;
with 'Google::Cloud::Transport::Role::Stream';
use Carp qw(croak);

has headers => ( is => 'ro', required => 1 );

sub write { croak 'Write not supported on blocking NetCurl stream' }
sub close_write { croak 'Close write not supported on blocking NetCurl stream' }

sub get_metadata {
    my ($self, $type) = @_;
    if ($type eq 'headers') {
        return $self->headers;
    }
    return {};
}

1;

=head1 NAME

Google::Cloud::Transport::Adapter::NetCurl - Net::Curl HTTP/1.1 and HTTP/2 backend for Pluggable Transport

=head1 SYNOPSIS

    use Google::Cloud::Transport::Adapter::NetCurl;

    my $transport = Google::Cloud::Transport::Adapter::NetCurl->new();

    my $future = $transport->request(
        method  => 'GET',
        url     => 'https://storage.googleapis.com/storage/v1/b',
        headers => { Authorization => "Bearer $token" },
    );

    my ($body, $headers) = $future->get();

=head1 DESCRIPTION

C<Google::Cloud::Transport::Adapter::NetCurl> implements the
L<Google::Cloud::Transport::Role::Adapter> role using L<Net::Curl::Easy> and
L<Net::Curl::Multi>. It supports HTTP/2 when C<libcurl> is compiled with
HTTP/2 support, enforces TLS settings from
L<Google::Cloud::Transport::Configuration>, isolates C<Net::Curl::Multi>
handles per C<auth_context_id>, and detects C<fork()> to safely re-initialize
handles in child processes.

=head1 ATTRIBUTES

=over 4

=item C<configuration> (read-only)

A L<Google::Cloud::Transport::Configuration> instance controlling TLS
verification, CA bundle, ALPN protocols, and default timeout.

=back

=head1 METHODS

=head2 timeout()

Returns the default request timeout in seconds from C<configuration>.

=head2 request(%args)

    my $future = $transport->request(
        method          => 'POST',
        url             => $url,
        headers         => \%headers,
        body            => $payload,
        timeout         => 30,
        auth_context_id => $ctx_id,
    );

Executes an HTTP request and returns a L<Future> resolving to
C<($response_body, $headers)> on 2xx responses, or failing with
C<($error, 'Transport', \%details)> on transport or non-2xx HTTP errors.

=head2 start_stream(%args)

    my $handle = $transport->start_stream(
        method   => 'GET',
        url      => $url,
        headers  => \%headers,
        on_data  => sub { my ($chunk) = @_; ... },
        on_eof   => sub { ... },
        on_error => sub { my ($err, $info) = @_; ... },
    );

Executes a streaming HTTP request, invoking C<on_data> as response chunks
arrive, followed by C<on_eof> or C<on_error>. Returns a stream handle
implementing L<Google::Cloud::Transport::Role::Stream>.

=head1 SEE ALSO

L<Google::Cloud::Transport::Configuration>,
L<Google::Cloud::Transport::Adapter::LWP>,
L<Google::Cloud::Transport::Adapter::Nghttp2>

=cut

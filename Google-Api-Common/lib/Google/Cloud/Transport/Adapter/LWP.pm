package Google::Cloud::Transport::Adapter::LWP;

use strict;
use warnings;
use Moo;
use LWP::UserAgent;
use HTTP::Request;
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

has user_agent => (
    is      => 'rw',
    lazy    => 1,
    builder => '_build_user_agent',
);

sub _build_user_agent {
    my ($self) = @_;
    my $ua = LWP::UserAgent->new(
        timeout => $self->configuration->timeout,
        agent   => 'google-cloud-perl-transport-lwp/' . $VERSION,
    );
    
    # Apply SSL verification
    $ua->ssl_opts(
        verify_hostname => $self->configuration->ssl_verify_host,
        SSL_verify_mode => $self->configuration->ssl_verify_host ? 1 : 0,
    );
    
    if (my $ca_file = $self->configuration->ssl_ca_file) {
        $ua->ssl_opts(SSL_ca_file => $ca_file);
    }
    
    return $ua;
}

sub request {
    my ($self, %args) = @_;
    
    my $method  = uc($args{method} || 'GET');
    my $url     = $args{url} || $args{path};
    my $headers = $args{headers} || {};
    my $body    = $args{body};
    my $timeout = $args{timeout};

    unless ($url) {
        return Future->fail('URL/Path is required', 'Transport');
    }

    $log->debugf('LWP Request: %s %s', $method, $url) if $log;

    my $req = HTTP::Request->new($method => $url);
    
    while (my ($k, $v) = each %$headers) {
        $req->header($k => $v);
    }

    if (defined $body) {
        $req->content(ref($body) eq 'SCALAR' ? $$body : $body);
    }

    # Clone UA to set timeout if specified per-request, to avoid race conditions
    # if the adapter is shared across threads/async tasks (though LWP is blocking).
    my $ua = $self->user_agent;
    if (defined $timeout) {
        $ua = $ua->clone;
        $ua->timeout($timeout);
    }

    my $res = $ua->request($req);

    $log->debugf('LWP Response: %s', $res->status_line) if $log;

    my $future = Future->new;
    
    if ($res->is_success) {
        $future->done($res->content, $res->headers);
    } else {
        # We might want to pass more structured error info
        $future->fail($res->status_line, 'Transport', $res);
    }

    return $future;
}

sub start_stream {
    my ($self, %args) = @_;
    
    my $method  = uc($args{method} || 'GET');
    my $url     = $args{url} || $args{path};
    my $headers = $args{headers} || {};
    my $body    = $args{body};
    my $timeout = $args{timeout};
    
    my $on_data  = $args{on_data} or croak 'on_data callback is required';
    my $on_eof   = $args{on_eof};
    my $on_error = $args{on_error};
    
    unless ($url) {
        croak 'URL/Path is required';
    }

    $log->debugf('LWP Stream Request: %s %s', $method, $url) if $log;

    my $req = HTTP::Request->new($method => $url);
    
    while (my ($k, $v) = each %$headers) {
        $req->header($k => $v);
    }

    if (defined $body) {
        $req->content(ref($body) eq 'SCALAR' ? $$body : $body);
    }

    my $ua = $self->user_agent;
    if (defined $timeout) {
        $ua = $ua->clone;
        $ua->timeout($timeout);
    }

    my $content_cb = sub {
        my ($chunk, $res, $protocol) = @_;
        $log->tracef('LWP Stream Chunk: %d bytes', length($chunk)) if $log;
        $on_data->($chunk);
        # Note: LWP doesn't support pause/resume naturally in this callback.
    };

    my $res = $ua->request($req, $content_cb);

    $log->debugf('LWP Stream Response: %s', $res->status_line) if $log;

    if ($res->is_success) {
        $on_eof->() if $on_eof;
    } else {
        $on_error->($res->status_line, $res) if $on_error;
    }
    
    return Google::Cloud::Transport::Adapter::LWP::StreamHandle->new(
        response => $res,
    );
}

package Google::Cloud::Transport::Adapter::LWP::StreamHandle;
use Moo;
with 'Google::Cloud::Transport::Role::Stream';
use Carp qw(croak);

has response => ( is => 'ro', required => 1 );

sub write { croak 'Write not supported on LWP stream' }
sub close_write { croak 'Close write not supported on LWP stream' }

sub get_metadata {
    my ($self, $type) = @_;
    if ($type eq 'headers') {
        # Return headers as a hash or object?
        # The role says "HashRef of metadata".
        # LWP response headers are HTTP::Headers object.
        # Let's convert to HashRef if needed, or return the object if it behaves like one or is accepted.
        # Let's try to return a HashRef for consistency.
        my $headers = $self->response->headers;
        my %hash;
        $headers->scan(sub { my ($k, $v) = @_; $hash{lc($k)} = $v; });
        return \%hash;
    }
    return {};
}

1;

=head1 NAME

Google::Cloud::Transport::Adapter::LWP - LWP::UserAgent backend for Pluggable Transport

=head1 SYNOPSIS

    use Google::Cloud::Transport::Adapter::LWP;

    my $transport = Google::Cloud::Transport::Adapter::LWP->new();

    my $future = $transport->request(
        method  => 'GET',
        url     => 'https://storage.googleapis.com/storage/v1/b',
        headers => { Authorization => "Bearer $token" },
    );

    my ($body, $headers) = $future->get();

=head1 DESCRIPTION

C<Google::Cloud::Transport::Adapter::LWP> implements the
L<Google::Cloud::Transport::Role::Adapter> role using L<LWP::UserAgent>. It
provides a portable, pure-Perl blocking HTTP/1.1 transport suitable for
environments without C<libcurl> or C<libnghttp2>, while applying the TLS and
timeout settings from L<Google::Cloud::Transport::Configuration>.

=head1 ATTRIBUTES

=over 4

=item C<configuration> (read-only)

A L<Google::Cloud::Transport::Configuration> instance controlling TLS
verification, CA bundle, and default timeout.

=item C<user_agent> (read-write, lazy)

The underlying L<LWP::UserAgent> instance.

=back

=head1 METHODS

=head2 request(%args)

    my $future = $transport->request(
        method  => 'POST',
        url     => $url,
        headers => \%headers,
        body    => $payload,
        timeout => 30,
    );

Executes an HTTP request and returns a L<Future> resolving to
C<($response_body, $http_headers)> on 2xx responses, or failing with
C<($status_line, 'Transport', $http_response)> on error.

=head2 start_stream(%args)

    my $handle = $transport->start_stream(
        method   => 'GET',
        url      => $url,
        headers  => \%headers,
        on_data  => sub { my ($chunk) = @_; ... },
        on_eof   => sub { ... },
        on_error => sub { my ($status_line, $res) = @_; ... },
    );

Streams the HTTP response body to C<on_data> in chunks, invoking C<on_eof> on
completion or C<on_error> on failure. Returns a stream handle implementing
L<Google::Cloud::Transport::Role::Stream>.

=head1 SEE ALSO

L<Google::Cloud::Transport::Configuration>,
L<Google::Cloud::Transport::Adapter::NetCurl>,
L<Google::Cloud::Transport::Adapter::Nghttp2>

=cut

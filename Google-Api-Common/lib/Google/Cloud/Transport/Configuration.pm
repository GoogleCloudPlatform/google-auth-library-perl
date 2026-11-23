package Google::Cloud::Transport::Configuration;

use strict;
use warnings;
use Moo;

our $VERSION = '0.01';

# Strict hostname verification enabled by default
has ssl_verify_host => (
    is      => 'ro',
    default => sub { 1 },
);

# Standard CA trust store path (optional, defaults to system or Mozilla::CA)
has ssl_ca_file => (
    is       => 'ro',
    required => 0,
);

# ALPN Preferences (e.g. ['h2', 'http/1.1'])
has alpn_protocols => (
    is      => 'ro',
    default => sub { ['h2', 'http/1.1'] },
);

# Timeout defaults
has timeout => (
    is      => 'ro',
    default => sub { 30 },
);

1;

__END__

=head1 NAME

Google::Cloud::Transport::Configuration - TLS, ALPN, and timeout configuration for Pluggable Transports

=head1 SYNOPSIS

    use Google::Cloud::Transport::Configuration;

    my $config = Google::Cloud::Transport::Configuration->new(
        ssl_verify_host => 1,
        ssl_ca_file     => '/etc/ssl/certs/ca-certificates.crt',
        alpn_protocols  => ['h2', 'http/1.1'],
        timeout         => 60,
    );

=head1 DESCRIPTION

C<Google::Cloud::Transport::Configuration> holds shared transport-level
configuration parameters for L<Google::Cloud::Transport> adapters (such as
L<Google::Cloud::Transport::Adapter::LWP>,
L<Google::Cloud::Transport::Adapter::NetCurl>, and
L<Google::Cloud::Transport::Adapter::Nghttp2>). It enforces secure defaults
including strict TLS hostname verification and HTTP/2 ALPN negotiation.

=head1 ATTRIBUTES

=over 4

=item C<ssl_verify_host> (read-only, default C<1>)

Enables strict TLS peer and hostname verification when true.

=item C<ssl_ca_file> (optional, read-only)

Path to a custom PEM CA bundle file. When omitted, the adapter uses the
system trust store or L<Mozilla::CA>.

=item C<alpn_protocols> (read-only, default C<['h2', 'http/1.1']>)

Ordered arrayref of ALPN protocol identifiers to advertise during TLS
negotiation.

=item C<timeout> (read-only, default C<30>)

Default per-request timeout in seconds.

=back

=head1 SEE ALSO

L<Google::Cloud::Transport::Adapter::LWP>,
L<Google::Cloud::Transport::Adapter::NetCurl>,
L<Google::Cloud::Transport::Adapter::Nghttp2>

=cut

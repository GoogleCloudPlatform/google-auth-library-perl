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

Google::Cloud::Transport::Configuration - Configuration for Pluggable Transports

=head1 DESCRIPTION

This class holds configuration parameters for Pluggable Transport adapters,
enforcing secure defaults like hostname verification and ALPN preferences.

=cut

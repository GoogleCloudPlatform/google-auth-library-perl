#!/usr/bin/perl
# Copyright 2026 Google LLC and contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use File::Spec;
use JSON::MaybeXS;

use Google::Auth;
use Google::Auth::ClientId;
use Google::Auth::UserAuthorizer;
use Google::Auth::Stores::FileTokenStore;
use Google::Auth::Exceptions;

my $VERSION = '0.01';

# Default Scopes for GCP
my @DEFAULT_SCOPES = (
    'https://www.googleapis.com/auth/cloud-platform',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'openid'
);

my $help = 0;
my $man = 0;

GetOptions(
    'help|?' => \$help,
    'man'    => \$man,
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage(-verbose => 2) if $man;

my $command = shift @ARGV;

unless ($command) {
    pod2usage(1);
}

if ($command eq 'login') {
    do_login();
} elsif ($command eq 'application-default') {
    my $subcommand = shift @ARGV;
    unless ($subcommand) {
        die "Error: application-default requires a subcommand (e.g., login)\n";
    }
    if ($subcommand eq 'login') {
        do_adc_login();
    } else {
        die "Unsupported application-default subcommand: $subcommand\n";
    }
} elsif ($command eq 'print-access-token') {
    do_print_access_token();
} else {
    die "Unsupported command: $command\n";
}

sub do_login {
    print "Interactive login not fully implemented in CLI yet.\n";
    # TODO: Implement local listener and browser launch
    # 1. Load ClientID
    # 2. Setup FileTokenStore for user tokens
    # 3. Instantiate UserAuthorizer
    # 4. Generate URL, launch browser or print URL
    # 5. Handle Callback
}

sub do_adc_login {
    print "Application-Default login not fully implemented in CLI yet.\n";
    # TODO: Same flow as login, but save to well-known ADC path in 'authorized_user' format
}

sub do_print_access_token {
    print "Print access token not implemented yet.\n";
}

__END__

=head1 NAME

gcloud-auth - CLI utility for Google Cloud Authentication

=head1 SYNOPSIS

gcloud-auth [options] [command]

 Commands:
   login               Log in using your user credentials
   application-default Login for running applications locally
   print-access-token  Print the current access token

 Options:
   --help              Show brief help message
   --man               Show full documentation

=head1 DESCRIPTION

B<gcloud-auth> provides a CLI interface to manage credentials for Google Cloud Platform,
emulating core parts of the C<gcloud auth> CLI.

=cut

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
use Log::Any qw($log);
use IO::Socket::INET;
use IO::Select;
use URI;

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

unless (caller) {
    run(@ARGV);
}

sub run {
    my @args = @_;
    
    my $help = 0;
    my $man = 0;
    my $verbose = 0;
    my $client_id_file;
    my $store_dir = File::Spec->catdir($ENV{HOME} // '.', '.google-auth-perl', 'tokens');

    local @ARGV = @args;
    
    GetOptions(
        'help|?'           => \$help,
        'man'              => \$man,
        'verbose|v'        => \$verbose,
        'client-id-file=s' => \$client_id_file,
        'store-dir=s'      => \$store_dir,
    ) or pod2usage(2);

    if ($verbose) {
        require Log::Any::Adapter;
        Log::Any::Adapter->set('Stderr', min_level => 'trace');
    }

    pod2usage(1) if $help;
    pod2usage(-verbose => 2) if $man;

    my $command = shift @ARGV;

    unless ($command) {
        pod2usage(1);
    }

    if ($command eq 'login') {
        do_login(
            client_id_file => $client_id_file,
            store_dir      => $store_dir,
        );
    } elsif ($command eq 'application-default') {
        my $subcommand = shift @ARGV;
        unless ($subcommand) {
            die "Error: application-default requires a subcommand (e.g., login)\n";
        }
        if ($subcommand eq 'login') {
            do_adc_login(
                client_id_file => $client_id_file,
                store_dir      => $store_dir,
            );
        } else {
            die "Unsupported application-default subcommand: $subcommand\n";
        }
    } elsif ($command eq 'print-access-token') {
        do_print_access_token();
    } else {
        die "Unsupported command: $command\n";
    }
}

sub do_login {
    my (%options) = @_;
    $log->info('Command: login initiated');
    $log->trace('Entering do_login');
    
    my $client_id_file = $options{client_id_file};
    my $store_dir      = $options{store_dir};
    
    unless ($client_id_file && -f $client_id_file) {
        $log->error('Client ID file is required for login');
        die "Error: --client-id-file is required and must exist.\n";
    }
    
    my $client_id = Google::Auth::ClientId->from_file($client_id_file);
    my $token_store = Google::Auth::Stores::FileTokenStore->new(store_dir => $store_dir);
    
    my $listener = IO::Socket::INET->new(
        LocalHost => '127.0.0.1',
        LocalPort => 0, # Auto-assign
        Proto     => 'tcp',
        Listen    => 1,
        ReuseAddr => 1,
    );
    
    unless ($listener) {
        $log->errorf('Failed to start loopback listener: %s', $!);
        die "Error: Failed to start loopback listener: $!\n";
    }
    
    my $port = $listener->sockport();
    $log->debugf('Loopback listener started on port %d', $port);
    
    my $redirect_uri = "http://127.0.0.1:$port/";
    
    my $auth = Google::Auth::UserAuthorizer->new(
        client_id    => $client_id,
        scope        => \@DEFAULT_SCOPES,
        token_store  => $token_store,
        callback_uri => $redirect_uri,
    );
    
    my $auth_url = $auth->get_authorization_url();
    
    print "\nGo to the following link in your browser:\n\n    $auth_url\n\n";
    $log->info('Waiting for authorization code...');
    
    my $select = IO::Select->new($listener);
    my $client;
    
    if ($select->can_read(5)) { # 5 seconds timeout for testing/safety
        $client = $listener->accept();
    } else {
        $log->error('Timeout waiting for authorization code');
        close $listener;
        die "Error: Timeout waiting for authorization code.\n";
    }
    
    unless ($client) {
        $log->errorf('Failed to accept connection: %s', $!);
        close $listener;
        die "Error: Failed to accept connection: $!\n";
    }
    
    my $request = '';
    while (<$client>) {
        $request .= $_;
        last if $_ =~ /^\r\n$/; # End of headers
    }
    
    $log->tracef('Received request: %s', $request);
    
    my $code;
    if ($request =~ /^GET\s+([^\s]+)/) {
        my $uri = URI->new("http://127.0.0.1$1");
        my %params = $uri->query_form;
        $code = $params{code};
    }
    
    if ($code) {
        $log->info('Authorization code received successfully');
        
        print $client "HTTP/1.1 200 OK\r\nConnection: close\r\nContent-Type: text/plain\r\n\r\nSuccess! You can close this window.\r\n";
        close $client;
        close $listener;
        
        $log->info('Exchanging code for credentials...');
        
        my $user_id = 'default'; # TODO: use email if available
        
        eval {
            $auth->get_and_store_credentials_from_code(
                user_id  => $user_id,
                code     => $code,
                base_url => $redirect_uri,
            );
        };
        if ($@) {
            $log->errorf('Failed to exchange code: %s', $@);
            die "Error: Failed to exchange code: $@\n";
        }
        
        $log->info('Login successful. Credentials saved.');
        print "Login successful.\n";
    } else {
        $log->error('Failed to get authorization code from callback');
        print $client "HTTP/1.1 400 Bad Request\r\nConnection: close\r\nContent-Type: text/plain\r\n\r\nError: No code received.\r\n";
        close $client;
        close $listener;
        die "Error: Failed to get authorization code.\n";
    }
    
    $log->trace('Leaving do_login');
}

sub do_adc_login {
    $log->info('Command: application-default login initiated');
    $log->trace('Entering do_adc_login');
    
    # TODO: Same flow as login, but save to well-known ADC path in 'authorized_user' format
    
    $log->trace('Leaving do_adc_login with stub completion');
}

sub do_print_access_token {
    $log->info('Command: print-access-token initiated');
    $log->trace('Entering do_print_access_token');
    
    $log->trace('Leaving do_print_access_token with stub completion');
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

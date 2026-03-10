# Copyright 2026 Google LLC
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

package Google::Auth::Transport::LWP;

use strict;
use warnings;

use LWP::UserAgent;
use HTTP::Request;
use Google::Auth::Transport;

our @ISA = qw(Google::Auth::Transport);
our $VERSION = '0.01';

=head1 NAME

Google::Auth::Transport::LWP - HTTP transport using LWP::UserAgent

=head1 SYNOPSIS

    my $transport = Google::Auth::Transport::LWP->new(
        ua => LWP::UserAgent->new( timeout => 10 ),
    );
    my $response = $transport->request(
        url    => 'https://example.com',
        method => 'GET',
    );

=head1 METHODS

=head2 new

Creates a new LWP transport.

Optional: C<ua> (LWP::UserAgent instance).

=cut

sub new {
    my ( $class, %args ) = @_;
    my $ua = $args{ua} || LWP::UserAgent->new( timeout => 120 );
    return bless { ua => $ua }, $class;
}

=head2 request

Makes an HTTP request using LWP::UserAgent.

=cut

sub request {
    my ( $self, %args ) = @_;

    my $url     = $args{url}     || die 'url is required';
    my $method  = $args{method}  || 'GET';
    my $body    = $args{body}    || undef;
    my $headers = $args{headers} || {};
    my $timeout = $args{timeout} || undef;

    my $request = HTTP::Request->new( $method => $url );
    while ( my ( $key, $val ) = each %$headers ) {
        $request->header( $key => $val );
    }
    if ( defined $body ) {
        $request->content($body);
    }

    my $ua = $self->{ua};
    if ( defined $timeout ) {
        # Temporarily set timeout if specified
        my $old_timeout = $ua->timeout;
        $ua->timeout($timeout);
        my $response = $ua->request($request);
        $ua->timeout($old_timeout);
        return Google::Auth::Transport::Response->new($response);
    }
    else {
        my $response = $ua->request($request);
        return Google::Auth::Transport::Response->new($response);
    }
}

package Google::Auth::Transport::Response;

sub new {
    my ( $class, $response ) = @_;
    return bless { response => $response }, $class;
}

sub status {
    my ($self) = @_;
    return $self->{response}->code;
}

sub headers {
    my ($self) = @_;
    # Return a hash ref of headers
    my %headers;
    $self->{response}->headers->scan( sub {
        my ( $key, $val ) = @_;
        $headers{$key} = $val;
    } );
    return \%headers;
}

sub data {
    my ($self) = @_;
    return $self->{response}->decoded_content // $self->{response}->content;
}

1;

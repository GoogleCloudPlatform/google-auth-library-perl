# Copyright 2022 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package Google::Auth;

use 5.006;
use strict;
use warnings;
use XSLoader;
use Log::Any qw($log);

use Google::Auth::EnvironmentVars;
use Google::Auth::DefaultCredentials;

our $VERSION = '0.02';

XSLoader::load( 'Google::Auth', $VERSION );

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Google::Auth;

    my $credentials = Google::Auth->default();
    $credentials->refresh(Google::Auth::Transport::LWP->new());
    print $credentials->token;

=head1 SUBROUTINES/METHODS

=head2 default( %args )

Gets the default credentials for the current environment.

=cut

sub default {
    my ( $self, %args ) = @_;
    return Google::Auth::DefaultCredentials->get_application_default(%args);
}

1;

=head1 AUTHOR

C.J. Collier, C<< <cjac at google.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-google-auth-library-perl at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Google-Auth-Library-Perl>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Google::Auth


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Google-Auth-Library-Perl>

=item * AnnoCPAN: Annotated CPAN documentation

L<annocpan.org/dist/Google-Auth-Library-Perl>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Google-Auth-Library-Perl>

=item * Search CPAN

L<https://metacpan.org/release/Google-Auth-Library-Perl>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2020,2021 Google, LLC

This program is released under the following license: Apache 2.0


=cut


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

package Google::Auth::IDTokens::KeySource::Aggregate;

use strict;
use warnings;

our $VERSION = '0.01';

##
# A key source that aggregates other key sources.
#

sub new {
    my ( $class, $params ) = @_;
    die "sources is a required parameter" unless $params->{sources};
    my $self = bless { sources => [ @{ $params->{sources} } ] }, $class;
    return $self;
}

sub current_keys {
    my ($self) = @_;
    my @all_keys;
    foreach my $source ( @{ $self->{sources} } ) {
        push @all_keys, $source->current_keys;
    }
    return @all_keys;
}

sub refresh_keys {
    my ($self) = @_;
    my @all_keys;
    foreach my $source ( @{ $self->{sources} } ) {
        push @all_keys, $source->refresh_keys;
    }
    return @all_keys;
}

1;

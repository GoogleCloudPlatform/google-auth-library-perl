use strict;
use warnings;

package Protobuf::Arena;

use Scalar::Util qw(blessed);
require XSLoader;

XSLoader::load('Protobuf::Arena', $Protobuf::Arena::VERSION);

sub new {
    my $class = shift;
    return $class->_new_xs();
}

sub DESTROY {
    my $self = shift;
    $self->_destroy_xs();
}

1;

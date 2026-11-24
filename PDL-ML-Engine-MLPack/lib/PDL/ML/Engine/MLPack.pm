package PDL::ML::Engine::MLPack;

use strict;
use warnings;
use Exporter 'import';
use XSLoader;

use PDL::Core;
use PDL::Types;
use PDL::Slices;

our $VERSION = '0.011';

our @EXPORT_OK = qw(
    mlpack_version
    linear_regression
    kmeans
);

XSLoader::load('PDL::ML::Engine::MLPack', $VERSION);

sub linear_regression {
    my ($x, $y, %opts) = @_;
    my $lambda = exists $opts{lambda} ? $opts{lambda} : 0.0;
    return _xs_linear_regression($x->double(), $y->double(), $lambda);
}

sub kmeans {
    my ($x, $k) = @_;
    $k ||= 2;
    return _xs_kmeans($x->double(), $k);
}

1;

__END__

=encoding UTF-8

=head1 NAME

PDL::ML::Engine::MLPack - mlpack C++17 classical machine learning bindings for PDL

=head1 SYNOPSIS

    use PDL;
    use PDL::ML::Engine::MLPack qw(mlpack_version linear_regression kmeans);

    my $X = double([[1, 2], [2, 3], [3, 4], [4, 5]]);
    my $y = double([3, 5, 7, 9]);

    my ($params, $preds) = linear_regression($X, $y, lambda => 0.0);
    my ($assignments, $centroids) = kmeans($X, 2);

=head1 DESCRIPTION

C<PDL::ML::Engine::MLPack> binds L<PDL> ndarrays directly to C<mlpack> (C++17 classical
machine learning library backed by Armadillo) via C99 XS and a C++17 bridge.

=head1 FUNCTIONS

=head2 mlpack_version

=for ref

Return the linked C<mlpack> version string.

=for usage

    $ver = mlpack_version();

=head2 linear_regression

=for ref

Fit an OLS or Ridge (C<lambda>) linear regression model on a 2D PDL feature
matrix and 1D response vector, returning C<($params, $predictions)>.

=for usage

    ($params, $preds) = linear_regression($X, $y, lambda => 0.0);

=head2 kmeans

=for ref

Run K-Means clustering with C<$k> clusters on a 2D PDL matrix, returning
C<($assignments, $centroids)>.

=for usage

    ($assignments, $centroids) = kmeans($X, $k);

=head1 TYPES

Supports standard real numeric PDL types (C<byte>, C<short>, C<long>, C<longlong>, C<float>, C<double> as supported by the underlying library). Complex types (C<cfloat>, C<cdouble>) are not supported by this backend.

=head1 SEE ALSO

L<PDL>, L<PDL::XGBoost>, L<PDL::Torch>, L<PDL::FAISS>, L<PDL::DuckDB>

=head1 AUTHOR

C.J. Collier <cjac@google.com>

=head1 LICENSE

Licensed under the Apache License, Version 2.0.

=cut

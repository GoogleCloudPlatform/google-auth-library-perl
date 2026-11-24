use strict;
use warnings;
use Test::More;
use PDL;

use_ok('PDL::ML::Engine::MLPack', qw(mlpack_version linear_regression kmeans));

my $ver = mlpack_version();
ok(defined $ver && length $ver, 'mlpack_version returns version (' . $ver . ')');

# Linear regression: y = 1 + 2*x1 + 3*x2
my $X = double([
    [1, 0],
    [0, 1],
    [1, 1],
    [2, 1],
    [1, 2],
    [2, 2],
]);
my $y = double([3, 4, 6, 8, 9, 11]);

my ($params, $preds) = linear_regression($X, $y, lambda => 0.0);
my $max_err = abs($preds - $y)->max();
ok($max_err < 1e-6, 'linear regression predictions match exact linear target (max_err=' . $max_err . ')');

# K-Means clustering on two well-separated clusters
my $pts = double([
    [0.0, 0.0],
    [0.1, 0.1],
    [0.0, 0.2],
    [10.0, 10.0],
    [10.1, 10.1],
    [10.0, 10.2],
]);
my ($assign, $centroids) = kmeans($pts, 2);
is($assign->nelem, 6, 'kmeans returned 6 assignments');
is($assign->at(0), $assign->at(1), 'first cluster points share assignment');
is($assign->at(3), $assign->at(4), 'second cluster points share assignment');
isnt($assign->at(0), $assign->at(3), 'two clusters have distinct assignments');

done_testing();

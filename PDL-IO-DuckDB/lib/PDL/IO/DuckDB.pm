package PDL::IO::DuckDB;

use strict;
use warnings;
use Exporter 'import';
use XSLoader;

use PDL::Core;
use PDL::Types;
use PDL::Slices;

our $VERSION = '0.011';

our @EXPORT_OK = qw(
    duckdb_connect
    duckdb_version
);

XSLoader::load('PDL::IO::DuckDB', $VERSION);

sub duckdb_connect {
    my ($path) = @_;
    $path = ':memory:' unless defined $path && length $path;
    return PDL::IO::DuckDB::Connection::_xs_open($path);
}

1;

__END__

=encoding UTF-8

=head1 NAME

PDL::IO::DuckDB - Vectorized SQL/DataFrame engine (DuckDB) bindings for PDL

=head1 SYNOPSIS

    use PDL;
    use PDL::IO::DuckDB qw(connect duckdb_version);

    my $db = connect(':memory:');
    $db->exec('CREATE TABLE t (grp VARCHAR, x DOUBLE)');
    $db->exec("INSERT INTO t VALUES ('a', 1.5), ('a', 2.5), ('b', 10.0)");

    my $cols = $db->query_pdl(
        'SELECT grp, SUM(x) AS total, AVG(x) AS mean FROM t GROUP BY grp ORDER BY grp'
    );
    # $cols->{total} and $cols->{mean} are PDL double ndarrays
    # $cols->{grp} is ['a', 'b']

=head1 DESCRIPTION

C<PDL::IO::DuckDB> binds L<PDL> ndarrays directly to DuckDB's pure-C API
(C<duckdb.h>) via C99 XS, providing a platform-agnostic, vectorized,
multithreaded SQL/DataFrame engine (joins, group-bys, window functions, and
native Parquet/CSV querying) that returns numeric columns directly as PDL
ndarrays.

=head1 FUNCTIONS

=head2 connect

=for ref

Open a DuckDB database (default C<':memory:'>) and return a
C<PDL::IO::DuckDB::Connection>.

=for usage

    $db = connect();
    $db = connect('analytics.duckdb');

=head2 duckdb_version

=for ref

Return the linked DuckDB library version string.

=for usage

    $ver = duckdb_version();

=head1 TYPES

Supports standard real numeric PDL types (C<byte>, C<short>, C<long>, C<longlong>, C<float>, C<double> as supported by the underlying library). Complex types (C<cfloat>, C<cdouble>) are not supported by this backend.

=head1 SEE ALSO

L<PDL>, L<PDL::IO::Arrow>, L<PDL::Torch>, L<PDL::XGBoost>

=head1 AUTHOR

C.J. Collier <cjac@google.com>

=head1 LICENSE

Licensed under the Apache License, Version 2.0.

=cut

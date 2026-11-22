package Module::Starter::Protobuf;

use 5.008003;
use strict;
use warnings;
use parent qw(Module::Starter::Protobuf::Base);

use Path::Tiny qw(path);
use File::Spec;
use Carp qw(croak);

our $VERSION = '0.06';

sub _get_methods_code {
    my ($self, $methods) = @_;
    my $code = '';
    for my $m (@$methods) {
        $code .= sprintf(<<'EOF', $m->{perl_name}, $m->{input_class}, $m->{output_class}, $m->{service_path}, $m->{raw_name}, $m->{service_path}, $m->{raw_name});

sub %s {
    my ($self, %%params) = @_;

    my $request_class = '%s';
    my $request = eval { $request_class->new(\%%params) };
    my $new_err = $@;
    if (!$request) {
        $request = eval { $request_class->new(%%params) };
        $new_err ||= $@;
    }
    if (!$request) {
        croak 'Failed to construct ' . $request_class . ': ' . ($new_err || 'unknown error');
    }

    my $response_class = '%s';
    if (eval { $self->transport->isa('Google::Cloud::REST::Client') }) {
        return $self->transport->call({
            http_method    => 'POST',
            path           => '/%s/%s',
            request        => $request,
            response_class => $response_class,
        });
    }

    my $response = $self->transport->call({
        service        => '%s',
        method         => '%s',
        request        => $request,
        response_class => $response_class,
    });

    return $response;
}
EOF
    }
    return $code;
}

sub _get_client_code {
    my ($self, %args) = @_;
    
    my $module_name = $args{module_name};
    my $bridge_code = $args{bridge_code};
    my $use_statements = $args{use_statements};
    my $version = $args{version};
    my $grpc_target = $args{grpc_target};
    my $methods_code = $args{methods_code};
    my $source_pod_items = $args{source_pod_items};
    my $methods_pod = $args{methods_pod};
    
    my $EQ = '=';

    return sprintf(<<"EOF", $module_name, $bridge_code, $use_statements, $version, $grpc_target, $methods_code, $module_name, $module_name, $module_name, $module_name, $module_name, $module_name, $source_pod_items, $module_name, $methods_pod);
package %s;

use strict;
use warnings;
use Moo;
use Google::gRPC::Client;
use Google::Cloud::REST::Client;
use Google::Auth;
use Carp qw(croak);
%s
%s

our \$VERSION = '%s';

has credentials => ( is => 'ro', required => 0 );
has transport   => ( is => 'rw' );

sub BUILD {
    my (\$self) = \@_;

    my \$auth = \$self->credentials;
    if (!defined \$auth) {
        \$auth = Google::Auth->default();
    } elsif (!eval { \$auth->can('get_token') }) {
        croak 'Invalid credentials object: must implement get_token()';
    }
    my \$token = \$auth->get_token();

    my \$target = '%s';
    my \$t = \$self->transport || 'grpc';

    if (ref(\$t) && eval { \$t->can('call') }) {
        # Already a transport object
    } elsif (lc(\$t) eq 'rest') {
        my \$client = Google::Cloud::REST::Client->new(
            target     => \$target,
            auth_token => \$token,
        );
        \$self->transport(\$client);
    } else {
        my \$client = Google::gRPC::Client->new(
            target     => \$target,
            auth_token => \$token,
        );
        \$self->transport(\$client);
    }
}
%s1; # End of %s

__END__

${EQ}head1 NAME

%s - Client library for Google Cloud Services

${EQ}head1 SYNOPSIS

    use %s;
    use Google::Auth;

    my \$auth = Google::Auth->default();

    # 1. High-performance gRPC Transport (Default)
    my \$grpc_client = %s->new(
        credentials => \$auth,
        transport   => 'grpc', # Optional: 'grpc' is default
    );

    # 2. HTTP/REST Transport
    my \$rest_client = %s->new(
        credentials => \$auth,
        transport   => 'rest',
    );

    # Execute service methods
    my \$res = \$grpc_client->some_method( %%params );

${EQ}head1 DESCRIPTION

C<%s> is an auto-generated client library for Google Cloud Services.

It provides a unified client interface supporting both high-performance HTTP/2 gRPC and HTTP/REST transports, with automatic Google Cloud Application Default Credentials (ADC) resolution and typed Protocol Buffers message handling.

${EQ}head1 SOURCE

Generated from the following Protocol Buffers schemas:

${EQ}over 4

%s

${EQ}back

${EQ}head1 CONSTRUCTOR

${EQ}head2 new

    my \$client = %s->new(
        credentials => \$auth,   # Optional: Google::Auth object (defaults to ADC)
        transport   => 'grpc', # Optional: 'grpc' (default) or 'rest'
    );

${EQ}head1 ATTRIBUTES

${EQ}head2 credentials

Returns or accepts the L<Google::Auth> credentials object.

${EQ}head2 transport

Returns or accepts the active transport object (L<Google::gRPC::Client> or L<Google::Cloud::REST::Client>).

${EQ}head1 METHODS

%s

${EQ}head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

${EQ}cut
EOF
}

sub _get_schema_container_code {
    my ($self, %args) = @_;
    
    my $module_name = $args{module_name};
    my $bridge_code = $args{bridge_code};
    my $use_statements = $args{use_statements};
    my $version = $args{version};
    my $source_pod_items = $args{source_pod_items};
    my $client_modules = $args{client_modules} || [];
    
    my $EQ = '=';
    my $clients_pod = '';
    if (@$client_modules) {
        my $primary_client = $client_modules->[0];
        my $client_items = join '', map { "${EQ}item * L<$_>\n\n" } @$client_modules;
        my $see_also = join ', ', map { "L<$_>" } @$client_modules;
        $clients_pod = <<"POD";
${EQ}head1 SYNOPSIS

    use $primary_client;

    my \$client = $primary_client->new();

${EQ}head1 CLIENTS

This distribution provides the following service client classes:

${EQ}over 4

$client_items${EQ}back

${EQ}head1 SEE ALSO

$see_also

POD
    }

    return sprintf(<<"EOF", $module_name, $bridge_code, $use_statements, $version, $module_name, $module_name, $clients_pod, $source_pod_items);
package %s;

use strict;
use warnings;
%s
%s

our \$VERSION = '%s';
1; # End of %s

__END__

${EQ}head1 NAME

%s - Auto-generated Protocol Buffers schema container

${EQ}head1 DESCRIPTION

This is an auto-generated Protocol Buffers schema container module for Google Cloud Services.

%s${EQ}head1 SOURCE

Generated from the following Protocol Buffers schemas:

${EQ}over 4

%s

${EQ}back

${EQ}head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

${EQ}cut
EOF
}

sub _get_makefile_dependencies {
    my ($self, $has_services) = @_;
    if ($has_services) {
        return <<'EOF';
        'Moo'                     => '0',
        'Log::Any'                => '0',
        'Google::Auth'            => '0.01',
        'Google::gRPC::Client'    => '0.01',
        'Google::Api::Common'     => '0.01',
        'Protobuf'                => '0.01',
EOF
    } else {
        return <<'EOF';
        'Protobuf'                => '0.01',
        'Const::Fast'             => '0',
EOF
    }
}

sub _generate_custom_tests {
    my ($self, $module_name) = @_;
    my @files;
    
    my $service_test = $self->_generate_service_test($module_name);
    push @files, $service_test if $service_test;
    
    my $rest_test = $self->_generate_rest_test($module_name);
    push @files, $rest_test if $rest_test;
    
    return @files;
}

sub _generate_service_test {
    my ($self, $module_name) = @_;

    my $meta = $self->{_services_meta_by_module}->{$module_name} || $self->{_services_meta};
    return unless $meta && @{$meta->{methods}};

    my %output_classes = map { $_->{output_class} => 1 } @{$meta->{methods}};
    my $packages_to_mock = join(' ', sort keys %output_classes);

    my ($service_name) = $module_name =~ /::(\w+)Client$/;
    $service_name ||= 'Default';
    my $test_file = File::Spec->catfile('t', "01-service-$service_name.t");
    my $abs_test_file = File::Spec->catfile($self->{basedir}, $test_file);

    my $test_code = sprintf(<<'EOF', $packages_to_mock, $module_name, $module_name);
use strict;
use warnings;
use Test::More;
use File::Spec;

# A. Mock Google::Auth
package Google::Auth;
BEGIN { $INC{'Google/Auth.pm'} = 1; }
sub default {
    my ($class, %%args) = @_;
    return bless \%%args, 'Google::Auth::MockCredentials';
}
package Google::Auth::MockCredentials;
sub get_token {
    return 'mock-token';
}

# B. Mock Google::gRPC::Client
package Google::gRPC::Client;
BEGIN { $INC{'Google/gRPC/Client.pm'} = 1; }
sub new {
    my $class = shift;
    my $args = ( @_ == 1 && ref($_[0]) eq 'HASH' ) ? $_[0] : { @_ };
    return bless $args, $class;
}
sub call {
    my ($self, $args) = @_;
    if ($self->{mock_call}) {
        return $self->{mock_call}->($args);
    }
    die 'No mock_call handler configured in transport!';
}

# C. Fallback Mocks for External Response Classes
BEGIN {
    for my $pkg (qw( %s )) {
        unless ($pkg->can('new')) {
            no strict 'refs';
            *{"${pkg}::new"} = sub { bless {}, $_[0] };
            $INC{join('/', split('::', $pkg)) . '.pm'} = 1;
        }
    }
}

# D. Main test execution
package main;
use %s;

my $client = %s->new();
ok($client, 'Instantiated generated client');
isa_ok($client->transport, 'Google::gRPC::Client', 'Client transport');
EOF

    for my $m (@{$meta->{methods}}) {
        $test_code .= sprintf(<<'EOF', $m->{perl_name}, $m->{service_path}, $m->{raw_name}, $m->{input_class}, $m->{output_class}, $m->{perl_name}, $m->{output_class});

subtest '%s method' => sub {
    $client->transport->{mock_call} = sub {
        my ($args) = @_;
        is($args->{service}, '%s', 'Correct service path');
        is($args->{method}, '%s', 'Correct RPC method');
        isa_ok($args->{request}, '%s', 'Request object');
        
        my $response = '%s'->new();
        return $response;
    };
    
    my $res = $client->%s();
    ok($res, 'Method returned a response');
    isa_ok($res, '%s', 'Response object class');
    done_testing();
};
EOF
    }

    $test_code .= "\ndone_testing();\n";

    path($abs_test_file)->spew_utf8($test_code);

    return $test_file;
}

sub _generate_rest_test {
    my ($self, $module_name) = @_;

    my $meta = $self->{_services_meta_by_module}->{$module_name} || $self->{_services_meta};
    return unless $meta && @{$meta->{methods}};

    my ($service_name) = $module_name =~ /::(\w+)Client$/;
    $service_name ||= 'Default';
    my $test_file = File::Spec->catfile('t', "02-rest-transport-$service_name.t");
    my $abs_test_file = File::Spec->catfile($self->{basedir}, $test_file);

    my $test_code = sprintf(<<'EOF', $module_name, $module_name);
use strict;
use warnings;
use Test::More;
use Test::LWP::UserAgent;
use HTTP::Response;
use JSON::MaybeXS qw(encode_json);

package Google::Auth;
BEGIN { $INC{'Google/Auth.pm'} = 1; }
sub default { bless {}, 'Google::Auth::Mock' }
package Google::Auth::Mock;
sub get_token { 'mock-token-abc' }

package main;
use Google::Api::Common;
use %s;
use Google::Cloud::REST::Client;

subtest 'Client REST Transport Initialization' => sub {
    my $client = %s->new(
        credentials => bless({}, 'Google::Auth::Mock'),
        transport   => 'rest',
    );

    ok($client, 'Created client with REST transport');
    isa_ok($client->transport, 'Google::Cloud::REST::Client');
};

subtest 'Client REST API Request' => sub {
    my $mock_ua = Test::LWP::UserAgent->new;
    $mock_ua->map_response(
        sub { 1 },
        HTTP::Response->new(
            200, 'OK',
            ['Content-Type' => 'application/json'],
            encode_json({ kind => 'response' })
        )
    );

    my $rest_client = Google::Cloud::REST::Client->new(
        target     => 'test.googleapis.com',
        auth_token => 'mock-token-abc',
        ua         => $mock_ua,
    );

    my $res = $rest_client->request(
        method => 'GET',
        path   => '/v1/test',
    );

    ok($res, 'Received response from mock REST client');
};

done_testing();
EOF

    path($abs_test_file)->spew_utf8($test_code);
    return $test_file;
}

1;

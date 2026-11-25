use strict;
use warnings;
use Test::More;
use Scalar::Util qw(weaken);

use Google::gRPC::Engine::PP;
use Google::gRPC::Framing;
use Google::gRPC::Server;
use Google::gRPC::Status;

my $FLAG_END_STREAM      = 0x1;
my $FRAME_HEADER_BYTES   = 9;
my $LARGE_RESPONSE_BYTES = 200 * 1_024;
my $MAX_PUMP_ROUNDS      = 10_000;
my $TYPE_DATA            = 0;
my $TYPE_HEADERS         = 1;

{
    package DiesOnDecode;
    sub decode { die "bad request bytes\n" }

    package DiesOnEncode;
    sub new    { return bless {}, shift }
    sub encode { die "encode failed\n" }
}

my @requests_seen;
my $server = Google::gRPC::Server->new();
$server->register_service(
    'probe.Svc',
    {
        BadDecode => { handler => sub { push @requests_seen, $_[0]; return '' }, request_class => 'DiesOnDecode' },
        BadEncode => sub { return DiesOnEncode->new() },
        Big       => sub { return 'x' x $LARGE_RESPONSE_BYTES },
        Bytes     => sub { die Google::gRPC::Status->new(code => 3, message => "caf\xc3\xa9") },
        Echo      => sub { push @requests_seen, $_[0]; return 'echo:' . $_[0] },
        MultiLine => sub { die "first line\nsecond line\n" },
        NotFound  => sub { die Google::gRPC::Status->new(code => 5, message => 'missing item') },
        Plain     => sub { die 'plain failure' },
        Spaces    => sub { die Google::gRPC::Status->new(code => 3, message => ' padded ') },
        Wide      => sub { die Google::gRPC::Status->new(code => 3, message => "caf\x{e9} \x{263a}") },
    },
);

# Split raw server output into HTTP/2 frames
sub split_frames {
    my ($buf) = @_;
    my @frames;
    while (length $buf >= $FRAME_HEADER_BYTES) {
        my ($len_hi, $len_lo, $type, $flags, $sid) = unpack 'C n C C N', $buf;
        my $len = ($len_hi << 16) | $len_lo;
        last if length $buf < $FRAME_HEADER_BYTES + $len;
        substr $buf, 0, $FRAME_HEADER_BYTES + $len, '';
        push @frames, { flags => $flags, sid => $sid & 0x7fff_ffff, type => $type };
    }
    return @frames;
}

sub frame_kinds {
    my ($frames) = @_;
    return [
        map {
            ($_->{type} == $TYPE_HEADERS ? 'HEADERS' : $_->{type} == $TYPE_DATA ? 'DATA' : "TYPE$_->{type}")
                . ($_->{flags} & $FLAG_END_STREAM ? '+END_STREAM' : '')
        } @{$frames}
    ];
}

# One in-memory request through Engine::PP
sub round_trip {
    my ($path, $body, $extra_headers) = @_;
    my $session = $server->new_session();
    my %got = (closed => 0, data => '', headers => [], raw => '', trailers => []);
    my $engine = Google::gRPC::Engine::PP->new(
        on_data         => sub { $got{data} .= $_[1]; 1 },
        on_headers      => sub { push @{ $got{headers} }, $_[1]; 1 },
        on_stream_close => sub { $got{closed} = 1 },
        on_trailers     => sub { push @{ $got{trailers} }, $_[1]; 1 },
    );
    $engine->submit_request({
        data    => $body,
        headers => [
            ':authority'   => 'localhost',
            ':method'      => 'POST',
            ':path'        => $path,
            ':scheme'      => 'http',
            'content-type' => 'application/grpc',
            'te'           => 'trailers',
            @{ $extra_headers // [] },
        ],
        end_stream => 1,
    });
    for (1 .. $MAX_PUMP_ROUNDS) {
        my $c2s = $engine->get_output();
        $session->feed($c2s) if length $c2s;
        my $s2c = '';
        while (defined(my $f = $session->next_frame)) { $s2c .= $f }
        $got{raw} .= $s2c;
        $engine->feed_input($s2c) if length $s2c;
        last if $got{closed} || (!length $c2s && !length $s2c);
    }
    $got{frames} = frame_kinds([ grep { $_->{sid} == 1 } split_frames($got{raw}) ]);
    $got{all}    = { map { @{$_} } @{ $got{headers} }, @{ $got{trailers} } };
    return \%got;
}

subtest 'a reply with a message sends grpc-status in trailers' => sub {
    my $got = round_trip('/probe.Svc/Echo', Google::gRPC::Framing::pack_frame('ping'));
    is_deeply($got->{frames}, [qw(HEADERS DATA HEADERS+END_STREAM)], 'HEADERS, DATA, then trailers');
    my %leading = @{ $got->{headers}[0] };
    ok(!exists $leading{'grpc-status'}, 'no grpc-status in the leading headers');
    is($got->{all}{'grpc-status'}, 0, 'grpc-status 0 in trailers');
    my @msgs = Google::gRPC::Framing::unpack_frame(\$got->{data});
    is($msgs[0]{payload}, 'echo:ping', 'message delivered');
};

subtest 'an error reply is Trailers-Only' => sub {
    my $got = round_trip('/probe.Svc/NotFound', Google::gRPC::Framing::pack_frame(''));
    is_deeply($got->{frames}, ['HEADERS+END_STREAM'], 'one HEADERS frame with END_STREAM');
    is($got->{all}{'grpc-status'}, 5, 'grpc-status 5');
};

subtest 'trailers follow a reply held back by flow control' => sub {
    my $got = round_trip('/probe.Svc/Big', Google::gRPC::Framing::pack_frame(''));
    my @msgs = Google::gRPC::Framing::unpack_frame(\$got->{data});
    is(length($msgs[0]{payload} // ''), $LARGE_RESPONSE_BYTES, 'whole message delivered');
    is($got->{all}{'grpc-status'}, 0, 'grpc-status 0 in trailers');
};

subtest 'a session is freed once its caller drops it' => sub {
    my $session = $server->new_session();
    my $weak    = $session;
    weaken($weak);
    undef $session;
    ok(!defined $weak, 'session freed');
};

subtest 'a response encode failure becomes INTERNAL' => sub {
    my @r = eval { $server->handle_unary('/probe.Svc/BadEncode', '', {}) };
    is($@, '', 'handle_unary does not die');
    is($r[0], 13, 'status INTERNAL');
};

subtest 'a request decode failure becomes INTERNAL without calling the handler' => sub {
    @requests_seen = ();
    my $got = round_trip('/probe.Svc/BadDecode', Google::gRPC::Framing::pack_frame('junk'));
    is($got->{all}{'grpc-status'}, 13, 'grpc-status 13');
    is($got->{all}{'grpc-message'}, 'Invalid request payload: bad request bytes', 'decode error in grpc-message')
        or diag $got->{all}{'grpc-message'};
    is(scalar @requests_seen, 0, 'handler not invoked');
};

subtest 'grpc-message is one percent-encoded line without the Perl location' => sub {
    my $multi = round_trip('/probe.Svc/MultiLine', Google::gRPC::Framing::pack_frame(''));
    is($multi->{all}{'grpc-message'}, 'first line', 'first line only');

    my ($code, $msg) = $server->handle_unary('/probe.Svc/Plain', '', {});
    is($code, 2,               'plain die maps to UNKNOWN');
    is($msg,  'plain failure', 'no file and line');

    my $wide = round_trip('/probe.Svc/Wide', Google::gRPC::Framing::pack_frame(''));
    is($wide->{all}{'grpc-message'}, 'caf%C3%A9 %E2%98%BA', 'character string encoded as UTF-8');

    my $bytes = round_trip('/probe.Svc/Bytes', Google::gRPC::Framing::pack_frame(''));
    is($bytes->{all}{'grpc-message'}, 'caf%C3%A9', 'UTF-8 byte string not encoded twice');

    my $spaces = round_trip('/probe.Svc/Spaces', Google::gRPC::Framing::pack_frame(''));
    is($spaces->{all}{'grpc-message'}, '%20padded%20', 'leading and trailing spaces encoded');
};

subtest 'unary request framing is checked before the handler runs' => sub {
    my $compressed   = pack('C N', 1, 4) . 'abcd';
    my $truncated    = pack('C N', 0, 10) . 'abc';
    my $two_messages = Google::gRPC::Framing::pack_frame('one') . Google::gRPC::Framing::pack_frame('two');
    my %cases = (
        'compressed flag with grpc-encoding gzip' => ['/probe.Svc/Echo',    $compressed,   12, ['grpc-encoding' => 'gzip']],
        'compressed flag without grpc-encoding'   => ['/probe.Svc/Echo',    $compressed,   13],
        'empty body'                              => ['/probe.Svc/Echo',    '',            12],
        'truncated message'                       => ['/probe.Svc/Echo',    $truncated,    13],
        'two messages'                            => ['/probe.Svc/Echo',    $two_messages, 12],
        'unknown method'                          => ['/probe.Svc/Missing', $truncated,    12],
    );
    for my $case (sort keys %cases) {
        my ($path, $body, $want, $extra_headers) = @{ $cases{$case} };
        @requests_seen = ();
        my $got = round_trip($path, $body, $extra_headers);
        is($got->{all}{'grpc-status'}, $want, "$case: grpc-status $want");
        is(scalar @requests_seen, 0, "$case: handler not invoked");
    }
};

subtest 'oversized unary request returns RESOURCE_EXHAUSTED without calling the handler' => sub {
    my $small_server = Google::gRPC::Server->new(max_receive_message_length => 16);
    my $called = 0;
    $small_server->register_service('probe.Svc', { Echo => sub { $called++; return $_[0] } });
    my $session = $small_server->new_session();
    my %got = (closed => 0, headers => [], trailers => []);
    my $engine = Google::gRPC::Engine::PP->new(
        on_data         => sub { 1 },
        on_headers      => sub { push @{ $got{headers} }, $_[1]; 1 },
        on_stream_close => sub { $got{closed} = 1 },
        on_trailers     => sub { push @{ $got{trailers} }, $_[1]; 1 },
    );
    $engine->submit_request({
        data    => Google::gRPC::Framing::pack_frame('x' x 64),
        headers => [
            ':authority'   => 'localhost',
            ':method'      => 'POST',
            ':path'        => '/probe.Svc/Echo',
            ':scheme'      => 'http',
            'content-type' => 'application/grpc',
            'te'           => 'trailers',
        ],
        end_stream => 1,
    });
    for (1 .. $MAX_PUMP_ROUNDS) {
        my $c2s = $engine->get_output();
        $session->feed($c2s) if length $c2s;
        my $s2c = '';
        while (defined(my $f = $session->next_frame)) { $s2c .= $f }
        $engine->feed_input($s2c) if length $s2c;
        last if $got{closed} || (!length $c2s && !length $s2c);
    }
    my %all = map { @{$_} } @{ $got{headers} }, @{ $got{trailers} };
    is($all{'grpc-status'}, 8, 'oversized request returns RESOURCE_EXHAUSTED (8)');
    is($called, 0, 'handler not invoked for oversized request');
};

done_testing();

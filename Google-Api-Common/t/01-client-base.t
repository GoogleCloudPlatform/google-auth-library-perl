use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::MockModule;

use Google::Cloud::ClientBase;

{
    package MockJsonPayload;
    sub new { bless {}, shift }
    sub to_hash { return { key => 'value' } }
}

{
    package MockProtoPayload;
    sub new { bless {}, shift }
    sub serialize { return 'serialized_proto_data' }
}

{
    package MockProtoResponse;
    sub parse { my ($class, $data) = @_; return bless { data => $data }, $class }
}

my $client = Google::Cloud::ClientBase->new;

subtest 'Encode Payload' => sub {
    # JSON
    is($client->encode_payload({ key => 'value' }), '{"key":"value"}', 'Encode HASH to JSON');
    is($client->encode_payload(MockJsonPayload->new), '{"key":"value"}', 'Encode Object to JSON via to_hash');
    
    # Protobuf
    is($client->encode_payload(MockProtoPayload->new, 'protobuf'), 'serialized_proto_data', 'Encode Object to Protobuf via serialize');
    
    # Errors
    throws_ok { $client->encode_payload('string', 'protobuf') } qr/Cannot serialize payload to protobuf/, 'Fail to serialize string to protobuf';
    throws_ok { $client->encode_payload({ key => 'value' }, 'unknown') } qr/Unsupported format: unknown/, 'Fail on unknown format';
};

subtest 'Start Stream' => sub {
    my $mock_transport = Test::MockModule->new('Google::Cloud::Transport::Adapter::LWP');
    my $captured_args;
    
    $mock_transport->mock(
        start_stream => sub {
            my ($self, %args) = @_;
            $captured_args = \%args;
            return bless {}, 'MockStream';
        }
    );
    
    my $client = Google::Cloud::ClientBase->new();
    
    my $stream = $client->start_stream(
        url => 'https://example.com/stream',
        method => 'GET',
    );
    
    ok($stream, 'Got stream wrapper');
    isa_ok($stream, 'Google::Cloud::ClientBase::Stream', 'Correct class');
    
    ok($captured_args, 'Transport start_stream called');
    is($captured_args->{url}, 'https://example.com/stream', 'Correct URL passed');
    is($captured_args->{method}, 'GET', 'Correct method passed');
    
    ok($captured_args->{on_data}, 'on_data callback passed');
    ok($captured_args->{on_eof}, 'on_eof callback passed');
    ok($captured_args->{on_error}, 'on_error callback passed');
};

subtest 'Decode Payload' => sub {
    # JSON
    is_deeply($client->decode_payload('{"key":"value"}'), { key => 'value' }, 'Decode JSON to HASH');
    
    # Protobuf
    my $decoded_proto = $client->decode_payload('serialized_proto_data', 'protobuf', 'MockProtoResponse');
    isa_ok($decoded_proto, 'MockProtoResponse', 'Decoded protobuf object');
    is($decoded_proto->{data}, 'serialized_proto_data', 'Correct data in decoded protobuf object');
    
    # JSON with Response Class
    {
        package MockResponseClassHash;
        sub from_hash { my ($class, $hash) = @_; return bless { data => $hash }, $class }
    }
    {
        package MockResponseClassNew;
        sub new { my ($class, %args) = @_; return bless { %args }, $class }
    }
    
    my $decoded_hash_class = $client->decode_payload('{"key":"value"}', 'json', 'MockResponseClassHash');
    isa_ok($decoded_hash_class, 'MockResponseClassHash', 'Decoded JSON to class via from_hash');
    is_deeply($decoded_hash_class->{data}, { key => 'value' }, 'Correct data');
    
    my $decoded_new_class = $client->decode_payload('{"key":"value"}', 'json', 'MockResponseClassNew');
    isa_ok($decoded_new_class, 'MockResponseClassNew', 'Decoded JSON to class via new');
    is($decoded_new_class->{key}, 'value', 'Correct data');
    
    # Errors
    throws_ok { $client->decode_payload('{"invalid":}', 'json') } qr/Error decoding JSON response/, 'Fail on invalid JSON';
    throws_ok { $client->decode_payload('data', 'protobuf', 'NonExistentClass') } qr/Cannot parse protobuf response/, 'Fail to parse protobuf with non-existent class';
    throws_ok { $client->decode_payload('data', 'unknown') } qr/Unsupported format: unknown/, 'Fail on unknown format';
};

done_testing();

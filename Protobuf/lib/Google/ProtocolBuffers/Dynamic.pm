package Google::ProtocolBuffers::Dynamic;

use strict;
use warnings;
use Protobuf;
use Protobuf::DescriptorPool;
use File::Basename qw(dirname);

our $VERSION = '0.08';

sub new {
    my ($class, %opts) = @_;
    my $self = bless {
        include_path => $opts{include_path} // ['.'],
        package_map  => {},
        message_map  => {},
        files        => [],
    }, $class;
    return $self;
}

sub load_file {
    my ($self, $file) = @_;
    push @{ $self->{files} }, $file;

    my $dir = dirname($file);
    my @inc = (@{ $self->{include_path} }, $dir);
    my %seen;
    @inc = grep { !$seen{$_}++ } @inc;

    my @inc_flags = map { "-I$_" } @inc;
    my $cmd = "protoc @inc_flags -o /dev/stdout \"$file\"";
    open my $ph, '-|', $cmd or die "Failed to execute protoc: $!";
    binmode $ph;
    local $/;
    my $bytes = <$ph>;
    close $ph;

    if (defined $bytes && length($bytes) > 0) {
        Protobuf::DescriptorPool->generated_pool->add_serialized_file_descriptor_set($bytes);
        return 1;
    }
    die "protoc failed to generate binary descriptor set for '$file'";
}

sub load_string {
    my ($self, $string, %opts) = @_;
    my $tmp_file = 'tmp_' . time() . '_' . int(rand(100000)) . '.proto';
    open my $fh, '>', $tmp_file or die "Cannot write temp proto file: $!";
    print $fh $string;
    close $fh;

    my $ret = eval { $self->load_file($tmp_file) };
    my $err = $@;
    unlink $tmp_file if -f $tmp_file;
    die $err if $err;
    return $ret;
}

sub resolve_references {
    my ($self) = @_;
    return 1;
}

sub map_package {
    my ($self, $proto_pkg, $perl_pkg, %opts) = @_;
    $self->{package_map}{$proto_pkg} = $perl_pkg;
    return 1;
}

sub map_message {
    my ($self, $proto_msg, $perl_pkg, %opts) = @_;
    $self->{message_map}{$proto_msg} = $perl_pkg;
    return 1;
}

sub _resolve_class {
    my ($self, $type) = @_;
    my $class;
    if (my $mapped = $self->{message_map}{$type}) {
        $class = $mapped;
    }
    else {
        for my $proto_pkg (keys %{ $self->{package_map} }) {
            if ($type =~ /^ \Q$proto_pkg\E \. (.*) $/x) {
                my $rest = $1;
                my $perl_pkg = $self->{package_map}{$proto_pkg};
                $class = "${perl_pkg}::${rest}";
                $class =~ s/\./::/g;
                last;
            }
        }
        if (!$class) {
            $class = $type;
            $class =~ s/\./::/g;
        }
    }

    unless ($class->can('new')) {
        my $pool = Protobuf::DescriptorPool->generated_pool;
        my $mdef = $pool->find_message_by_name($type) // $pool->find_message_by_name(".$type");
        if ($mdef) {
            require Protobuf::ClassGenerator;
            Protobuf::ClassGenerator->generate_for_message($mdef, $class);
        }
    }

    return $class;
}

sub encode {
    my ($self, $type, $data) = @_;
    my $class = $self->_resolve_class($type);
    my $msg = ref $data eq $class ? $data : $class->new(%$data);
    return $msg->encode();
}

sub decode {
    my ($self, $type, $bytes) = @_;
    my $class = $self->_resolve_class($type);
    return $class->decode($bytes);
}

sub encode_json {
    my ($self, $type, $data) = @_;
    my $class = $self->_resolve_class($type);
    my $msg = ref $data eq $class ? $data : $class->new(%$data);
    return $msg->to_json();
}

sub decode_json {
    my ($self, $type, $json_str) = @_;
    my $class = $self->_resolve_class($type);
    return $class->from_json($json_str);
}

1;

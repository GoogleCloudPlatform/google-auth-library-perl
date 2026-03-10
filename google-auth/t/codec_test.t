use strict;
use warnings;
use Test::More;
use Google::Auth::Codec;

subtest 'Base64URL Encoding' => sub {
    is(Google::Auth::Codec::base64url_encode(""), "", "Empty string");
    is(Google::Auth::Codec::base64url_encode("f"), "Zg", "One char");
    is(Google::Auth::Codec::base64url_encode("fo"), "Zm8", "Two chars");
    is(Google::Auth::Codec::base64url_encode("foo"), "Zm9v", "Three chars");
    is(Google::Auth::Codec::base64url_encode("foob"), "Zm9vYg", "Four chars");
    is(Google::Auth::Codec::base64url_encode("fooba"), "Zm9vYmE", "Five chars");
    is(Google::Auth::Codec::base64url_encode("foobar"), "Zm9vYmFy", "Six chars");
    
    # Test with special chars + and / which should become - and _
    # 0xFB 0xFF -> +/8= in standard base64 -> --_ in base64url
    # Wait, let's check:
    # 0xFB -> 111110 11 -> 62 (>) and ...
    # Standard Base64 for 0xFB 0xFF is "+/8="
    # Base64URL for 0xFB 0xFF is "-_8"
    is(Google::Auth::Codec::base64url_encode("\xFB\xFF"), "-_8", "Special chars");
};

subtest 'Base64URL Decoding' => sub {
    is(Google::Auth::Codec::base64url_decode(""), "", "Empty string");
    is(Google::Auth::Codec::base64url_decode("Zg"), "f", "One char");
    is(Google::Auth::Codec::base64url_decode("Zm8"), "fo", "Two chars");
    is(Google::Auth::Codec::base64url_decode("Zm9v"), "foo", "Three chars");
    is(Google::Auth::Codec::base64url_decode("Zm9vYg"), "foob", "Four chars");
    is(Google::Auth::Codec::base64url_decode("Zm9vYmE"), "fooba", "Five chars");
    is(Google::Auth::Codec::base64url_decode("Zm9vYmFy"), "foobar", "Six chars");
    is(Google::Auth::Codec::base64url_decode("-_8"), "\xFB\xFF", "Special chars");
};

subtest 'Roundtrip' => sub {
    my $data = "The quick brown fox jumps over the lazy dog. \x00\xFF\xAA\x55";
    my $encoded = Google::Auth::Codec::base64url_encode($data);
    is(Google::Auth::Codec::base64url_decode($encoded), $data, "Roundtrip matches");
};

done_testing();

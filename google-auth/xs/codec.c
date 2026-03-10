#include "codec.h"
#include <string.h>

static const char base64url_chars[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

static const signed char base64url_decode_table[] = {
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
    -1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, 63,
    -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
};

SV* google_auth_base64url_encode(pTHX_ SV* data_sv) {
    STRLEN len;
    const unsigned char *data = (const unsigned char *)SvPV(data_sv, len);
    STRLEN out_len = (len + 2) / 3 * 4;
    SV* res_sv = newSV(out_len + 1);
    unsigned char *out = (unsigned char *)SvGROW(res_sv, out_len + 1);
    STRLEN i, j;

    for (i = 0, j = 0; i < len; ) {
        unsigned int octet_a = data[i++];
        unsigned int octet_b = (i < len) ? data[i++] : 0;
        unsigned int octet_c = (i < len) ? data[i++] : 0;

        unsigned int triple = (octet_a << 16) | (octet_b << 8) | octet_c;

        out[j++] = base64url_chars[(triple >> 18) & 0x3F];
        out[j++] = base64url_chars[(triple >> 12) & 0x3F];
        out[j++] = base64url_chars[(triple >> 6) & 0x3F];
        out[j++] = base64url_chars[triple & 0x3F];
    }

    /* Adjust length for padding removal */
    if (len % 3 == 1) j -= 2;
    else if (len % 3 == 2) j -= 1;

    out[j] = '\0';
    SvCUR_set(res_sv, j);
    SvPOK_on(res_sv);
    return res_sv;
}

SV* google_auth_base64url_decode(pTHX_ SV* encoded_sv) {
    STRLEN len;
    const char *encoded = SvPV(encoded_sv, len);
    STRLEN out_len = (len + 3) / 4 * 3;
    SV* res_sv = newSV(out_len + 1);
    unsigned char *out = (unsigned char *)SvGROW(res_sv, out_len + 1);
    STRLEN i, j;
    int val = 0, valb = -8;

    for (i = 0, j = 0; i < len; i++) {
        unsigned char c = (unsigned char)encoded[i];
        if (base64url_decode_table[c] == -1) continue;
        val = (val << 6) | base64url_decode_table[c];
        valb += 6;
        if (valb >= 0) {
            out[j++] = (val >> valb) & 0xFF;
            valb -= 8;
        }
    }

    out[j] = '\0';
    SvCUR_set(res_sv, j);
    SvPOK_on(res_sv);
    return res_sv;
}

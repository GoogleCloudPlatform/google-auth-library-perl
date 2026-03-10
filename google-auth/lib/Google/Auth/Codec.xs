#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "xs/codec.h"

MODULE = Google::Auth::Codec  PACKAGE = Google::Auth::Codec

SV *
base64url_encode(SV *data_sv)
    CODE:
        RETVAL = google_auth_base64url_encode(aTHX_ data_sv);
    OUTPUT:
        RETVAL

SV *
base64url_decode(SV *encoded_sv)
    CODE:
        RETVAL = google_auth_base64url_decode(aTHX_ encoded_sv);
    OUTPUT:
        RETVAL

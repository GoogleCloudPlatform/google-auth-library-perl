#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "xs/id_tokens.h"

MODULE = Google::Auth::IDTokens::OpenSSL  PACKAGE = Google::Auth::IDTokens::OpenSSL

SV *
get_pubkey_from_x509(SV *cert_sv)
    CODE:
        RETVAL = google_auth_get_pubkey_from_x509(aTHX_ cert_sv);
    OUTPUT:
        RETVAL

bool
verify_rs256(SV *message_sv, SV *signature_sv, SV *key_der_sv)
    CODE:
        RETVAL = google_auth_verify_rs256(aTHX_ message_sv, signature_sv, key_der_sv);
    OUTPUT:
        RETVAL

SV *
sign_rs256(SV *message_sv, SV *key_pem_sv)
    CODE:
        RETVAL = google_auth_sign_rs256(aTHX_ message_sv, key_pem_sv);
    OUTPUT:
        RETVAL

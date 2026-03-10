#ifndef GOOGLE_AUTH_ID_TOKENS_H
#define GOOGLE_AUTH_ID_TOKENS_H

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <openssl/x509.h>
#include <openssl/pem.h>
#include <openssl/evp.h>

SV* google_auth_get_pubkey_from_x509(pTHX_ SV* cert_sv);
bool google_auth_verify_rs256(pTHX_ SV* message_sv, SV* signature_sv, SV* key_der_sv);
SV* google_auth_sign_rs256(pTHX_ SV* message_sv, SV* key_pem_sv);

#endif /* GOOGLE_AUTH_ID_TOKENS_H */

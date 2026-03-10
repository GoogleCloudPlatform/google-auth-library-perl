#ifndef GOOGLE_AUTH_CODEC_H
#define GOOGLE_AUTH_CODEC_H

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

SV* google_auth_base64url_encode(pTHX_ SV* data_sv);
SV* google_auth_base64url_decode(pTHX_ SV* encoded_sv);

#endif /* GOOGLE_AUTH_CODEC_H */

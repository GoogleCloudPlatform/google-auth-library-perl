#include "id_tokens.h"

SV* google_auth_get_pubkey_from_x509(pTHX_ SV* cert_sv) {
    STRLEN len;
    const unsigned char *p;
    X509 *x509 = NULL;
    BIO *bio = NULL;
    EVP_PKEY *pkey = NULL;
    unsigned char *buf = NULL;
    int buf_len;
    SV *res_sv;

    p = (const unsigned char *)SvPV(cert_sv, len);
    
    /* Try DER first */
    const unsigned char *p_der = p;
    x509 = d2i_X509(NULL, &p_der, (long)len);
    
    if (!x509) {
        /* Try PEM */
        bio = BIO_new_mem_buf((void*)p, (int)len);
        if (bio) {
            x509 = PEM_read_bio_X509(bio, NULL, NULL, NULL);
            BIO_free(bio);
        }
    }
    
    if (!x509) {
        return &PL_sv_undef;
    }
    
    pkey = X509_get_pubkey(x509);
    X509_free(x509);
    
    if (!pkey) {
        return &PL_sv_undef;
    }
    
    /* Convert public key to DER (SubjectPublicKeyInfo) */
    buf_len = i2d_PUBKEY(pkey, &buf);
    EVP_PKEY_free(pkey);
    
    if (buf_len < 0) {
        return &PL_sv_undef;
    }
    
    res_sv = newSVpv((char *)buf, buf_len);
    OPENSSL_free(buf);
    
    return res_sv;
}

bool google_auth_verify_rs256(pTHX_ SV* message_sv, SV* signature_sv, SV* key_der_sv) {
    STRLEN msg_len, sig_len, key_len;
    const unsigned char *msg = (const unsigned char *)SvPV(message_sv, msg_len);
    const unsigned char *sig = (const unsigned char *)SvPV(signature_sv, sig_len);
    const unsigned char *key_der = (const unsigned char *)SvPV(key_der_sv, key_len);
    
    EVP_PKEY *pkey = NULL;
    EVP_MD_CTX *md_ctx = NULL;
    bool result = false;
    
    /* Load public key from DER */
    const unsigned char *p_key = key_der;
    pkey = d2i_PUBKEY(NULL, &p_key, (long)key_len);
    if (!pkey) return false;
    
    md_ctx = EVP_MD_CTX_new();
    if (!md_ctx) {
        EVP_PKEY_free(pkey);
        return false;
    }
    
    if (EVP_DigestVerifyInit(md_ctx, NULL, EVP_sha256(), NULL, pkey) <= 0) goto cleanup;
    if (EVP_DigestVerifyUpdate(md_ctx, msg, msg_len) <= 0) goto cleanup;
    
    if (EVP_DigestVerifyFinal(md_ctx, sig, sig_len) == 1) {
        result = true;
    }

cleanup:
    EVP_MD_CTX_free(md_ctx);
    EVP_PKEY_free(pkey);
    return result;
}

SV* google_auth_sign_rs256(pTHX_ SV* message_sv, SV* key_pem_sv) {
    STRLEN msg_len, key_len;
    const unsigned char *msg = (const unsigned char *)SvPV(message_sv, msg_len);
    const char *key_pem = SvPV(key_pem_sv, key_len);
    
    EVP_PKEY *pkey = NULL;
    EVP_MD_CTX *md_ctx = NULL;
    BIO *bio = NULL;
    unsigned char *sig = NULL;
    size_t sig_len = 0;
    SV* res_sv = &PL_sv_undef;
    
    bio = BIO_new_mem_buf((void*)key_pem, (int)key_len);
    if (!bio) return &PL_sv_undef;
    
    pkey = PEM_read_bio_PrivateKey(bio, NULL, NULL, NULL);
    BIO_free(bio);
    if (!pkey) return &PL_sv_undef;
    
    md_ctx = EVP_MD_CTX_new();
    if (!md_ctx) {
        EVP_PKEY_free(pkey);
        return &PL_sv_undef;
    }
    
    if (EVP_DigestSignInit(md_ctx, NULL, EVP_sha256(), NULL, pkey) <= 0) goto cleanup;
    if (EVP_DigestSignUpdate(md_ctx, msg, msg_len) <= 0) goto cleanup;
    
    /* Determine required signature length */
    if (EVP_DigestSignFinal(md_ctx, NULL, &sig_len) <= 0) goto cleanup;
    
    sig = (unsigned char *)OPENSSL_malloc(sig_len);
    if (!sig) goto cleanup;
    
    if (EVP_DigestSignFinal(md_ctx, sig, &sig_len) <= 0) goto cleanup;
    
    res_sv = newSVpv((char *)sig, sig_len);

cleanup:
    if (sig) OPENSSL_free(sig);
    EVP_MD_CTX_free(md_ctx);
    EVP_PKEY_free(pkey);
    return res_sv;
}

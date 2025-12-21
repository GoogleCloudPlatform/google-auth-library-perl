\
#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "perl/xs/protobuf/obj_cache.h"
#include <string.h>
#include <stdio.h>

// Global hash for object cache
static HV *obj_cache = NULL;

// Custom Magic for tracking val_ref
static int my_val_magic_free(pTHX_ SV *sv, MAGIC *mg);
static MGVTBL my_val_magic_vtbl = {
    0, 0, 0, 0, my_val_magic_free, 0, 0, 0
};
static int my_val_magic_free(pTHX_ SV *sv, MAGIC *mg) {
    (void)mg; // Unused
    fprintf(stderr, "# MY_VAL_MAGIC_FREE called for val_ref SV %p\n", sv);
    return 0;
}

// Custom Magic for tracking key_sv
static int my_key_magic_free(pTHX_ SV *sv, MAGIC *mg);
static MGVTBL my_key_magic_vtbl = {
    0, 0, 0, 0, my_key_magic_free, 0, 0, 0
};
static int my_key_magic_free(pTHX_ SV *sv, MAGIC *mg) {
    (void)mg; // Unused
    fprintf(stderr, "# MY_KEY_MAGIC_FREE called for key_sv SV %p\n", sv);
    return 0;
}

// Initialize the cache
void protobuf_init_obj_cache(pTHX) {
    if (!obj_cache) {
        obj_cache = newHV();
    }
}

// Add an object to the cache
void protobuf_register_object(pTHX_ const char *key, SV *value) {
    if (!obj_cache) protobuf_init_obj_cache(aTHX);

    SV *key_sv = newSVpvn(key, strlen(key));
    fprintf(stderr, "# protobuf_register_object: key_sv: %p, RefC: %d\n", key_sv, SvREFCNT(key_sv));
    sv_magicext(key_sv, NULL, PERL_MAGIC_ext, &my_key_magic_vtbl, 0, 0);
    fprintf(stderr, "# protobuf_register_object: Added key magic to key_sv: %p\n", key_sv);

    SV *val_ref = newRV_inc(value);
    fprintf(stderr, "# protobuf_register_object: val_ref: %p, RefC: %d\n", val_ref, SvREFCNT(val_ref));
    sv_magicext(val_ref, NULL, PERL_MAGIC_ext, &my_val_magic_vtbl, 0, 0);
    fprintf(stderr, "# protobuf_register_object: Added val magic to val_ref: %p\n", val_ref);

    if (!hv_store_ent(obj_cache, key_sv, val_ref, 0)) {
      fprintf(stderr, "# protobuf_register_object: hv_store_ent failed for key_sv: %p\n", key_sv);
      SvREFCNT_dec(val_ref);
      SvREFCNT_dec(key_sv);
    }
    // key_sv is now owned by the hash
}

// Get an object from the cache
SV *protobuf_get_object(pTHX_ const char *key) {
    if (!obj_cache) return NULL;

    SV *key_sv = newSVpvn(key, strlen(key));
    HE *he = hv_fetch_ent(obj_cache, key_sv, 0, 0);
    SvREFCNT_dec(key_sv);

    if (he) {
        SV *val_ref = HeVAL(he);
        if (val_ref && SvROK(val_ref)) {
            SV *cached_sv = SvRV(val_ref);
            if (cached_sv && cached_sv != &PL_sv_undef) {
                return newSVsv(cached_sv);
            }
        }
    }
    return NULL;
}

// Remove an object from the cache
void protobuf_unregister_object(pTHX_ const char *key) {
    if (!obj_cache) return;
    hv_delete(obj_cache, key, strlen(key), G_DISCARD);
}

void protobuf_clear_obj_cache(PerlInterpreter *my_perl) {
    if (obj_cache) {
        fprintf(stderr, "# protobuf_clear_obj_cache: Clearing obj_cache %p\n", obj_cache);
        hv_clear(obj_cache);
        SvREFCNT_dec(obj_cache);
        obj_cache = NULL;
        fprintf(stderr, "# protobuf_clear_obj_cache: Destroyed obj_cache\n");
    }
}

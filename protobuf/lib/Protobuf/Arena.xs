#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "perl/xs/protobuf/arena.h"

MODULE = Protobuf::Arena  PACKAGE = Protobuf::Arena

SV* _new_xs(const char* class) {
    return PerlUpb_Arena_New(aTHX);
}

void _destroy_xs(SV* self) {
    PerlUpb_Arena_Destroy(aTHX_ self);
}

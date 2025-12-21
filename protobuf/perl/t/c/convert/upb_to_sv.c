#include "t/c/upb-perl-test.h"
#include "xs/protobuf.h"
#include "xs/convert/upb_to_sv.h"
#include "t/c/convert/test_util.h"
#include "t/c/convert/types/int32.h"
#include "t/c/convert/types/string.h"
#include "t/c/convert/types/bool.h"
#include "t/c/convert/types/float.h"
#include "t/c/convert/types/double.h"
#include "t/c/convert/types/uint32.h"
#include "t/c/convert/types/int64.h"
#include "t/c/convert/types/uint64.h"
#include "t/c/convert/types/bytes.h"
#include "t/c/convert/types/enum.h"
#include "t/c/convert/types/fixed32.h"
#include "t/c/convert/types/fixed64.h"
#include "t/c/convert/types/sfixed32.h"
#include "t/c/convert/types/sfixed64.h"
#include "t/c/convert/types/sint32.h"
#include "t/c/convert/types/sint64.h"
#include "t/c/convert/types/message.h"
#include "t/c/convert/types/group.h"
#include "upb/reflection/def.h"
#include "upb/mem/arena.h"
#include "upb/wire/types.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <math.h>
#include <stdarg.h>
#include <stdint.h> // For UINT32_MAX, etc.
#include <setjmp.h>
#include <stdbool.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

static int count_test_cases(const upb_to_sv_test_case cases[]) {
    int count = 0;
    if (!cases) return 0;
    for (int i = 0; cases[i].field_name; ++i) {
        count += 2 + cases[i].num_checks; // 2 for Get FieldDef and non-NULL check
    }
    return count;
}

static void run_type_test_cases(pTHX_ SV *arena_sv, const upb_to_sv_test_case cases[], const char *type_name) {
    upb_Arena *arena = PerlUpb_Arena_Get(aTHX_ arena_sv);
    if (!arena) croak("Failed to get arena in run_type_test_cases");
    cdiag("run_type_test_cases for %s", type_name);

    if (!cases) return;

    for (int i = 0; cases[i].field_name; ++i) {
        const upb_to_sv_test_case *tc = &cases[i];
        cdiag("  Testing field: %s (%s)", tc->field_name, tc->test_prefix);

        const upb_FieldDef *f = get_field_def("perltest.TestMessage", tc->field_name);
        if (!f) {
            cdiag("    Failed to get FieldDef for %s", tc->field_name);
            ok(f, sdiagnostic("Get FieldDef for %s", tc->field_name));
            continue;
        }
        ok(f, sdiagnostic("Get FieldDef for %s", tc->field_name));

        is(upb_FieldDef_Type(f), tc->expected_type, sdiagnostic("%s: type check", tc->test_prefix));

        upb_MessageValue val;
        memset(&val, 0, sizeof(val));

        cdiag("    Calling set_val for %s", tc->field_name);
        tc->set_val(&val, arena);

        cdiag("    Calling PerlUpb_UpbToSv for %s", tc->field_name);
        SV *sv = PerlUpb_UpbToSv(aTHX_ &val, f, arena_sv);
        ok(sv != NULL, sdiagnostic("%s: PerlUpb_UpbToSv returned non-NULL", tc->test_prefix));

        if (!sv) {
             cdiag("    PerlUpb_UpbToSv returned NULL");
             continue;
        }

        cdiag("    Calling check_sv for %s", tc->field_name);
        tc->check_sv(aTHX_ sv, tc->test_prefix);
        SvREFCNT_dec(sv);
        cdiag("  Finished field: %s", tc->field_name);
    }
    cdiag("Finished run_type_test_cases for %s", type_name);
}

static void test_upb_to_sv_edge_cases(pTHX_ SV *arena_sv) {
    cdiag("test_upb_to_sv_edge_cases");
    const upb_FieldDef *f_int32 = get_field_def("perltest.TestMessage", "value");
    ok(f_int32, "Edge/int32: Got FieldDef for value");
    if (!f_int32) return;

    // Test 1: Null val - should return undef, not croak
    cdiag("  Edge Test 1: Null val to int32");
    SV *sv = sv_2mortal(PerlUpb_UpbToSv(aTHX_ NULL, f_int32, NULL));
    ok(sv && !SvOK(sv), "Edge/int32: Null val returns undef SV");

    // Test 2: Null FieldDef - should croak
    cdiag("  Edge Test 2: Null FieldDef");
    dJMPENV;
    int ret;
    JMPENV_PUSH(ret);
    if (ret == 0) {
        upb_MessageValue upb_val;
        memset(&upb_val, 0, sizeof(upb_val));
        cdiag("    Calling PerlUpb_UpbToSv with NULL FieldDef");
        SV *sv_croak = PerlUpb_UpbToSv(aTHX_ &upb_val, NULL, NULL);
        cdiag("    PerlUpb_UpbToSv returned (SHOULD NOT HAPPEN)");
        JMPENV_POP;
        fail("Edge/NULLEnv: NULL FieldDef did not croak");
        if (sv_croak) SvREFCNT_dec(sv_croak);
    } else {
        cdiag("    Croak caught for NULL FieldDef");
        JMPENV_POP;
        ok(1, "Edge/NULLEnv: NULL FieldDef croaked");
        if (ERRSV && SvTRUE(ERRSV)) {
            sv_setsv_mg(ERRSV, &PL_sv_undef);
        }
    }
    cdiag("Finished test_upb_to_sv_edge_cases");
}

int main(int argc, char** argv) {
    PERL_SYS_INIT(&argc, &argv);
    cdiag("main: PERL_SYS_INIT done");
    PerlInterpreter *my_perl = perl_alloc();
    cdiag("main: perl_alloc done");
    perl_construct(my_perl);
    cdiag("main: perl_construct done");
    PL_exit_flags |= PERL_EXIT_DESTRUCT_END;

    char *embedding[] = { (char*)"", (char*)"-e", (char*)"0", NULL };
    perl_parse(my_perl, NULL, 3, embedding, NULL);
    cdiag("main: perl_parse done");
    perl_run(my_perl);
    cdiag("main: perl_run done");

    int exit_status = 0;
    { // Add scope for mortal cleanup
        dSP;
        ENTER;
        SAVETMPS;

        SV *arena_sv = PerlUpb_Arena_New(aTHX);
        cdiag("main: PerlUpb_Arena_New done");
        upb_Arena *arena = PerlUpb_Arena_Get(aTHX_ arena_sv);

        cdiag("main: Loading test descriptors...");
        if (!load_test_descriptors(aTHX_ arena)) {
            cdiag("main: FAILED to load test descriptors");
            exit_status = 1;
        } else {
            cdiag("main: Test descriptors loaded successfully");
            int total_tests = 1; // For "Descriptors loaded"
            total_tests += count_test_cases(int32_upb_to_sv_test_cases);
            total_tests += count_test_cases(string_upb_to_sv_test_cases);
            total_tests += count_test_cases(bool_upb_to_sv_test_cases);
            total_tests += count_test_cases(float_upb_to_sv_test_cases);
            total_tests += count_test_cases(double_upb_to_sv_test_cases);
            total_tests += count_test_cases(uint32_upb_to_sv_test_cases);
            total_tests += count_test_cases(int64_upb_to_sv_test_cases);
            total_tests += count_test_cases(uint64_upb_to_sv_test_cases);
            total_tests += count_test_cases(bytes_upb_to_sv_test_cases);
            total_tests += count_test_cases(enum_upb_to_sv_test_cases);
            total_tests += count_test_cases(fixed32_upb_to_sv_test_cases);
            total_tests += count_test_cases(fixed64_upb_to_sv_test_cases);
            total_tests += count_test_cases(sfixed32_upb_to_sv_test_cases);
            total_tests += count_test_cases(sfixed64_upb_to_sv_test_cases);
            total_tests += count_test_cases(sint32_upb_to_sv_test_cases);
            total_tests += count_test_cases(sint64_upb_to_sv_test_cases);
            total_tests += count_test_cases(message_upb_to_sv_test_cases);
            total_tests += count_test_cases(group_upb_to_sv_test_cases);
            total_tests += 3; // For edge cases

            plan(total_tests);
            ok(1, "Descriptors loaded");

            run_type_test_cases(aTHX_ arena_sv, int32_upb_to_sv_test_cases, "int32");
            run_type_test_cases(aTHX_ arena_sv, string_upb_to_sv_test_cases, "string");
            run_type_test_cases(aTHX_ arena_sv, bool_upb_to_sv_test_cases, "bool");
            run_type_test_cases(aTHX_ arena_sv, float_upb_to_sv_test_cases, "float");
            run_type_test_cases(aTHX_ arena_sv, double_upb_to_sv_test_cases, "double");
            run_type_test_cases(aTHX_ arena_sv, uint32_upb_to_sv_test_cases, "uint32");
            run_type_test_cases(aTHX_ arena_sv, int64_upb_to_sv_test_cases, "int64");
            run_type_test_cases(aTHX_ arena_sv, uint64_upb_to_sv_test_cases, "uint64");
            run_type_test_cases(aTHX_ arena_sv, bytes_upb_to_sv_test_cases, "bytes");
            run_type_test_cases(aTHX_ arena_sv, enum_upb_to_sv_test_cases, "enum");
            run_type_test_cases(aTHX_ arena_sv, fixed32_upb_to_sv_test_cases, "fixed32");
            run_type_test_cases(aTHX_ arena_sv, fixed64_upb_to_sv_test_cases, "fixed64");
            run_type_test_cases(aTHX_ arena_sv, sfixed32_upb_to_sv_test_cases, "sfixed32");
            run_type_test_cases(aTHX_ arena_sv, sfixed64_upb_to_sv_test_cases, "sfixed64");
            run_type_test_cases(aTHX_ arena_sv, sint32_upb_to_sv_test_cases, "sint32");
            run_type_test_cases(aTHX_ arena_sv, sint64_upb_to_sv_test_cases, "sint64");
            run_type_test_cases(aTHX_ arena_sv, message_upb_to_sv_test_cases, "message");
            run_type_test_cases(aTHX_ arena_sv, group_upb_to_sv_test_cases, "group");

            test_upb_to_sv_edge_cases(aTHX_ arena_sv);
        }

        cdiag("main: Cleaning up upb resources");
        upb_DefPool_Free(test_pool);
        PerlUpb_Arena_Free(aTHX_ arena_sv);
        SvREFCNT_dec(arena_sv);

        FREETMPS;
        LEAVE;
        cdiag("main: Scope left");
    }

    cdiag("main: Cleaning up Perl");
    perl_destruct(my_perl);
    perl_free(my_perl);
    PERL_SYS_TERM();
    cdiag("main: Exiting with status %d", exit_status);
    return exit_status;
}
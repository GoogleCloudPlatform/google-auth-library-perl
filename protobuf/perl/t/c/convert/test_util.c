#include "test_util.h"
#include "google/protobuf/descriptor.upb.h"
#include "upb/base/string_view.h"
#include <stdio.h>
#include "t/c/upb-perl-test.h" // Include for cdiag

upb_DefPool *test_pool = NULL;

bool load_test_descriptors(pTHX_ upb_Arena *arena) {
    cdiag("load_test_descriptors: Loading from t/data/test_descriptor.bin");
    FILE *f = fopen("t/data/test_descriptor.bin", "rb");
    if (!f) {
        perror("Failed to open t/data/test_descriptor.bin");
        return false;
    }
    fseek(f, 0, SEEK_END);
    size_t len = ftell(f);
    fseek(f, 0, SEEK_SET);
    char *data = (char *)upb_Arena_Malloc(arena, len);
    if (!data) { cdiag("Failed upb_Arena_Malloc"); fclose(f); return false; }
    if (fread(data, 1, len, f) != len) {
        cdiag("Failed fread");
        fclose(f);
        return false;
    }
    fclose(f);
    cdiag("load_test_descriptors: File read, %zu bytes", len);

    google_protobuf_FileDescriptorSet *set = google_protobuf_FileDescriptorSet_parse(data, len, arena);
    if (!set) {
        cdiag("Failed to parse FileDescriptorSet");
        return false;
    }

    if (test_pool) { upb_DefPool_Free(test_pool); }
    test_pool = upb_DefPool_New();
    if (!test_pool) { cdiag("Failed upb_DefPool_New"); return false; }

    upb_Status status;
    size_t n;
    const google_protobuf_FileDescriptorProto *const * files = google_protobuf_FileDescriptorSet_file(set, &n);
     cdiag("load_test_descriptors: Found %zu files in descriptor set", n);
    for (size_t i = 0; i < n; i++) {
        upb_Status_Clear(&status);
        upb_StringView file_name = google_protobuf_FileDescriptorProto_name(files[i]);
        cdiag("  Adding file: %.*s", (int)file_name.size, file_name.data);
        if (!upb_DefPool_AddFile(test_pool, files[i], &status)) {
            cdiag("  Failed to add file to DefPool: %s", upb_Status_ErrorMessage(&status));
            return false;
        }
    }

    const upb_MessageDef *mdef = upb_DefPool_FindMessageByName(test_pool, "perltest.TestMessage");
    if (!mdef) {
        cdiag("FAILURE: MessageDef perltest.TestMessage not found after loading");
        return false;
    }
    cdiag("SUCCESS: Found perltest.TestMessage");

    return true;
}

const upb_FieldDef* get_field_def(const char *msg_name, const char *field_name) {
    const upb_MessageDef *mdef = upb_DefPool_FindMessageByName(test_pool, msg_name);
    if (!mdef) {
        cdiag("get_field_def: MessageDef %s not found", msg_name);
        return NULL;
    }
    const upb_FieldDef *fdef = upb_MessageDef_FindFieldByName(mdef, field_name);
    if (!fdef) {
        cdiag("get_field_def: FieldDef %s not found in %s", field_name, msg_name);
    }
    return fdef;
}
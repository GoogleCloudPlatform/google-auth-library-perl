#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "pdl.h"
#include "pdlcore.h"

#include "mlpack_bridge.h"

static Core* PDL;
static SV*   CoreSV;

MODULE = PDL::ML::Engine::MLPack    PACKAGE = PDL::ML::Engine::MLPack

PROTOTYPES: DISABLE

BOOT:
{
    CoreSV = get_sv("PDL::SHARE", FALSE);
    if (!CoreSV) {
        croak("PDL::ML::Engine::MLPack requires PDL::Core to be loaded first");
    }
    PDL = INT2PTR(Core*, SvIV(CoreSV));
    if (PDL->Version != PDL_CORE_VERSION) {
        croak("PDL::ML::Engine::MLPack needs to be recompiled against the newly installed PDL");
    }
}

const char*
mlpack_version()
CODE:
    RETVAL = pdl_mlpack_version();
OUTPUT:
    RETVAL

void
_xs_linear_regression(SV* x_sv, SV* y_sv, double lambda)
PPCODE:
    pdl* px = PDL->SvPDLV(x_sv);
    pdl* py = PDL->SvPDLV(y_sv);
    PDL->make_physical(px);
    PDL->make_physdims(px);
    PDL->make_physical(py);
    PDL->make_physdims(py);

    if (px->datatype != PDL_D || px->ndims != 2) {
        croak("linear_regression requires a 2D double (n_features x n_samples) ndarray");
    }
    if (py->datatype != PDL_D || py->ndims != 1) {
        croak("linear_regression requires a 1D double (n_samples) response ndarray");
    }

    int64_t n_features = (int64_t)px->dims[0];
    int64_t n_samples  = (int64_t)px->dims[1];

    pdl* params_pdl = PDL->pdlnew();
    params_pdl->datatype = PDL_D;
    PDL_Indx pdims[1] = { (PDL_Indx)(n_features + 1) };
    PDL->setdims(params_pdl, pdims, 1);
    PDL->allocdata(params_pdl);

    pdl* preds_pdl = PDL->pdlnew();
    preds_pdl->datatype = PDL_D;
    PDL_Indx ydims[1] = { (PDL_Indx)n_samples };
    PDL->setdims(preds_pdl, ydims, 1);
    PDL->allocdata(preds_pdl);

    if (!pdl_mlpack_linear_regression(
            (const double*)px->data, n_features, n_samples,
            (const double*)py->data, lambda,
            (double*)params_pdl->data, (double*)preds_pdl->data)) {
        croak("PDL::ML::Engine::MLPack linear_regression failed: %s", pdl_mlpack_last_error());
    }

    SV* sv_params = sv_2mortal(newSV(0));
    SV* sv_preds  = sv_2mortal(newSV(0));
    PDL->SetSV_PDL(sv_params, params_pdl);
    PDL->SetSV_PDL(sv_preds, preds_pdl);

    EXTEND(SP, 2);
    PUSHs(sv_params);
    PUSHs(sv_preds);

void
_xs_kmeans(SV* x_sv, int k)
PPCODE:
    pdl* px = PDL->SvPDLV(x_sv);
    PDL->make_physical(px);
    PDL->make_physdims(px);

    if (px->datatype != PDL_D || px->ndims != 2) {
        croak("kmeans requires a 2D double (n_features x n_samples) ndarray");
    }

    int64_t n_features = (int64_t)px->dims[0];
    int64_t n_samples  = (int64_t)px->dims[1];

    pdl* assign_pdl = PDL->pdlnew();
    assign_pdl->datatype = PDL_LL;
    PDL_Indx adims[1] = { (PDL_Indx)n_samples };
    PDL->setdims(assign_pdl, adims, 1);
    PDL->allocdata(assign_pdl);

    pdl* cent_pdl = PDL->pdlnew();
    cent_pdl->datatype = PDL_D;
    PDL_Indx cdims[2] = { (PDL_Indx)n_features, (PDL_Indx)k };
    PDL->setdims(cent_pdl, cdims, 2);
    PDL->allocdata(cent_pdl);

    if (!pdl_mlpack_kmeans(
            (const double*)px->data, n_features, n_samples, (int64_t)k,
            (int64_t*)assign_pdl->data, (double*)cent_pdl->data)) {
        croak("PDL::ML::Engine::MLPack kmeans failed: %s", pdl_mlpack_last_error());
    }

    SV* sv_a = sv_2mortal(newSV(0));
    SV* sv_c = sv_2mortal(newSV(0));
    PDL->SetSV_PDL(sv_a, assign_pdl);
    PDL->SetSV_PDL(sv_c, cent_pdl);

    EXTEND(SP, 2);
    PUSHs(sv_a);
    PUSHs(sv_c);

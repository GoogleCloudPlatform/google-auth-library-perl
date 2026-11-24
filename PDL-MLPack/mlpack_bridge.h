#ifndef PDL_MLPACK_BRIDGE_H
#define PDL_MLPACK_BRIDGE_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

const char* pdl_mlpack_last_error(void);
const char* pdl_mlpack_version(void);

/* X is column-major (n_features x n_samples) double, y is (n_samples) double.
 * out_params has length (n_features + 1) [intercept, coef_1, ...].
 * out_preds has length (n_samples). */
int pdl_mlpack_linear_regression(
    const double* x_data,
    int64_t       n_features,
    int64_t       n_samples,
    const double* y_data,
    double        lambda,
    double*       out_params,
    double*       out_preds
);

/* X is column-major (n_features x n_samples) double.
 * out_assignments has length (n_samples) int64_t.
 * out_centroids has length (n_features * k) double (n_features x k). */
int pdl_mlpack_kmeans(
    const double* x_data,
    int64_t       n_features,
    int64_t       n_samples,
    int64_t       k,
    int64_t*      out_assignments,
    double*       out_centroids
);

#ifdef __cplusplus
}
#endif

#endif /* PDL_MLPACK_BRIDGE_H */

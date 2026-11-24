#include "mlpack_bridge.h"

#define MLPACK_CORE_STB_STB_HPP
#define MLPACK_CORE_DATA_LOAD_IMAGE_HPP
#define MLPACK_CORE_DATA_SAVE_IMAGE_HPP
#define MLPACK_CORE_DATA_IMAGE_RESIZE_CROP_HPP
#include <mlpack.hpp>

#include <cstring>
#include <exception>
#include <string>

static thread_local std::string g_last_error;
static std::string g_version_str;

extern "C" const char* pdl_mlpack_last_error(void) {
    return g_last_error.c_str();
}

extern "C" const char* pdl_mlpack_version(void) {
    if (g_version_str.empty()) {
        g_version_str = mlpack::util::GetVersion();
    }
    return g_version_str.c_str();
}

extern "C" int pdl_mlpack_linear_regression(
    const double* x_data,
    int64_t       n_features,
    int64_t       n_samples,
    const double* y_data,
    double        lambda,
    double*       out_params,
    double*       out_preds
) {
    try {
        arma::mat X(const_cast<double*>(x_data), n_features, n_samples, false, true);
        arma::rowvec y(const_cast<double*>(y_data), n_samples, false, true);

        mlpack::LinearRegression lr(X, y, lambda);
        const arma::vec& params = lr.Parameters();
        std::memcpy(out_params, params.memptr(), static_cast<size_t>(params.n_elem) * sizeof(double));

        arma::rowvec preds;
        lr.Predict(X, preds);
        std::memcpy(out_preds, preds.memptr(), static_cast<size_t>(preds.n_elem) * sizeof(double));
        return 1;
    } catch (const std::exception& e) {
        g_last_error = e.what();
        return 0;
    }
}

extern "C" int pdl_mlpack_kmeans(
    const double* x_data,
    int64_t       n_features,
    int64_t       n_samples,
    int64_t       k,
    int64_t*      out_assignments,
    double*       out_centroids
) {
    try {
        arma::mat X(const_cast<double*>(x_data), n_features, n_samples, false, true);
        arma::Row<size_t> assignments;
        arma::mat centroids;

        mlpack::KMeans<> km;
        km.Cluster(X, static_cast<size_t>(k), assignments, centroids);

        for (int64_t i = 0; i < n_samples; ++i) {
            out_assignments[i] = static_cast<int64_t>(assignments[i]);
        }
        std::memcpy(out_centroids, centroids.memptr(), static_cast<size_t>(n_features * k) * sizeof(double));
        return 1;
    } catch (const std::exception& e) {
        g_last_error = e.what();
        return 0;
    }
}

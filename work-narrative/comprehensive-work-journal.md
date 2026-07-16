# Comprehensive Work Journal

## Session Log: 2026-07-16 (2026-W29)

- **CI Matrix Alignment & Container Execution:**
  - Standardized all 7 matrix build targets (Linux Debian 12, Ubuntu 24.04, Rocky Linux 9, Perl 5.40, and Windows Perl 5.38, 5.40, 5.42) to run exclusively inside isolated Docker container images across both local git hooks (`.git/hooks/pre-push`) and GitHub Actions (`.github/workflows/ci.yml`).
  - Upgraded Windows runner VM shape to `e2-standard-8` (8 vCPUs / 32 GB RAM), reducing wallclock build runtime from 7m 30s to **2m 24s** (3.1x speedup).
  - Cleaned up obsolete dependencies: removed `Crypt::OpenSSL::X509` (replaced by XS/C OpenSSL implementation), removed unused `Test::Deep` and `Test::MockModule` imports, and populated missing prerequisites in `Module-Starter-Protobuf/Makefile.PL`.
  - Documented mandatory containerized execution rule and AI assistant skill maintenance corrections in [`work-narrative/2026-W29/20260716T062400-ci-matrix-and-container-alignment.md`](file:///usr/local/google/home/cjac/notes/cjac-promo-2026/google-auth-library-perl/work-narrative/2026-W29/20260716T062400-ci-matrix-and-container-alignment.md).

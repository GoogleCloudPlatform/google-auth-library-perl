# Comprehensive Work Journal

## Session Log: 2026-07-16 (2026-W29)

- **CI Matrix Alignment & Container Execution:**
  - Standardized all 7 matrix build targets (Linux Debian 12, Ubuntu 24.04, Rocky Linux 9, Perl 5.40, and Windows Perl 5.38, 5.40, 5.42) to run exclusively inside isolated Docker container images across both local git hooks (`.git/hooks/pre-push`) and GitHub Actions (`.github/workflows/ci.yml`).
  - Upgraded Windows runner VM shape to `e2-standard-8` (8 vCPUs / 32 GB RAM), reducing wallclock build runtime from 7m 30s to **2m 24s** (3.1x speedup).
  - Cleaned up obsolete dependencies: removed `Crypt::OpenSSL::X509` (replaced by XS/C OpenSSL implementation), removed unused `Test::Deep` and `Test::MockModule` imports, and populated missing prerequisites in `Module-Starter-Protobuf/Makefile.PL`.
  - Documented mandatory containerized execution rule and AI assistant skill maintenance corrections in [`work-narrative/2026-W29/20260716T062400-ci-matrix-and-container-alignment.md`](file:///usr/local/google/home/cjac/notes/cjac-promo-2026/google-auth-library-perl/work-narrative/2026-W29/20260716T062400-ci-matrix-and-container-alignment.md).

- **Windows Container Matrix Resolution & POSIX Dependency Scoping:**
  - Unignored `Protobuf/t/data/*.bin` in `.gitignore` to ensure test descriptor binaries stream cleanly in `git archive HEAD`.
  - Added `$^X -S cpanm --installdeps .` to `.github/scripts/build_and_test.pl` to guarantee clean dependency installation across sub-distributions on MSWin32.
  - Scoped optional POSIX-only test modules (`Coro`, `Test::Valgrind`) in `Protobuf/cpanfile` under `if ($^O ne 'MSWin32')` so Windows builds never attempt building assembly stack-switching modules.
  - Pre-installed static analysis tools (`Perl::Tidy`, `PPI`, `Perl::Critic`, `Test::Perl::Critic`) across all 7 Dockerfiles in `ci/`.
  - Added `workflow_dispatch:` trigger to `.github/workflows/ci.yml` for on-demand manual CI triggers.
  - Documented full narrative in [`work-narrative/2026-W29/20260716T192235-windows-ci-matrix-and-dep-isolation.md`](file:///usr/local/google/home/cjac/notes/cjac-promo-2026/google-auth-library-perl/work-narrative/2026-W29/20260716T192235-windows-ci-matrix-and-dep-isolation.md) and technical findings in [`project/findings/2026-W29/20260716T192235-windows-cpanm-and-posix-dep-scoping.md`](file:///usr/local/google/home/cjac/notes/cjac-promo-2026/google-auth-library-perl/project/findings/2026-W29/20260716T192235-windows-cpanm-and-posix-dep-scoping.md).

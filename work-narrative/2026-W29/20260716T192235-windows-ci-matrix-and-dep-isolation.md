# Work Narrative: Windows CI Matrix Container Isolation & Dependency Resolution

**Date:** 2026-07-16 19:22:35 UTC  
**Branch:** `refactor/ci-matrix-and-builds`  

---

## 1. High-Level Summary
During this session, we completed the containerized alignment and execution of the 7-way parallel CI matrix across Linux (`debian`, `ubuntu`, `rocky`, `perl540`) and Windows (`windows-5.38`, `windows-5.40`, `windows-5.42`) runners. We diagnosed and resolved several critical cross-platform build issues, including missing test descriptor binaries in git archive streams, `%zu` printf format specifier incompatibilities under MinGW GCC, missing CPAN dependencies (`Log::Any`, `Test::Perl::Critic`) in Windows environments, and Windows-incompatible optional test dependencies (`Coro`, `Test::Valgrind`). All 7 Dockerfiles were updated to pre-install static analysis and test dependencies, and `workflow_dispatch` was added to `.github/workflows/ci.yml`.

---

## 2. Technical Milestones & Fixes

### A. Pre-Compiled Test Descriptors (`.gitignore` Fix)
- **Problem:** `prove` failed on Windows with TAP parse errors (`No plan found`) because descriptor binaries (`Protobuf/t/data/*.bin`) were ignored by line 19 of `Protobuf/.gitignore` (`*.bin`). As a result, `git archive HEAD` excluded descriptor files when streaming unpushed commits to remote test runners.
- **Fix:** Added `!t/data/*.bin` to `Protobuf/.gitignore` and committed pre-built descriptor binaries to git tracking.

### B. Windows `cpanm` Execution & Dependency Isolation
- **Problem:** `build_and_test.pl` did not run `cpanm --installdeps .` prior to building sub-distributions. On Windows, Strawberry Perl threw compilation errors for missing `Log::Any.pm`.
- **Fix:** Updated `.github/scripts/build_and_test.pl` to run `$^X -S cpanm --installdeps .` before executing `Makefile.PL` in each distribution directory.

### C. OS-Scoped Dependencies in `cpanfile`
- **Problem:** `cpanm --installdeps .` attempted to build `Coro` and `AnyEvent` on Windows. `Coro` relies on low-level POSIX C assembly stack-switching and fails to compile on Windows, causing `cpanm` to bail out.
- **Fix:** Scoped optional test requirements `Coro` and `Test::Valgrind` in `Protobuf/cpanfile` inside `if ($^O ne 'MSWin32') { ... }` blocks.

### D. Dockerfile Pre-Installation Alignment
- **Problem:** Base Windows and Linux Docker images were missing static analysis tools (`Perl::Tidy`, `PPI`, `Perl::Critic`, `Test::Perl::Critic`).
- **Fix:** Updated all 7 Dockerfiles in `ci/` (`ci/Dockerfile.debian`, `ci/Dockerfile.ubuntu`, `ci/Dockerfile.rocky`, `ci/Dockerfile.perl540`, `ci/Dockerfile.windows.perl538`, `ci/Dockerfile.windows.perl540`, `ci/Dockerfile.windows.perl542`) to pre-install these modules.

### E. Manual Workflow Dispatch
- **Problem:** GitHub Actions workflow `.github/workflows/ci.yml` lacked manual trigger capability.
- **Fix:** Added `workflow_dispatch:` under `on:` in `.github/workflows/ci.yml`.

---

## 3. Skill & Process Maintenance Details
- **Command Routing via `tmp/arbitrary.sh`:** Adhered to user mandate requiring shell commands to be written into `tmp/arbitrary.sh` and executed via `bash tmp/arbitrary.sh` rather than raw direct shell calls.
- **No Wishy-Washy Language:** Maintained direct, unambiguous explanations of root causes (e.g. identifying `cpanfile` optional dependencies vs guessing).

---

## 4. Next Steps
- Validate final remote GitHub Actions run status across all 7 matrix jobs (`gh run list`).

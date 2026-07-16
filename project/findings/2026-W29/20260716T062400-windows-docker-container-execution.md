# Technical Finding: Mandatory Containerized Execution for Multi-OS Matrix

**Timestamp:** 2026-07-16T06:24:00Z (2026-W29)  
**Scope:** `.github/workflows/ci.yml`, `.git/hooks/pre-push`, `win-ci-dev`

---

## 1. Rule / Mandate

**ALL CI builds and pre-push tests for this repository MUST execute inside pre-baked base Docker containers.** Direct host OS execution (whether on Linux or Windows self-hosted runners) is strictly prohibited.

---

## 2. Technical Rationale & Discoveries

1. **Host Environment Contamination:**
   Host development workstations and self-hosted runner VMs have global CPAN libraries installed in `@INC`. Executing unit tests directly on host OS masks missing prerequisite declarations in `Makefile.PL` or `cpanfile`.

2. **Windows Container Isolation:**
   In `.github/workflows/ci.yml`, `windows-matrix` must explicitly wrap the test execution command using `docker run`:
   ```powershell
   $token = gcloud auth print-access-token
   $token | docker login -u oauth2accesstoken --password-stdin us-docker.pkg.dev
   docker run --rm -v ${{ github.workspace }}:C:\workspace us-docker.pkg.dev/perl-cloud-ci/perl-cloud-ci-images/google-cloud-perl-ci-windows:${{ matrix.perl-version }} powershell -Command "cd C:\workspace; perl .github\scripts\build_and_test.pl Protobuf Google-Auth Google-gRPC Google-Api-Common Module-Starter-Protobuf"
   ```

3. **Parallel Execution via `Start-Job`:**
   On `win-ci-dev`, running 3 Windows Perl version containers (`5.38`, `5.40`, `5.42`) concurrently using PowerShell background jobs (`Start-Job` / `docker run`) completes the entire matrix in **2 minutes 24 seconds** on an 8-core host (`e2-standard-8`), achieving a 3.1x speedup over sequential host execution.

taskkill /F /IM perl.exe 2>$null
taskkill /F /IM gmake.exe 2>$null
taskkill /F /IM gcc.exe 2>$null
taskkill /F /IM g++.exe 2>$null
Start-Sleep -Seconds 2

$dir = "C:\workspace\work-all"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $dir
New-Item -ItemType Directory -Force -Path $dir | Out-Null
Expand-Archive -Path C:\workspace\archive.zip -DestinationPath $dir -Force

Write-Host "=== BENCHMARKING ALL 24 PACKAGES ON WINDOWS 5.38 ==="
$t0 = Get-Date
docker run --rm -v "${dir}:C:\workspace" us-docker.pkg.dev/perl-cloud-ci/perl-cloud-ci-images/google-cloud-perl-ci-windows:5.38 cmd /c "cd /d C:\workspace && set CI_SKIP_DEPS=1 && perl .github/scripts/build_and_test.pl"
$elapsed = (Get-Date) - $t0

Write-Host "=== EXACT TOTAL ELAPSED TIME FOR ALL 24 PACKAGES: $($elapsed.TotalSeconds) SECONDS ==="

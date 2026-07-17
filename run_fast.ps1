$targets = @('5.38', '5.40', '5.42')
$startTime = Get-Date

foreach ($v in $targets) {
    $dir = "C:\workspace\work-$v"
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $dir
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Expand-Archive -Path C:\workspace\archive.zip -DestinationPath $dir -Force
    Write-Host "=== Running fast-cycle windows-$v ==="
    $t0 = Get-Date
    docker run --rm -v "${dir}:C:\workspace" us-docker.pkg.dev/perl-cloud-ci/perl-cloud-ci-images/google-cloud-perl-ci-windows:${v} cmd /c "cd /d C:\workspace && set CI_SKIP_DEPS=1 && perl .github/scripts/build_and_test.pl"
    $elapsed = (Get-Date) - $t0
    Write-Host "=== windows-$v took $($elapsed.TotalSeconds) seconds ==="
}

$totalElapsed = (Get-Date) - $startTime
Write-Host "=== TOTAL FAST-CYCLE WINDOWS BUILD TIME: $($totalElapsed.TotalSeconds) seconds ==="

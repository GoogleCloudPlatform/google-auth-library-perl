param(
    [Parameter(Mandatory=$true)]
    [string]$Token
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$Url = 'https://github.com/LLC-Technologies-Collier/google-auth-library-perl'
$ZipPath = 'C:\runner-pkg.zip'

if (-not (Test-Path $ZipPath)) {
    Write-Host "Downloading Actions Runner package via curl..."
    curl.exe -sSfL -o $ZipPath "https://github.com/actions/runner/releases/download/v2.335.1/actions-runner-win-x64-2.335.1.zip"
}

1..3 | ForEach-Object {
    $i = $_
    $dir = "C:\actions-runner-$i"
    $runnerName = "win-ci-dev-$i"
    $svcName = "actions.runner.LLC-Technologies-Collier-google-auth-library-perl.$runnerName"
    
    Write-Host "Configuring Runner $i at $dir..."
    if (Get-Service $svcName -ErrorAction SilentlyContinue) {
        Stop-Service $svcName -ErrorAction SilentlyContinue
        sc.exe delete $svcName
    }
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $dir
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Expand-Archive -Path $ZipPath -DestinationPath $dir -Force
    Set-Location $dir
    .\config.cmd --url $Url --token $Token --name $runnerName --labels "self-hosted,Windows,X64" --unattended --replace --runasservice
}

Get-Service | Where-Object { $_.Name -like '*actions.runner*' }

# Provisioning Script for Windows CI Runner (win-ci-dev)
# Run inside Windows PowerShell (As Administrator)

$ErrorActionPreference = 'Stop'

Write-Host "1. Installing Chocolatey Package Manager..."
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

Write-Host "2. Installing Core Dependencies (Strawberry Perl, protoc, OpenSSL, Git)..."
choco install strawberryperl protoc openssl git --no-progress -y

Write-Host "3. Setting System Environment Variables..."
[Environment]::SetEnvironmentVariable("PATH", "C:\Strawberry\perl\site\bin;C:\Strawberry\perl\bin;C:\Strawberry\c\bin;C:\Program Files\Git\cmd;" + [Environment]::GetEnvironmentVariable("PATH", "Machine"), "Machine")
[Environment]::SetEnvironmentVariable("PACKAGE_STASH_IMPLEMENTATION", "PP", "Machine")
[Environment]::SetEnvironmentVariable("MOO_XS_DISABLE", "1", "Machine")
[Environment]::SetEnvironmentVariable("TEMPLATE_STASH", "Template::Stash", "Machine")

Write-Host "4. Pre-installing Perl CPAN Module Dependencies..."
cpanm Log::Any Test::MockModule Const::Fast Sub::Identify SUPER Guard Env::Sanctify Test::Valgrind Template Moo Package::Stash

Write-Host "5. Setting up GitHub Actions Self-Hosted Runner..."
if (-not (Test-Path "C:\actions-runner")) {
    New-Item -ItemType Directory -Path "C:\actions-runner" | Out-Null
}

Set-Location "C:\actions-runner"

if (-not (Test-Path "C:\actions-runner\config.cmd")) {
    Write-Host "Downloading Actions Runner package..."
    Invoke-WebRequest -Uri "https://github.com/actions/runner/releases/download/v2.322.0/actions-runner-win-x64-2.322.0.zip" -OutFile "runner.zip"
    Expand-Archive -Path "runner.zip" -DestinationPath "C:\actions-runner" -Force
    Remove-Item "runner.zip"
}

Write-Host "Automated runner setup complete. Register using config.cmd --url <REPO_URL> --token <REGISTRATION_TOKEN>."

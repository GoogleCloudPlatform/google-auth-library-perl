# Provisioning Script for Windows CI Container Host (win-ci-dev)
# Run inside Windows PowerShell (As Administrator)

$ErrorActionPreference = 'Stop'

Write-Host "1. Installing Chocolatey Package Manager..."
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

Write-Host "2. Installing Windows Containers Feature, Docker Engine, and Git..."
if ((Get-WindowsFeature Containers).InstallState -ne 'Installed') {
    Install-WindowsFeature -Name Containers
}
if (-not (Get-Service docker -ErrorAction SilentlyContinue)) {
    Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
    Install-Package -ProviderName DockerMsftProvider -Name Docker -Force
    Start-Service docker
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    choco install git --no-progress -y
}

Write-Host "2b. Configuring Windows Defender Exclusions for Docker and Runners..."
Add-MpPreference -ExclusionPath 'C:\ProgramData\docker', 'C:\actions-runner-1', 'C:\actions-runner-2', 'C:\actions-runner-3' -ErrorAction SilentlyContinue

Write-Host "3. Building Windows Base Docker Container Images in Parallel..."
$versions = @('5.38', '5.40', '5.42')
$versions | ForEach-Object {
    Start-Job -ScriptBlock {
        param($v)
        $tag = $v -replace '\.',''
        docker build -t "us-docker.pkg.dev/perl-cloud-ci/perl-cloud-ci-images/google-cloud-perl-ci-windows:$v" -f "ci/Dockerfile.windows.perl$tag" .
    } -ArgumentList $_
} | Wait-Job | Receive-Job

Write-Host "3b. Pushing Windows Base Docker Container Images to Google Artifact Registry..."
$versions | ForEach-Object {
    docker push "us-docker.pkg.dev/perl-cloud-ci/perl-cloud-ci-images/google-cloud-perl-ci-windows:$_"
}

Write-Host "4. Setting up 3 Multi-Runner Instances for Parallel Container Execution..."
1..3 | ForEach-Object {
    $rDir = "C:\actions-runner-$_"
    if (-not (Test-Path $rDir)) {
        New-Item -ItemType Directory -Path $rDir | Out-Null
    }
    if (-not (Test-Path "$rDir\config.cmd")) {
        Write-Host "Downloading Actions Runner package into $rDir..."
        Invoke-WebRequest -Uri "https://github.com/actions/runner/releases/download/v2.322.0/actions-runner-win-x64-2.322.0.zip" -OutFile "$rDir\runner.zip"
        Expand-Archive -Path "$rDir\runner.zip" -DestinationPath $rDir -Force
        Remove-Item "$rDir\runner.zip"
    }
}

Write-Host "Container host runner setup complete."

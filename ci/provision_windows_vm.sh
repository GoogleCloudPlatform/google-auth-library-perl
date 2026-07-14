#!/bin/bash
# Infrastructure-as-Code (IaC) Script for Provisioning Windows CI VM on GCP
# Target Project: cjac-2025-01 / perl-cloud-ci

set -euo pipefail

PROJECT_ID="${1:-cjac-2025-01}"
ZONE="${2:-us-central1-a}"
REGION="${ZONE%-*}"
VM_NAME="win-ci-dev"
NETWORK="default"

echo "=== [1/4] Provisioning Private Windows GCE VM: ${VM_NAME} ==="
gcloud compute instances create "${VM_NAME}" \
    --project="${PROJECT_ID}" \
    --zone="${ZONE}" \
    --machine-type="e2-standard-4" \
    --image-family="windows-2022" \
    --image-project="windows-cloud" \
    --boot-disk-size="100GB" \
    --boot-disk-type="pd-ssd" \
    --network="${NETWORK}" \
    --no-address

echo "=== [2/4] Provisioning Cloud NAT Gateway for Egress ==="
if ! gcloud compute routers describe "nat-router-${NETWORK}" --project="${PROJECT_ID}" --region="${REGION}" &>/dev/null; then
    gcloud compute routers create "nat-router-${NETWORK}" \
        --project="${PROJECT_ID}" \
        --network="${NETWORK}" \
        --region="${REGION}"
fi

if ! gcloud compute routers nats describe "nat-config-${NETWORK}" --project="${PROJECT_ID}" --router="nat-router-${NETWORK}" --region="${REGION}" &>/dev/null; then
    gcloud compute routers nats create "nat-config-${NETWORK}" \
        --project="${PROJECT_ID}" \
        --router="nat-router-${NETWORK}" \
        --region="${REGION}" \
        --auto-allocate-nat-external-ips \
        --nat-all-subnet-ip-ranges
fi

echo "=== [3/4] Creating Egress Firewall Rule for HTTPS ==="
if ! gcloud compute firewall-rules describe "allow-egress-443" --project="${PROJECT_ID}" &>/dev/null; then
    gcloud compute firewall-rules create allow-egress-443 \
        --project="${PROJECT_ID}" \
        --network="${NETWORK}" \
        --direction=EGRESS \
        --action=ALLOW \
        --rules=tcp:443,tcp:80 \
        --destination-ranges=0.0.0.0/0
fi

echo "=== [4/4] Copying Provisioning Script & Executing Remote Provisioning ==="
gcloud compute scp ci/setup_windows_runner.ps1 "${VM_NAME}":C:/setup_windows_runner.ps1 \
    --project="${PROJECT_ID}" \
    --zone="${ZONE}" \
    --tunnel-through-iap

gcloud compute ssh "${VM_NAME}" \
    --project="${PROJECT_ID}" \
    --zone="${ZONE}" \
    --tunnel-through-iap \
    --command="powershell -NoProfile -ExecutionPolicy Bypass -File C:\setup_windows_runner.ps1"

echo "=== Windows CI Host Provisioning Complete! ==="

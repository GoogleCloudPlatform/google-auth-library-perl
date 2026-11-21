#!/usr/bin/env bash

set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"

declare -A PIDS
declare -A LOGS

IMAGES=(
    "us-docker.pkg.dev/perl-cloud-ci/perl-cloud-ci-images/google-cloud-perl-ci-debian:latest|debian|ci/Dockerfile.debian"
    "us-docker.pkg.dev/perl-cloud-ci/perl-cloud-ci-images/google-cloud-perl-ci-ubuntu:latest|ubuntu|ci/Dockerfile.ubuntu"
    "us-docker.pkg.dev/perl-cloud-ci/perl-cloud-ci-images/google-cloud-perl-ci-rocky:latest|rocky|ci/Dockerfile.rocky"
    "us-docker.pkg.dev/perl-cloud-ci/perl-cloud-ci-images/google-cloud-perl-ci-540:latest|perl540|ci/Dockerfile.perl540"
)

LOG_DIR="$REPO_ROOT/tmp/build-logs"
mkdir -p "$LOG_DIR"

for entry in "${IMAGES[@]}"; do
    img="${entry%%|*}"
    rest="${entry#*|}"
    name="${rest%%|*}"
    dockerfile="${rest#*|}"
    
    log_file="$LOG_DIR/build-$name.log"
    
    echo "--> [BUILDING] $name using $dockerfile -> Log: $log_file"
    podman build -t "$img" -f "$REPO_ROOT/$dockerfile" "$REPO_ROOT" > "$log_file" 2>&1 &
    pid=$!
    PIDS["$name"]=$pid
    LOGS["$name"]=$log_file
done

echo "=== Waiting for builds to complete ==="
FAIL=0
for name in "${!PIDS[@]}"; do
    pid=${PIDS["$name"]}
    wait $pid || {
        echo "--> [FAIL] $name failed! See ${LOGS[$name]}"
        FAIL=1
    }
done

if [ $FAIL -eq 0 ]; then
    echo "=== All builds completed successfully! ==="
else
    echo "=== Some builds failed! ==="
    exit 1
fi

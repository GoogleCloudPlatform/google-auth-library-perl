#!/usr/bin/env bash
set -euo pipefail

if [ "${AUTHENTICATED:-false}" = "true" ]; then
  docker run --rm --pull=always \
    -v "${GITHUB_WORKSPACE}:/workspace:cached" \
    -w /workspace \
    "${MATRIX_IMAGE}" \
    bash -lc "cp -a /workspace /tmp/work && cd /tmp/work && perl .github/scripts/build_and_test.pl Protobuf Google-Auth Google-gRPC Google-Api-Common Module-Starter-Protobuf"
else
  if [ -n "${SETUP_CMD:-}" ]; then
    eval "${SETUP_CMD}"
  fi
  eval "$(perl -I"$HOME/perl5/lib/perl5" -Mlocal::lib 2>/dev/null || true)"
  cp -a "${GITHUB_WORKSPACE}" /tmp/work && cd /tmp/work && perl .github/scripts/build_and_test.pl Protobuf Google-Auth Google-gRPC Google-Api-Common Module-Starter-Protobuf
fi

#!/bin/bash
set -euo pipefail
IMAGE="$1"
docker pull "$IMAGE"

set +e
docker run --rm "$IMAGE" yum -q --security --secseverity=Important check-update
result="$?"
set -e

echo "update_result=${result}" | tee >> "${GITHUB_OUTPUT}"
#!/bin/bash
set -euo pipefail
IMAGE="$1"
docker pull "$IMAGE"

set +e
docker run --rm "$IMAGE" yum -q --security --secseverity=important,critical check-update
result="$?"
set -e

echo "result: $result"
echo "::set-output name=update_result::$result"
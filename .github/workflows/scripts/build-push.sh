#!/bin/bash
set -euo pipefail

IMAGE_NAME="$1"
DOCKER_FILE="$2"
DOCKER_PATH=$(dirname "$DOCKER_FILE")

RELEASE_VERSION="$(date +%Y%m%d)-${GITHUB_RUN_NUMBER}"
DOCKER_REPO="$(echo "docker.pkg.github.com/${GITHUB_REPOSITORY}/${IMAGE_NAME}" | tr '[:upper:]' '[:lower:]')"
DOCKER_TAG_RELEASE="${DOCKER_REPO}:${RELEASE_VERSION}"
DOCKER_TAG_LATEST="${DOCKER_REPO}:latest"
echo "build ${DOCKER_TAG_RELEASE}"

docker build --pull \
  --file "$DOCKER_FILE" \
  --label build.version="$RELEASE_VERSION" --label build.sha="$GITHUB_SHA" --label build.trigger="$GITHUB_EVENT_NAME" \
  --tag "${DOCKER_TAG_RELEASE}" --tag "${DOCKER_TAG_LATEST}" "$DOCKER_PATH"

docker push "${DOCKER_TAG_RELEASE}"
docker push "${DOCKER_TAG_LATEST}"

# update existing pinned versions
SEARCH="$(echo $DOCKER_REPO | sed 's#/#\\/#g')"
find . -iname 'Dockerfile*' -exec perl -i -pe "s/${SEARCH}:(?!latest)[-_\w]+/${SEARCH}:${RELEASE_VERSION}/" {} \;
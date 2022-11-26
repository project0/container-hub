#!/bin/bash
set -ex
version="${1-${GO_VERSION}}"

curl -Ls https://go.dev/dl/go${version}.linux-amd64.tar.gz -o /tmp/go.tar.gz
tar -C /usr/local -xzf /tmp/go.tar.gz
rm -rf /tmp/go.tar.gz

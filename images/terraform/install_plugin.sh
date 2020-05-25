#!/bin/bash
owner="$1"
package="$2"
version="$3"
goinstall "${owner}/${package}@${version}"

# add missing v prefix
if [[ $version != v* ]]; then
  version="v${version}"
fi

mkdir -p /build/plugins
mv -v "${GOPATH}/bin/${package}" "/build/plugins/${package}_${version}"
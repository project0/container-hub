#!/bin/bash
set -euo pipefail

gomplate --input-dir /_etc/ --output-dir /etc

exec "$@"

#!/bin/sh
set -e

gomplate --input-dir /_etc/ --output-dir /etc

mkdir -p /var/lib/clamav
chmod 0755 /var/lib/clamav
chown -R "${CLAMAV_USER}:${CLAMAV_USER}" /var/lib/clamav

# Bootstrap the database if clamav is running for the first time
[ -f /var/lib/main.cvd ] || freshclam --daemon-notify=disabled

# Run the update daemon
freshclam -d

exec "$@"

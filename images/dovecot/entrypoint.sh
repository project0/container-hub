#!/bin/bash
set -euo pipefail

if ! [ -s /dhparam/dh.pem ]; then
  openssl dhparam "${DOVECOT_DHPARAM_BIT}" > /dhparam/dh.pem
fi

mkdir -p /mail /var/lib/dovecot /etc/dovecot/sieve /var/log/dovecot
gomplate --input-dir /_etc/ --output-dir /etc
chown -R mail:mail /mail /var/lib/dovecot /etc/dovecot/sieve /var/log/dovecot
exec "$@"

FROM ghcr.io/project0/container-hub/base:20250305-195

# renovate: datasource=github-releases depName=roundcube/roundcubemail
ARG ROUNDCUBEMAIL_VERSION=1.6.10
LABEL version="${ROUNDCUBEMAIL_VERSION}"

# public key
COPY roundcube-pubkey.asc /tmp/roundcube-pubkey.asc
# copy config templates and entrypoint
COPY --chmod=0755 entrypoint.sh /entrypoint.sh
COPY etc/ /_etc

## install lamp and roundcube
RUN dnf module install -y php:8.1 && \
    yum -y install \
      php php-pdo php-fpm php-mysqlnd php-json php-gd php-xml php-intl php-mbstring php-ldap \
      composer \
      httpd \
      tar \
    && mkdir -p /run/php-fpm \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && gpg --import /tmp/roundcube-pubkey.asc \
    && curl -o roundcubemail.tar.gz -fSL https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBEMAIL_VERSION}/roundcubemail-${ROUNDCUBEMAIL_VERSION}-complete.tar.gz \
	&& curl -o roundcubemail.tar.gz.asc -fSL https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBEMAIL_VERSION}/roundcubemail-${ROUNDCUBEMAIL_VERSION}-complete.tar.gz.asc \
    && gpg --batch --verify roundcubemail.tar.gz.asc roundcubemail.tar.gz \
    && tar -xf roundcubemail.tar.gz -C /usr/src/ \
    && mv /usr/src/roundcubemail-${ROUNDCUBEMAIL_VERSION} /usr/src/roundcubemail \
    && (cd /usr/src/roundcubemail && COMPOSER_ALLOW_SUPERUSER=1 composer -n require roundcube/larry) \
    && ln -sf /usr/src/roundcubemail/public_html /var/www/html/public_html \
    && ln -sf /etc/roundcube/config.inc.php /usr/src/roundcubemail/config/config.inc.php \
    && for i in /usr/src/roundcubemail/plugins/*; do test -f "${i}/config.inc.php.dist" && cp -v "${i}/config.inc.php.dist" "${i}/config.inc.php"; done \
    && chown -R apache:apache /usr/src/roundcubemail \
    && rm -rf roundcubemail.tar.gz roundcubemail.tar.gz.asc /usr/src/roundcubemail/installer ~/.gnup

ENV ROUNDCUBEMAIL_DB_DIR=/data/db \
    ROUNDCUBE_TEMP_DIR=/data/tmp \
    ROUNDCUBE_ENIGMA_PGP_HOMEDIR=

# expose these volumes
VOLUME [ "/data/db", "/data/tmp" ]

# https://httpd.apache.org/docs/2.4/stopping.html#gracefulstop
STOPSIGNAL SIGWINCH

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "httpd", "-DFOREGROUND"]

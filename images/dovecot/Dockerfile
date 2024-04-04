FROM ghcr.io/project0/container-hub/base-devel:20240404-100 AS builder

ENV DESTDIR /build
WORKDIR /src

# renovate: datasource=github-tags depName=dovecot/core versioning=loose
ARG DOVECOT_VERSION=2.3.21 \
    DOVECOT_REPO=https://github.com/dovecot/core.git

# renovate: datasource=github-tags depName=dovecot/pigeonhole versioning=loose
ARG PIGENHOLE_VERSION=0.5.21 \
    PIGENHOLE_REPO=https://github.com/dovecot/pigeonhole.git

# renovate: datasource=github-tags depName=xapian/xapian
ARG XAPIAN_VERSION=v1.4.25 \
    XAPIAN_REPO=https://github.com/xapian/xapian.git

# renovate: datasource=github-releases depName=grosjo/fts-xapian
ARG FTS_XAPIAN_VERSION=1.7.9 \
    FTS_XAPIAN_REPO=https://github.com/grosjo/fts-xapian.git

RUN yum -y install wget which tcl openssl-devel mysql-devel postgresql-devel openldap-devel krb5-devel pam-devel \
      sqlite-devel bzip2-devel zlib-devel lz4-devel xz-devel libsodium-devel \
      lua-devel clucene-core-devel expat-devel libexttextcat-devel libcap-devel libicu-devel gettext-devel

RUN git get-release "${DOVECOT_REPO}" "${DOVECOT_VERSION}" /src/dovecot \
    && cd /src/dovecot \
    && ./autogen.sh \
    && PANDOC=false \
      ./configure --prefix=/usr --libdir=/usr/lib64 --sysconfdir=/etc --with-rundir=/run/dovecot \
      --enable-maintainer-mode --disable-static --without-docs \
      --with-ssl=openssl --with-shared-libs \
      --with-zlib --with-bzlib --with-lzma --with-lz4 \
      --with-libcap --with-lua \
      --with-lucene --with-solr --with-textcat --with-icu \
      --with-sql --with-ldap --with-pgsql --with-mysql --with-sqlite \
      --with-shadow --with-pam --with-gssapi \
    && make -j$(nproc) \
    && make install && DESTDIR="" make install

RUN git get-release "${PIGENHOLE_REPO}" "${PIGENHOLE_VERSION}" /src/pigenhole \
    && cd /src/pigenhole \
    && ./autogen.sh \
    && ./configure --prefix=/usr --libdir=/usr/lib64 --with-unfinished-features --disable-static --without-docs \
      --with-managesieve --with-ldap=yes --with-dovecot=/src/dovecot/ \
    && make -j$(nproc) \
    && make install

# FTS plugins
RUN git get-release "${XAPIAN_REPO}" "${XAPIAN_VERSION}" /src/xapian \
    && cd /src/xapian \
    && touch xapian-applications/omega/.nobootstrap  xapian-bindings/.nobootstrap xapian-data/.nobootstrap xapian-maintainer-tools/.nobootstrap \
    && ./bootstrap --download-tools=never \
    && ./configure --prefix=/usr --libdir=/usr/lib64  --disable-documentation \
    && make -j$(nproc) \
    && DESTDIR= make install \
    && make install

RUN git get-release "${FTS_XAPIAN_REPO}" "${FTS_XAPIAN_VERSION}" /src/fts-xapian \
    && cd /src/fts-xapian \
    && autoreconf -vif \
    && ./configure --prefix=/usr --libdir=/usr/lib64 --with-dovecot=/src/dovecot \
    && make -j$(nproc) \
    && make install

# cleanup
RUN cp -aRv /usr/lib64/mysql/* "${DESTDIR}/usr/lib64/" \
    && find /build -iname '*.la' -delete -o -iname *'*.a' -delete \
    && rm -rf /build/usr/include

FROM ghcr.io/project0/container-hub/base:20240404-100

ENV DOVECOT_DHPARAM_BIT=4096

COPY --from=builder /build /
COPY entrypoint.sh /entrypoint.sh

RUN yum install -y openssl openssl-libs postgresql-libs sqlite openldap libsodium \
      krb5-libs pam bzip2 zlib lz4 libicu libexttextcat libcap clucene-core expat \
    && yum -y update \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && install -d -o mail -g mail -m 0755 /var/lib/dovecot /mail /dhparam \
    && echo "dovecot:x:101:101:mail user:/var/lib/dovecot:/sbin/nologin" >> /etc/passwd \
    && echo "dovecot:x:101:" >> /etc/group \
    && echo "dovenull:x:102:102:mail user:/var/lib/dovecot:/sbin/nologin" >> /etc/passwd \
    && echo "dovenull:x:102:" >> /etc/group \
    && chmod a+x /entrypoint.sh \
    && mkdir -p /_etc /etc/dovecot \
    && touch /etc/dovecot/dovecot.conf \
    && dovecot --version \
    && set -x && test -z "$(ldd /usr/lib64/dovecot/*.so | grep "not found")"

VOLUME [ "/mail", "/dhparam", "/var/lib/dovecot"]
# tini is required to handle clean shutdown of dovecot
ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]
CMD [ "dovecot", "-c", "/etc/dovecot/dovecot.conf", "-F" ]

FROM ghcr.io/project0/container-hub/base-devel:20241119-163 AS builder

ENV DESTDIR=/build
WORKDIR /src

# renovate: datasource=github-releases depName=rspamd/rspamd versioning=conan
ARG RSPAMD_VERSION=3.10.2
ARG RSPAMD_REPO=https://github.com/rspamd/rspamd.git
LABEL version="${RSPAMD_VERSION}"

RUN yum -y install cmake3 libevent-devel glib2-devel pcre2-devel libcurl-devel libsodium-devel ragel-devel luajit-devel \
       file-devel sqlite-devel libicu-devel openssl-devel hyperscan-devel jemalloc-devel libcurl-devel libarchive-devel

RUN git get-release "${RSPAMD_REPO}" "${RSPAMD_VERSION}*" rspamd \
    && mkdir -p build \
    && cd build \
    && cmake3 -DCMAKE_INSTALL_PREFIX=/usr -DRSPAMD_USER='rspamd' \
      -DCONFDIR=/etc/rspamd -DRUNDIR=/run/rspamd -DLOGDIR=/var/log/rspamd -DDBDIR=/var/lib/rspamd \
      -DENABLE_ANALYZER=ON \
      -DENABLE_HYPERSCAN=ON \
      -DENABLE_JEMALLOC=ON \
      -DENABLE_OPTIMIZATION=ON \
      -DENABLE_PCRE2=ON \
      -DENABLE_REDIRECTOR=ON \
      -DENABLE_URL_INCLUDE=ON \
      ../rspamd \
    && make -j$(nproc) \
    && make install

# cleanup
RUN find /build -iname '*.la' -delete -o -iname *'*.a' -delete \
    && rm -rf /build/usr/include

FROM ghcr.io/project0/container-hub/base:20241119-163

ENV RSPAMD_USER=rspamd

# install libary deps and user
RUN yum -y install openssl-libs libevent libicu pcre2 libsodium ragel luajit hyperscan jemalloc libarchive \
    && yum -y update \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && echo "${RSPAMD_USER}:x:100:100:rspamd user:/var/lib/rspamd:/sbin/nologin" >> /etc/passwd \
    && echo "${RSPAMD_USER}:x:100:" >> /etc/group \
    && mkdir -p /var/lib/rspamd /var/log/rspamd \
    && chown -R "${RSPAMD_USER}:${RSPAMD_USER}" /var/lib/rspamd /var/log/rspamd \
    && chmod 0755 /var/lib/rspamd /var/log/rspamd

COPY --from=builder /build /
COPY entrypoint.sh /entrypoint.sh
COPY etc/ /_etc

RUN chmod a+x /entrypoint.sh \
    && rspamd --version

EXPOSE 11333/tcp 11334/tcp

VOLUME [ "/var/lib/rspamd", "/var/log/rspamd" ]

# tini is required to handle clean shutdown of exim
ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]
CMD [ "rspamd", "-f", "-u", "rspamd", "-g", "rspamd" ]

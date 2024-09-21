FROM ghcr.io/project0/container-hub/base-devel:20240921-139 AS builder

ENV DESTDIR /build
WORKDIR /src

# renovate: datasource=github-releases depName=Cisco-Talos/clamav
ARG CLAMAV_VERSION=1.0.0 \
    CLAMAV_REPO=https://github.com/Cisco-Talos/clamav-devel.git

RUN yum -y install rust cargo pcre2-devel libxml2-devel json-c-devel ncurses-devel sendmail-milter-devel \
    && git get-release "${CLAMAV_REPO}" "clamav-${CLAMAV_VERSION}" clamav \
    && mkdir -p build \
    && cd build \
    && cmake ../clamav -B build \
          -DCMAKE_BUILD_TYPE="Release" \
          -DCMAKE_INSTALL_PREFIX="/usr" \
          -DCMAKE_INSTALL_LIBDIR="/usr/lib" \
          -DAPP_CONFIG_DIRECTORY="/etc/clamav" \
          -DDATABASE_DIRECTORY="/var/lib/clamav" \
          -DENABLE_CLAMONACC=OFF \
          -DENABLE_EXAMPLES=OFF \
          -DENABLE_JSON_SHARED=ON \
          -DENABLE_MAN_PAGES=OFF \
          -DENABLE_MILTER=ON \
          -DENABLE_STATIC_LIB=OFF \
    && cmake --build build \
    && cmake --install build

FROM ghcr.io/project0/container-hub/base:20240921-139

ENV CLAMAV_USER clamav

# install libary deps and user
RUN yum -y install openssl-libs pcre2 bzip2-libs libxml2 \
    && echo "${CLAMAV_USER}:x:100:100:rspamd user:/var/lib/clamav:/sbin/nologin" >> /etc/passwd \
    && echo "${CLAMAV_USER}:x:100:" >> /etc/group \
    && mkdir -p /var/lib/clamav /var/run/clamav \
    && chown -R "${CLAMAV_USER}:${CLAMAV_USER}" /var/lib/clamav /var/run/clamav \
    && chmod 0755 /var/lib/clamav /var/run/clamav \
    && cleanup

COPY --from=builder /build /
COPY entrypoint.sh /entrypoint.sh
COPY etc/ /_etc

RUN chmod a+x /entrypoint.sh \
    && gomplate --input-dir /_etc/ --output-dir /etc \
    && clamav-config --version \
    && clamd --version \
    && freshclam --version

VOLUME [ "/var/lib/clamav" ]

EXPOSE 3310/tcp

# tini is required to handle clean shutdown
ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]
CMD [ "clamd" ]

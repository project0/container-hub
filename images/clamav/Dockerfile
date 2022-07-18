FROM ghcr.io/project0/container-hub/base-devel:20220718-36 AS builder

ENV DESTDIR /build
WORKDIR /src

ARG CLAMAV_VERSION=0.105
ARG CLAMAV_REPO=https://github.com/Cisco-Talos/clamav-devel.git
RUN curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh -s -- -y 
RUN yum -y install pcre2-devel libxml2-devel json-c-devel ncurses-devel sendmail-milter-devel \
    && git get-release "${CLAMAV_REPO}" "clamav-${CLAMAV_VERSION}*" clamav \
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

FROM ghcr.io/project0/container-hub/base:20220718-36

ENV CLAMAV_USER clamav

# install libary deps and user
RUN yum -y install openssl-libs pcre2 bzip2-libs libxml2 \
    && yum -y update \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && echo "${CLAMAV_USER}:x:100:100:rspamd user:/var/lib/clamav:/sbin/nologin" >> /etc/passwd \
    && echo "${CLAMAV_USER}:x:100:" >> /etc/group \
    && mkdir -p /var/lib/clamav /var/run/clamav \
    && chown -R "${CLAMAV_USER}:${CLAMAV_USER}" /var/lib/clamav /var/run/clamav \
    && chmod 0755 /var/lib/clamav /var/run/clamav

COPY --from=builder /build /
COPY entrypoint.sh /entrypoint.sh
COPY etc/ /etc

RUN chmod a+x /entrypoint.sh \
    && clamav-config --version \
    && clamd --version \
    && freshclam --version

VOLUME [ "/var/lib/clamav" ]

EXPOSE 3310/tcp

# tini is required to handle clean shutdown
ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]
CMD [ "clamd" ]

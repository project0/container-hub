FROM docker.pkg.github.com/project0/container-hub/base-devel:20201210-17 AS builder

ENV DESTDIR=/build \
    PREFIX=/usr \
    LIBRARY_PATH=lib64

WORKDIR /src

ARG WEAKFORCED_VERSION=v2.2.2
ARG WEAKFORCED_REPO=https://github.com/PowerDNS/weakforced.git

ARG LIBSODIUM_VERSION=1.0.18
ARG LIBSODIUM_REPO=https://github.com/jedisct1/libsodium.git

ARG HIREDIS_VERSION=v0.14.1
ARG HIREDIS_REPO=https://github.com/redis/hiredis.git

ARG PROMETHEUS_VERSION=v0.9.0
ARG PROMETHEUS_REPO=https://github.com/jupp0r/prometheus-cpp.git

ARG GETDNS_VERSION=v1.6.0
ARG GETDNS_REPO=https://github.com/getdnsapi/getdns.git

ARG MAXMIND_VERSION=1.4.2
ARG MAXMIND_REPO=https://github.com/maxmind/libmaxminddb.git

# Last official release 0.6.3 wont compile
ARG YAML_VERSION=master
ARG YAML_REPO=https://github.com/jbeder/yaml-cpp.git

RUN yum -y install cmake3 openssl-devel lua-devel libcurl-devel readline-devel boost-devel protobuf-devel \
        libidn2-devel unbound-devel libev-devel libuv-devel geoip-devel

RUN git get-release "${LIBSODIUM_REPO}" "${LIBSODIUM_VERSION}" /src/libsodium \
    && cd /src/libsodium \
    && ./autogen.sh \
    && ./configure --prefix=/usr --libdir=/usr/lib64 \
    && make -j$(nproc) \
    && DESTDIR=/ make install \
    && make install

RUN git get-release "${HIREDIS_REPO}" "${HIREDIS_VERSION}" /src/hiredis \
    && cd /src/hiredis \
    && make -j$(nproc) \
    && DESTDIR= PREFIX=/usr make install \
    && make install

RUN git get-release "${PROMETHEUS_REPO}" "${PROMETHEUS_VERSION}" /src/prometheus \
    && cd /src/prometheus \
    && git submodule update --init \
    && mkdir -p /src/prometheus/_build \
    && cd /src/prometheus/_build \
    && cmake3 .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_SHARED_LIBS=off \
    && make -j$(nproc) \
    && DESTDIR= make install \
    && make install

RUN git clone --depth=1 "${YAML_REPO}" /src/yaml \
    && mkdir -p /src/yaml/_build \
    && cd /src/yaml/_build \
    && cmake3 -DCMAKE_INSTALL_PREFIX=/usr  ..   \
    && make -j$(nproc) \
    && DESTDIR= make install \
    && make install

RUN git get-release "${GETDNS_REPO}" "${GETDNS_VERSION}" /src/getdns \
    && cd /src/getdns \
    && git submodule update --init \
    && cmake3 -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTING=OFF  \
    && make -j$(nproc) \
    ## workaround buggy project is ignoring the libdir and is always using `lib` ...
#    && DESTDIR=/ make install \
#    && make install
    && DESTDIR=/build_getdns make install \
    && mv /build_getdns/usr/lib/ /build_getdns/usr/lib64 \
    && cp -aRv /build_getdns/* / \
    && cp -aRv /build_getdns/* ${DESTDIR}

RUN git get-release "${MAXMIND_REPO}" "${MAXMIND_VERSION}" /src/maxmind \
    && cd /src/maxmind \
    && git submodule update --init \
    && autoreconf -ivf \
    && ./configure --prefix=/usr --libdir=/usr/lib64  \
    && make -j$(nproc) \
    && DESTDIR=/ make install \
    && make install

RUN git get-release "${WEAKFORCED_REPO}" "${WEAKFORCED_VERSION}" /src/weakforced \
    && cd /src/weakforced \
    && autoreconf -ivf \
    && ./configure --prefix /usr --enable-trackalert --sysconfdir=/etc/wforce \
    && make -j$(nproc) \
    && DESTDIR=/ make install \
    && make install

# cleanup
RUN find /build -iname '*.la' -delete -o -iname *'*.a' -delete \
    && rm -rf /build/usr/include

FROM docker.pkg.github.com/project0/container-hub/base:20201210-17

COPY --from=builder /build /
COPY entrypoint.sh /entrypoint.sh

RUN yum install -y openssl openssl-libs unbound-libs protobuf geoip boost \
    && yum -y update \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && chmod a+rx /entrypoint.sh \
    && groupadd -g 1000 wforce \
    && useradd --uid 1000 -N -M -r --gid 1000 wforce \
    && chmod -R 0775 /etc/wforce \
    && chown -R wforce:wforce /etc/wforce

COPY etc/ /_etc

USER wforce:wforce
EXPOSE 8084

ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]
CMD [ "wforce", "-s" ]

FROM ghcr.io/project0/container-hub/base-devel:20220714-35 AS builder

ENV DESTDIR="/build"
WORKDIR /src

ARG EXIM_VERSION=exim-4.96 \
    EXIM_REPO=https://github.com/Exim/exim.git

# deps
RUN yum install -y openssl-devel mariadb-devel libidn-devel libidn2-devel libdb-devel pcre2-devel libspf2-devel

# exim
RUN git get-release "${EXIM_REPO}" "${EXIM_VERSION}" /src/exim \
    && cd /src/exim/src \
    && make -j$(nproc) \
    && useradd exim \
    && make install

# Build target docker image
FROM ghcr.io/project0/container-hub/base:20220714-35

## install libary deps
RUN yum -y install openssl-libs mariadb-libs libidn libidn2 libdb pcre2 libspf2 \
    && cleanup \
    && mkdir -p /_etc

# copy config templates and entrypoint
COPY entrypoint.sh /entrypoint.sh
# COPY etc/ /_etc

# setup exim
ENV EXIM_USER exim
COPY --from=builder /build /
RUN echo "${EXIM_USER}:x:79:79:Exim MTA:/var/spool/exim:/sbin/nologin" >> /etc/passwd \
    && echo "${EXIM_USER}:x:79:" >> /etc/group \
    && chmod u+s /usr/bin/exim \
    && chown -R "${EXIM_USER}:${EXIM_USER}" /var/spool/exim /var/log/exim \
    && exim --version \
    && chmod a+x /entrypoint.sh

VOLUME [ "/var/spool/exim", "/var/log/exim" ]

# tini is required to handle clean shutdown of exim (installed in base image)
ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]

# Testing with dns: exim -d+resolver -bh <ip>
CMD [ "exim", "-bdf", "-v", "-q30m" ]

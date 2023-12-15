FROM ghcr.io/project0/container-hub/base-devel:20231215-92 AS builder

ENV DESTDIR="/build"
WORKDIR /src

# renovate: datasource=github-tags depName=Exim/exim versioning=regex:^exim-(?<major>\d+)\.(?<minor>\d+)\.?(?<patch>\d+)?$
ARG EXIM_VERSION=exim-4.97 \
    EXIM_REPO=https://github.com/Exim/exim.git

# deps
RUN yum install -y perl-File-FcntlLock perl-experimental \
        openssl-devel mysql-devel libidn-devel libidn2-devel libdb-devel pcre2-devel libspf2-devel libopendmarc-devel

# exim
RUN git get-release "${EXIM_REPO}" "${EXIM_VERSION}" /src/exim
COPY exim.Makefile /src/exim/src/Local/Makefile
RUN cd /src/exim/src \
    && make -j$(nproc) \
    && useradd exim \
    && make install \
    && install -dm0755 "${DESTDIR}/usr/lib/exim/lookups" "${DESTDIR}/var/log/exim" "${DESTDIR}/var/spool/exim" "${DESTDIR}/usr/lib64" \
    && cp -aRv /usr/lib64/mysql/* "${DESTDIR}/usr/lib64/"

# Build target docker image
FROM ghcr.io/project0/container-hub/base:20231215-92

## install libary deps
RUN yum -y install openssl-libs libidn libidn2 libdb pcre2 libspf2 libopendmarc \
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

FROM ghcr.io/project0/container-hub/base-devel:20251015-261 as builder
WORKDIR /src

# renovate: datasource=golang-version depName=go versioning=conan
ARG GO_VERSION=1.25.1

# renovate: datasource=github-releases depName=restic/restic
ARG RESTIC_VERSION="v0.18.1" \
    RESTIC_REPO="https://github.com/restic/restic.git"
LABEL version="${RESTIC_VERSION}"

# renovate: datasource=github-releases depName=rclone/rclone
ARG RCLONE_VERSION="v1.71.1" \
    RCLONE_REPO="https://github.com/rclone/rclone.git"
LABEL version.restic="${RCLONE_VERSION}"

RUN goinstall

RUN git get-release "${RESTIC_REPO}" "${RESTIC_VERSION}" /src/restic \
    && cd /src/restic \
    && go run build.go

RUN git get-release "${RCLONE_REPO}" "${RCLONE_VERSION}" /src/rclone \
    && cd /src/rclone \
    && make rclone

FROM ghcr.io/project0/container-hub/base:20251015-261

# install additional tools
RUN yum -y install mariadb postgresql \
    && cleanup

COPY --from=builder /src/restic/restic /usr/local/bin/
COPY --from=builder /src/rclone/rclone /usr/local/bin/

COPY entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh \
    && restic version \
    && rclone version

VOLUME /data
WORKDIR /data

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "restic" ]

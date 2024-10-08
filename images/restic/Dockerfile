FROM ghcr.io/project0/container-hub/base-devel:20240921-139 as builder
WORKDIR /src

# renovate: datasource=golang-version depName=go versioning=conan
ARG GO_VERSION=1.23.1

# renovate: datasource=github-releases depName=restic/restic
ARG RESTIC_VERSION="v0.17.1" \
    RESTIC_REPO="https://github.com/restic/restic.git"

# renovate: datasource=github-releases depName=rclone/rclone
ARG RCLONE_VERSION="v1.67.0" \
    RCLONE_REPO="https://github.com/rclone/rclone.git"

RUN goinstall

RUN git get-release "${RESTIC_REPO}" "${RESTIC_VERSION}" /src/restic \
    && cd /src/restic \
    && go run build.go

RUN git get-release "${RCLONE_REPO}" "${RCLONE_VERSION}" /src/rclone \
    && cd /src/rclone \
    && make rclone

FROM ghcr.io/project0/container-hub/base:20240921-139

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

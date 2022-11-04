FROM golang:1.19 as builder

# renovate: datasource=github-release depName=restic/restic
ARG VERSION="v0.14.0"
ARG REPO="https://github.com/restic/restic.git"

WORKDIR /src

RUN git clone --depth=1 "${REPO}" --branch=$(git ls-remote --tags --refs -q "${REPO}" "${VERSION}*" | tail -n 1 | awk -F/ '{ print $3 }') /src \
    && go run build.go

FROM ghcr.io/project0/container-hub/base:20221104-44

# install additional tools
RUN yum -y install mariadb postgresql \
    && cleanup

COPY --from=builder /src/restic /usr/local/bin/
COPY entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh \
    && restic version

VOLUME /data
WORKDIR /data

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "restic" ]

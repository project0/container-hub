FROM ghcr.io/project0/container-hub/base-devel:20250315-200 as builder
WORKDIR /src

# renovate: datasource=golang-version depName=go versioning=conan
ARG GO_VERSION=1.23.6

# renovate: datasource=github-releases depName=coredns/coredns
ARG VERSION=v1.12.0 \
    REPO=https://github.com/coredns/coredns.git
LABEL version="${VERSION}"

RUN yum -y install unbound-devel \
    && goinstall \
    && git get-release "${REPO}" "${VERSION}" /src/coredns \
    && cd /src/coredns \
    && echo 'unbound:github.com/coredns/unbound' >> plugin.cfg \
    && make gen \
    && make coredns CGO_ENABLED=1

FROM ghcr.io/project0/container-hub/base:20250315-200
COPY --from=builder /src/coredns/coredns /usr/local/bin/

RUN yum -y install unbound-libs openssl openssl-libs \
    && cleanup \
    && coredns --version

CMD [ "coredns" ]

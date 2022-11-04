FROM ghcr.io/project0/container-hub/base-devel:20221104-53 as builder

WORKDIR /src

# renovate: datasource=github-releases depName=coredns/coredns
ARG VERSION=v1.10.0 \
    REPO=https://github.com/coredns/coredns.git

ADD https://dl.google.com/go/go1.19.1.linux-amd64.tar.gz /tmp/go.tar.gz
RUN yum -y install unbound-devel \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && ln -s /usr/local/go/bin/go  /usr/local/bin/go \
    && ln -s /usr/local/go/bin/gofmt  /usr/local/bin/gofmt

RUN git get-release "${REPO}" "${VERSION}" /src/coredns \
    && cd /src/coredns \
    && echo 'unbound:github.com/coredns/unbound' >> plugin.cfg \
    && make gen \
    && make coredns CGO_ENABLED=1

FROM ghcr.io/project0/container-hub/base:20221104-53
COPY --from=builder /src/coredns/coredns /usr/local/bin/

RUN yum -y install unbound-libs openssl openssl-libs \
    && cleanup \
    && coredns --version

CMD [ "coredns" ]

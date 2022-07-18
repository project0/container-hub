FROM ghcr.io/project0/container-hub/base-devel:20220718-36 as builder

WORKDIR /src

ARG VERSION=v1.8.6
ARG REPO=https://github.com/coredns/coredns.git

ADD https://dl.google.com/go/go1.17.3.linux-amd64.tar.gz /tmp/go.tar.gz
RUN sed  's/baseos/devel/i' /etc/yum.repos.d/almalinux-baseos.repo  > /etc/yum.repos.d/almalinux-devel.repo \
    && dnf config-manager --add-repo /etc/yum.repos.d/almalinux-devel.repo \
    && yum -y install unbound-devel \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && ln -s /usr/local/go/bin/go  /usr/local/bin/go \
    && ln -s /usr/local/go/bin/gofmt  /usr/local/bin/gofmt

RUN git get-release "${REPO}" "${VERSION}" /src/coredns \
    && cd /src/coredns \
    && echo 'unbound:github.com/coredns/unbound' >> plugin.cfg \
    && make gen \
    && make coredns CGO_ENABLED=1

FROM ghcr.io/project0/container-hub/base:20220718-36
COPY --from=builder /src/coredns/coredns /usr/local/bin/

RUN yum -y install unbound-libs openssl openssl-libs \
    && yum -y update \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && coredns --version

CMD [ "coredns" ]

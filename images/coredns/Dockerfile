FROM docker.pkg.github.com/project0/container-hub/base-devel:20201112-16 as builder

WORKDIR /src

ARG VERSION=v1.8.0
ARG REPO=https://github.com/coredns/coredns.git

RUN yum -y install unbound-devel \
    && amazon-linux-extras install -y golang1.11

RUN git get-release "${REPO}" "${VERSION}" /src/coredns \
    && cd /src/coredns \
    && echo 'unbound:github.com/coredns/unbound' >> plugin.cfg \
    && go generate \
    && make coredns CGO_ENABLED=1

FROM docker.pkg.github.com/project0/container-hub/base:20201112-16
COPY --from=builder /src/coredns/coredns /usr/local/bin/

RUN yum -y install unbound-libs openssl openssl-libs \
    && yum -y update \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && coredns --version

CMD [ "coredns" ]

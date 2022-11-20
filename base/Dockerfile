# Build base image
# project0de/base:amzn2
FROM almalinux:9.1

# Add gomplate
# renovate: datasource=github-releases depName=hairyhenderson/gomplate
ARG GOMPLATE_VERSION=v3.10.0
ADD https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64-slim /extra/bin/gomplate
# Add tini
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /extra/bin/tini

ENV PATH="${PATH}:/extra/bin/"

# update image
RUN yum -y update \
    && yum -y reinstall glibc-common \
    && yum -y install wget which epel-release \
    && echo 'yum clean all && rm -rf /var/cache/yum' > /extra/bin/cleanup \
    && chmod a+rx /extra/bin/* \
    && cleanup

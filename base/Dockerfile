# Build base image
# project0de/base:amzn2
FROM almalinux:9

# Add gomplate
ADD https://github.com/hairyhenderson/gomplate/releases/download/v3.10.0/gomplate_linux-amd64-slim /extra/bin/gomplate
# Add tini
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /extra/bin/tini

# update image
RUN yum -y update \
    && yum -y reinstall glibc-common \
    && yum -y install wget which  \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && chmod a+rx /extra/bin/*

ENV PATH="${PATH}:/extra/bin/"

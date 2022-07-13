# Buld image with all development tools installed
FROM ghcr.io/project0/container-hub/base:latest
COPY gitconfig /root/.gitconfig

RUN yum -y install dnf-plugins-core \
    && dnf config-manager --set-enabled crb \
    && yum -y install autoconf automake binutils bison flex gcc gcc-c++ glibc-devel libtool make pkgconf pkgconf-m4 pkgconf-pkg-config git patchutils cmake libtool-ltdl \
       check-devel bzip2-devel libcurl-devel openssl-devel \
    && echo "alias cmake3=cmake" > /etc/profile.d/cmake.csh \
    && cleanup

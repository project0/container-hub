# Buld image with all development tools installed
FROM docker.pkg.github.com/project0/container-hub/base:latest
COPY gitconfig /root/.gitconfig

RUN yum -y groupinstall 'Development Tools' \
    && yum -y install cmake \
    && echo "alias cmake3=cmake" > /etc/profile.d/cmake.csh \
    && yum clean all \
    && rm -rf /var/cache/yum

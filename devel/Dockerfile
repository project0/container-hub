# Buld image with all development tools installed
# project0de/base-devel:amzn2
FROM docker.pkg.github.com/project0/container-action-test/base:20200410-16
COPY gitconfig /root/.gitconfig

RUN yum -y groupinstall 'Development Tools' \
    && yum -y install cmake \
    && yum clean all \
    && rm -rf /var/cache/yum

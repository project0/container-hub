FROM golang:1.14 as builder

#ARG VERSION="v0.9.6"
#ARG REPO="https://github.com/restic/restic.git"
ENV GO111MODULE=on
WORKDIR /src

ADD install_plugin.sh /usr/local/bin/install_plugin
ADD goinstall.sh /usr/local/bin/goinstall

RUN chmod a+x /usr/local/bin/install_plugin  /usr/local/bin/goinstall \
    && goinstall github.com/hashicorp/terraform@v0.12.25 \
    && install_plugin gitlab.com/sbitio terraform-provider-hiera5 v0.2.2 \
    && install_plugin github.com/odedniv terraform-provider-sql v0.1.0 \
    && install_plugin github.com/mrparkers terraform-provider-keycloak 1.18.0

FROM docker.pkg.github.com/project0/container-hub/base:20200521-9

COPY --from=builder /go/bin/terraform /usr/local/bin/terraform
COPY --from=builder /build/plugins /root/.terraform.d/plugins

WORKDIR /data

CMD [ "terraform" ]

# # install additional tools
# RUN yum -y install mariadb postgresql curl wget \
#     && yum -y update \
#     && yum clean all \
#     && rm -rf /var/cache/yum

# COPY --from=builder /src/restic /usr/local/bin/
# COPY entrypoint.sh /entrypoint.sh

# RUN chmod a+x /entrypoint.sh
# VOLUME /data
#

# ENTRYPOINT [ "/entrypoint.sh" ]
# CMD [ "restic" ]
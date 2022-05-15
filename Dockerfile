FROM golang:alpine
MAINTAINER "Ezzio Moreira <enzziom@gmail.com>"

ENV TERRAFORM_VERSION=1.0.0

RUN apk add --update git bash openssh ansible python3

ENV TF_DEV=true
ENV TF_RELEASE=true

WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
    git checkout v${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh

WORKDIR $GOPATH
ENTRYPOINT ["terraform"]
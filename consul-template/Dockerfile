# Base Image to use
FROM alpine:3.3

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Install dependencies
RUN apk update && apk upgrade && \
apk add curl wget bash tree && \
rm -rf /var/cache/apk/*

RUN curl -sSL https://releases.hashicorp.com/consul-template/0.14.0/consul-template_0.14.0_linux_amd64.zip > /tmp/consul.zip && \
    unzip /tmp/consul.zip -d /tmp && \
    mv /tmp/consul-template /usr/bin/consul-template && \
    rm -f /tmp/consul.zip

ENTRYPOINT ["/usr/bin/consul-template"]
# Base Image to use
FROM python:2-slim

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Environment production
ENV production "true"

# APT installs
RUN \
	apt-get update  -y --no-install-recommends --fix-missing && \
	apt-get upgrade -y --no-install-recommends --fix-missing && \
	apt-get install -y --no-install-recommends --fix-missing \
	apt-utils nano curl wget git-core python-xattr && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# PIP installs
RUN \
	pip install --upgrade --no-cache-dir awscli & \
	pip install --upgrade --no-cache-dir awsebcli

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Install docker-machine
RUN curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
RUN chmod +x /usr/local/bin/docker-machine

WORKDIR /var/app/current/platform

ENTRYPOINT ["bash", "-c"]

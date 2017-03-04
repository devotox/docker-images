# Base Image to use
FROM kalilinux/kali-linux-docker

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Set environment variables
ENV TERM "xterm"

# APT installs
RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update  -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get upgrade -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing kali-linux-full

RUN DEBIAN_FRONTEND=noninteractive \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing automake make cmake unzip gcc g++ && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing apt-utils sudo nano vim emacs curl wget lsof jq && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing ruby-full python-dev python-setuptools python-xattr && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing software-properties-common git-core build-essential && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing apt-transport-https lsb-release cron mailutils && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Add node apt repository
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -

# Install Node
RUN DEBIAN_FRONTEND=noninteractive \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing nodejs

# Update NPM
# RUN curl -L https://npmjs.org/install.sh | sh

ENTRYPOINT ["bash", "-c"]
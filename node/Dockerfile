# Base Image to use
FROM node:6.5.0

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Set environment variables
ENV TERM "xterm"

# APT installs
RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update  -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get upgrade -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing imagemagick graphicsmagick && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing automake make cmake unzip gcc g++ && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing apt-utils sudo nano vim emacs curl wget lsof jq && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing ruby-full python-dev python-setuptools python-xattr && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing software-properties-common git-core build-essential && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing apt-transport-https lsb-release cron gnome-schedule mailutils && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Update NPM
RUN curl -L https://npmjs.org/install.sh | sh

# Install Watchman
RUN \
	git clone https://github.com/facebook/watchman.git && \
	cd watchman && \
	git checkout v4.6.0 && \
	./autogen.sh && \
	./configure && \
	make && \
	make install && \
	cd ..  && \
	rm -rf watchman

# Gem Installs
RUN gem install sass --no-user-install

# Install system / build / test tools
RUN npm config set registry https://registry.npmjs.org/ && npm -g cache clean && \
	npm install -g pm2 forever nodemon node-inspector \
	jshint eslint mocha karma-cli phantomjs-prebuilt \
	bower gulp grunt-cli broccoli-cli ember-cli \
	eslint-config-ember \
	--no-optional \
	--unsafe-perm \
	&& npm -g cache clean

# Print Versions
RUN echo "System Version: \n$(lsb_release -irc)" && \
	echo "Python Version: $(python --version)" && \
	echo "Ember Version: $(ember -v)" && \
	echo "Ruby Version: $(ruby -v)" && \
	echo "Node Version: $(node -v)" && \
	echo "NPM Version: $(npm -v)"

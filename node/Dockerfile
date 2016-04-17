# Base Image to use
FROM node:5.10.1-slim

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Set environment variables
ENV TERM "xterm"

# APT installs
RUN \
	apt-get update  -y --no-install-recommends --fix-missing && \
	apt-get upgrade -y --no-install-recommends --fix-missing && \
	apt-get install -y --no-install-recommends --fix-missing apt-utils imagemagick nano curl && \
	apt-get install -y --no-install-recommends --fix-missing ruby-full python-dev python-setuptools && \
	apt-get install -y --no-install-recommends --fix-missing software-properties-common git-core build-essential automake unzip && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Watchman
RUN \
	git clone https://github.com/facebook/watchman.git && \
	cd watchman && \
	git checkout v4.5.0 && \
	./autogen.sh && \
	./configure && \
	make && \
	make install && \
	cd ..  && \
	rm -rf watchman

# Gem Installs
RUN gem install sass --no-user-install

# Install system / build / test tools
RUN npm config set registry https://registry.npmjs.org/ && npm cache clean && \
	npm install -g pm2 forever nodemon node-inspector \
	jshint mocha karma-cli phantomjs-prebuilt \
	bower gulp grunt-cli broccoli-cli \
	ember-cli \
	--no-optional \
	--unsafe-perm \
	--no-progress \
	&& npm cache clean

# Print Versions
RUN echo "System Version: \n$(lsb_release -irc)" && \
	echo "Python Version: $(python --version)" && \
	echo "Ruby Version: $(ruby -v)" && \
	echo "Node Version: $(node -v)" && \
	echo "NPM Version: $(npm -v)"

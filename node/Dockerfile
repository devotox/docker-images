# Base Image to use
FROM node:6.2.2

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Set environment variables
ENV TERM "xterm"
ENV DISPLAY ":10"

# APT installs
RUN \
	apt-get update  -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get upgrade -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing imagemagick graphicsmagick && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing automake make cmake unzip gcc g++ && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing apt-utils sudo nano vim emacs curl wget lsof jq xvfb && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing ruby-full python-dev python-setuptools python-xattr && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing software-properties-common git-core build-essential && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing apt-transport-https lsb-release cron gnome-schedule mailutils && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Update NPM
RUN curl -L https://npmjs.org/install.sh | sh

# install firefox 42
RUN \
	mkdir /tmp/firefox42 && \
	cd /tmp/firefox42 && \
	wget https://ftp.mozilla.org/pub/firefox/releases/42.0/linux-x86_64/en-GB/firefox-42.0.tar.bz2 && \
	tar -xjf firefox-42.0.tar.bz2 && \
	mv firefox /usr/local/firefox42 && \
	ln -s /usr/local/firefox42/firefox /usr/bin/firefox

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
RUN npm config set registry https://registry.npmjs.org/ && npm -g cache clean && \
	npm install -g pm2 forever nodemon node-inspector \
	jshint eslint mocha karma-cli phantomjs-prebuilt \
	bower gulp grunt-cli broccoli-cli ember-cli \
	eslint-config-ember \
	--no-optional \
	--unsafe-perm \
	--no-progress \
	&& npm -g cache clean

# Print Versions
RUN echo "System Version: \n$(lsb_release -irc)" && \
	echo "Python Version: $(python --version)" && \
	echo "Ember Version: $(ember -v)" && \
	echo "Ruby Version: $(ruby -v)" && \
	echo "Node Version: $(node -v)" && \
	echo "NPM Version: $(npm -v)"

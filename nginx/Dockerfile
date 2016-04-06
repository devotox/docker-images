# Set nginx base image
FROM nginx

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# APT installs
RUN \
	apt-get update  -y --no-install-recommends --fix-missing && \
	apt-get upgrade -y --no-install-recommends --fix-missing && \
	apt-get install -y --no-install-recommends --fix-missing apt-utils nano && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy over nginx directory
ADD . /etc/nginx

# Set Work Directory
WORKDIR /etc/nginx

# Set Volume Directory
VOLUME [ "/etc/nginx", "/var/log/nginx" ]

# Expose port
EXPOSE 80 443 5432 38100 39100

# Create nginx-watch executable
RUN \
	cp -f nginx-watch.sh /bin/nginx-watch && \
	chmod +x /bin/nginx-watch

CMD ["nginx-watch"]
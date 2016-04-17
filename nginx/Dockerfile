# Set nginx base image
FROM nginx:1.9.14

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Environment production
ENV TERM "xterm"
ENV TESTING "false"
ENV PRODUCTION "true"
ENV NODE_ENV "production"

# APT installs
RUN \
	apt-get update  -y --no-install-recommends --fix-missing && \
	apt-get upgrade -y --no-install-recommends --fix-missing && \
	apt-get install -y --no-install-recommends --fix-missing apt-utils nano curl && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy over nginx directory
COPY . /etc/nginx

# Set Work Directory
WORKDIR /etc/nginx

# Set Volume Directory
VOLUME ["/etc/nginx", "/var/log/nginx"]

# Create nginx-watch executable
RUN \
	cp -f nginx-watch.sh /bin/nginx-watch && \
	chmod +x /bin/nginx-watch

# Expose port
EXPOSE 80 443 5432 38100 39100

# Find Nginx version
RUN nginx -v

CMD ["nginx-watch"]

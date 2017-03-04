# Set nginx base image
FROM nginx:1.11.10

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Environment
ENV TERM "xterm"
ENV AMPLIFY_IMAGENAME ""
ENV NEW_RELIC_IMAGENAME ""
ENV AMPLIFY_API_KEY "1234567890"
ENV NEW_RELIC_LICENSE_KEY "1234567890"

# APT installs
RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update  -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get upgrade -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing automake make cmake unzip gcc g++ && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing apt-utils sudo nano vim emacs curl wget telnet lsof jq && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing ruby-full python-dev python-setuptools python-xattr && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing software-properties-common git-core build-essential rsyslog ntpdate && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing apt-transport-https lsb-release cron gnome-schedule mailutils nginx-nr-agent && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Add default nginx configuration
ADD nginx.conf /etc/nginx/nginx.conf

# Create amplify install
COPY nginx-amplify-install.sh /tmp/amplify-install.sh
RUN sh /tmp/amplify-install.sh

# Create amplify-launch executable
COPY nginx-amplify-launch.sh /bin/nginx-amplify-launch
RUN chmod a+rx /bin/nginx-amplify-launch

# Create nginx-newrelic-launch executable
COPY nginx-newrelic-launch.sh /bin/nginx-newrelic-launch
RUN chmod a+rx /bin/nginx-newrelic-launch

# Create nginx-watch executable
COPY nginx-watch.sh /bin/nginx-watch
RUN chmod a+rx /bin/nginx-watch

# Create nginx-launch executable
# which combines all launches together
COPY nginx-launch.sh /bin/nginx-launch
RUN chmod a+rx /bin/nginx-launch

# Set Work Directory
WORKDIR /etc/nginx

# Set Volume Directory
VOLUME ["/etc/nginx", "/var/log/nginx"]

# Expose port
EXPOSE 80 443 5432 6379 38100 39100

# Find Nginx version
RUN nginx -v

# Default command
CMD ["nginx-launch"]

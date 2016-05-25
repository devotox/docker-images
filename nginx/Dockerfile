# Set nginx base image
FROM nginx:1.11.0

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Environment production
ENV TERM "xterm"
ENV API_KEY "1234567890"
ENV AMPLIFY_HOSTNAME ""

# APT installs
RUN \
	apt-get update  -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get upgrade -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing automake make cmake unzip gcc g++ && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing apt-utils sudo nano curl wget lsof jq && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing ruby-full python-dev python-setuptools apt-transport-https lsb-release && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing software-properties-common git-core build-essential cron gnome-schedule && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Amplify Agent
# https://github.com/nginxinc/nginx-amplify-doc/blob/master/amplify-faq.md
# https://github.com/nginxinc/nginx-amplify-doc/blob/master/amplify-guide.md
# RUN curl -L https://github.com/nginxinc/nginx-amplify-agent/raw/master/packages/install.sh  > /tmp/amplify-agent-install.sh && \
# 	sh /tmp/amplify-agent-install.sh && \
# 	rm -f /tmp/amplify-agent-install.sh

# Create amplify install
COPY nginx-amplify-install.sh /tmp/amplify-install.sh
RUN sh /tmp/amplify-install.sh

# Create amplify-launch executable
COPY nginx-amplify-launch.sh /bin/nginx-amplify-launch
RUN chmod a+rx /bin/nginx-amplify-launch

# Create nginx-watch executable
COPY nginx-watch.sh /bin/nginx-watch
RUN chmod a+rx /bin/nginx-watch

# Set Work Directory
WORKDIR /etc/nginx

# Set Volume Directory
VOLUME ["/etc/nginx", "/var/log/nginx"]

# Expose port
EXPOSE 80 443 5432 6379 38100 39100

# Find Nginx version
RUN nginx -v

# Default command
CMD ["nginx-amplify-launch"]
# CMD ["nginx-watch"]

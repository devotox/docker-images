# Base Image to use
FROM jenkins

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Set user to root initially
USER root

# Set default options
ENV JAVA_OPTS="-Xmx8192m"
ENV JENKINS_OPTS="--handlerCountStartup=100 --handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log"

# APT installs
RUN \
	apt-get update  -y --no-install-recommends --fix-missing && \
	apt-get upgrade -y --no-install-recommends --fix-missing && \
	apt-get install -y --no-install-recommends --fix-missing sudo curl && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Install docker-machine
RUN curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
RUN chmod +x /usr/local/bin/docker-machine

# Add jenkins user to sudoers file (to run docker commands)
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

# Create jenkins Folders
RUN mkdir -p /var/log/jenkins
RUN mkdir -p /var/jenkins_home

# Set ownership of jenkins folders
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/jenkins_home

# Copy over jenkins directory
ADD . /var/jenkins

# Switch back to jenkins user
USER jenkins

# Set Work Directory
WORKDIR /var/jenkins_home

# COPY plugins.txt /usr/share/jenkins/plugins.txt
# RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# Expose port
EXPOSE 8080 50000
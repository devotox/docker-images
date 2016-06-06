# Base Image to use
FROM jenkinsci/jenkins:2.8

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Environment
ENV TERM "xterm"

# Set user to root initially
USER root

# Add node apt repository
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# APT installs
RUN \
	apt-get update  -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get upgrade -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing nodejs && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing imagemagick graphicsmagick && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing automake make cmake unzip gcc g++ && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing apt-utils sudo nano vim emacs curl wget lsof jq && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing ruby-full python-dev python-setuptools python-xattr && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing software-properties-common git-core build-essential && \
	apt-get install -y --no-install-recommends --no-install-suggests --fix-missing apt-transport-https lsb-release cron gnome-schedule mailutils && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Update NPM
RUN curl -L https://npmjs.org/install.sh | sh

# Install docker
RUN curl -fsSL https://get.docker.com/ | sh

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Install docker-machine
RUN curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
RUN chmod +x /usr/local/bin/docker-machine

# Add jenkins user to sudoers file (to run docker commands)
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

# Add jenkins user to docker group
# RUN gpasswd -a jenkins docker && usermod -a -G docker jenkins

# Create jenkins Folders
RUN mkdir -p /var/jenkins
RUN mkdir -p /var/log/jenkins
RUN mkdir -p /var/jenkins_home
RUN mkdir -p /var/jenkins_home/.ssh

# Create log file
RUN touch /var/log/jenkins/jenkins.log

# Set ownership of jenkins folders
RUN chown -R jenkins:jenkins /var/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/jenkins_home

# Set plugins
COPY config/plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# Set number of executors
COPY config/executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
COPY config/extralogging.groovy /usr/share/jenkins/ref/init.groovy.d/extralogging.groovy

# Utilty Scripts
COPY utils/list-plugins.sh /bin/list-plugins
COPY utils/jenkins-backup.sh /bin/jenkins-backup
RUN chmod a+rx /bin/list-plugins /bin/jenkins-backup

# Copy over jenkins directory
COPY . /var/jenkins

# Set Work Directory
WORKDIR /var/jenkins_home

# Switch back to jenkins user
USER jenkins

# Expose port
EXPOSE 8080 50000

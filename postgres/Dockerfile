# Set postgres base image
FROM postgres:9.6

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Set environment variables
ENV TERM "xterm"

# Install necessary packages
RUN \
	apt-get update  -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get upgrade -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get install -y --fix-missing apt-utils postgis && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up SSL
COPY conf/ssl.conf /etc/postgresql-common/ssl.conf
RUN mkdir -p /var/ssl && touch /var/ssl/server.crt /var/ssl/server.key

# Add the ssl config setup script
COPY conf/postgresql.conf /usr/share/postgresql/9.6/postgresql.conf.sample
COPY conf/pg_hba.conf /usr/share/postgresql/9.6/pg_hba.conf.sample

# Set appropriate permissions and ownership
RUN chown -R postgres /etc/postgresql-common/ssl.conf
RUN chown -R postgres /usr/share/postgresql
RUN chown -R postgres /var/ssl/server.key
RUN chmod -R 0600 /var/ssl/server.key

# Expose port
EXPOSE 5432

# Find postgres version
RUN psql --version

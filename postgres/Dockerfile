# Set postgres base image
FROM postgres:9.6

# File Author / Maintainer
MAINTAINER Devonte Emokpae

# Set environment variables
ENV TERM "xterm"
ENV POSTGIS_MAJOR 2.3
ENV POSTGIS_VERSION 2.3.2

RUN sed -i -r "s/^#?(create_main_cluster = ).*$/#\1true/g" /etc/postgresql-common/createcluster.conf && \
	sed -i -r "s/^#?(stats_temp_directory = ).*$/\1/g" /etc/postgresql-common/createcluster.conf

# Install necessary packages
RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update  -y --no-install-recommends --no-install-suggests --fix-missing && \
	apt-get install -y --no-install-recommends --fix-missing apt-utils postgis nano vim emacs wget curl && \
	apt-get install -y --no-install-recommends --fix-missing unzip patch make postgresql-server-dev-9.6 && \
	apt-get install -y --no-install-recommends postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR && \
	apt-get install -y --no-install-recommends postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i -r "s/^#?(create_main_cluster = ).*$/\1false/g" /etc/postgresql-common/createcluster.conf && \
	sed -i -r "s/^#?(stats_temp_directory = ).*$/#\1/g" /etc/postgresql-common/createcluster.conf

# Install pgTap
RUN mkdir /tmp/pgTap && \
	cd /tmp/pgTap && \
	wget https://api.pgxn.org/dist/pgtap/0.97.0/pgtap-0.97.0.zip --no-check-certificate && \
	unzip pgtap-0.97.0.zip && \
	cd pgtap-0.97.0 && \
	make && \
	make install && \
	cpan TAP::Parser::SourceHandler::pgTAP && \
	cd /tmp && rm -rf /tmp/pgTap

# PG FUTTER for copying from csv easily
RUN curl -Lo /usr/local/bin/pgfutter https://github.com/lukasmartinelli/pgfutter/releases/download/v1.1/pgfutter_linux_amd64 --insecure && chmod +x /usr/local/bin/pgfutter

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

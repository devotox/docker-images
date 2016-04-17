#!/bin/bash

# This script is used to migrate production data to testing database

echo
echo "########################################################"
echo "####         Production Database Migration          ####"
echo "########################################################"
echo

# Install Postgres seperately first before running this file as we will not be using
# brew install postgres

cd database;

mkdir -p tmp/;

connecting_user="jmicka"

echo "Dump Production Database...";
pg_dump --exclude-table-data='*_logs' --exclude-table-data='*_token' -U $connecting_user -c -C platform -h db.platform.co.uk -f tmp/production.db;

echo "Kill All Connections to Testing Database...";
cat << EOF | psql -U $connecting_user -h testing-db.platform.co.uk  -c -C platform
	SELECT 	pg_terminate_backend(pg_stat_activity.pid)
	FROM 	pg_stat_activity
	WHERE 	datname = current_database()
			AND pid <> pg_backend_pid();
EOF

echo "Source Production Database...";
psql -U $connecting_user -h testing-db.platform.co.uk  -c -C platform -f tmp/production.db

echo "Delete Production Database File...";
rm -rf tmp/;

cd ../;
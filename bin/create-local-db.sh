#!/bin/bash

# This script is used to initialize the database from the testing data

echo
echo "########################################################"
echo "####             Local Database Creation            ####"
echo "########################################################"
echo

# Install Postgres seperately first before running this file as we will not be using
# brew install postgres

cd database;

mkdir -p tmp/;

current_user="jmicka"
connecting_user="jmicka"

echo "Dump Testing Database...";
pg_dump --exclude-table-data='*_logs' --exclude-table-data='*_token' --exclude-table-data='*_likes' --exclude-table-data='*_request' --exclude-table-data='t_mailing_list' --exclude-table-data='t_appointment' -U $connecting_user -c -C platform -h testing-db.platform.co.uk -f tmp/testing.db;

echo "Kill All Connections to Local Database...";
cat << EOF | psql -U $current_user -h database.platform.local.com -C platform
	SELECT 	pg_terminate_backend(pg_stat_activity.pid)
	FROM 	pg_stat_activity
	WHERE 	datname = current_database()
			AND pid <> pg_backend_pid();
EOF

echo "Strip connecting user and use local user...";
sed -i -e "s|$connecting_user|$current_user|g" "tmp/testing.db"

echo "Source Testing Database...";
psql -U $current_user -h database.platform.local.com -f tmp/testing.db;

echo "Scrub Local Database...";
cat << EOF | psql platform
	\i scripts/scrub_database.sql;
	\i scripts/utility_functions.sql;
EOF

echo "Create Local Database File...";
pg_dump -U $current_user -h database.platform.local.com -c -C platform -f ./local.db;

echo "Test Local Database Regeneration...";
psql -U $current_user -h database.platform.local.com -f local.db;

echo "Delete Testing Database File...";
rm -rf tmp/;

cd ../;
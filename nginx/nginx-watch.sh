#!/bin/bash

# NGINX WATCH DAEMON
#
# Author: Devonte
#
# Place file in root of nginx folder: /etc/nginx
# This will test your nginx config on any change and
# if there are no problems it will reload your configuration
# USAGE: sh nginx-watch.sh

# Set NGINX directory
# tar command already has the leading /
dir="etc/nginx"

pid="/var/run/nginx.pid"

# test for changes every n seconds
time=1

# Inital PID value from pid file
pid_value=""

# Get initial checksum values
checksum_initial=$(tar --strip-components=2 -C / -cf - $dir | md5sum | awk '{print $1}')
checksum_now=$checksum_initial

# Start nginx
nginx

# Daemon that checks the md5 sum of the directory
# if the sums are different ( a file changed / added / deleted)
# the nginx configuration is tested and reloaded on success
while true
do
	checksum_now=$(tar --strip-components=2 -C / -cf - $dir | md5sum | awk '{print $1}')

	if [ $checksum_initial != $checksum_now ]; then
		timestamp="$(date +"%d-%m-%Y") $(date +"%H:%M:%S")"
		echo "[ NGINX ][ $timestamp ] A configuration file changed. Reloading..."

		if [ -f "$pid" ]; then
			pid_value=`cat $pid`
		fi

		if [ -f "$pid" ] && [ "$pid_value" != "" ]; then
			nginx -t && nginx -s reload
		else
			nginx -t && nginx
		fi
	fi

	checksum_initial=$checksum_now

	sleep $time
done

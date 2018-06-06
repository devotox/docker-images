#!/bin/sh
#
# This script starts the New Relic Agent.
#
# Unless already baked in the image, a real LICENSE_KEY is required for the
# NEW RELIC Agent to be able to connect to the backend.
#
# If NEW_RELIC_IMAGENAME is set, the script will use it to generate
# the 'imagename' to put in the /etc/nginx-nr-agent/nginx-nr-agent.ini
#
# If several instances use the same imagename, the metrics will
# be aggregated into a single object in New Relic. Otherwise New Relic
# will create separate objects for monitoring (an object per instance).
#

# Variables
imagename=""
license_key=""
nginx_status_url="http://127.0.0.1\/nginx_status"
agent_conf_file="/etc/nginx-nr-agent/nginx-nr-agent.ini"

# Check for an older version of the agent running
if command -V pgrep > /dev/null 2>&1; then
	agent_pid=`pgrep nginx-nr-agent`
else
	agent_pid=`ps aux | grep -i 'nginx-nr-agent' | awk '{print $2}'`
fi

if [ -n "$agent_pid" ]; then
	echo "stopping old nginx-nr-agent, pid ${agent_pid}"
	service nginx-nr-agent stop > /dev/null 2>&1 < /dev/null
fi

test -n "${NEW_RELIC_LICENSE_KEY}" && \
	license_key=${NEW_RELIC_LICENSE_KEY}

test -n "${NEW_RELIC_IMAGENAME}" && \
	imagename=${NEW_RELIC_IMAGENAME}

test -n "${NEW_RELIC_NGINX_STATUS_URL}" && \
	nginx_status_url=${NEW_RELIC_NGINX_STATUS_URL}

if [ -n "${license_key}" -o -n "${imagename}" ]; then
	if [ ! -f "${agent_conf_file}" ]; then
		test -f "${agent_conf_file}.default" && \
		cp -p "${agent_conf_file}.default" "${agent_conf_file}" || \
		{ echo "no ${agent_conf_file}.default found! exiting."; exit 1; }
	fi

	sed -i "s|#[source1]|[source1]|" /etc/nginx-nr-agent/nginx-nr-agent.ini
	sed -i "s|#name=exampleorg|name=${imagename}|" /etc/nginx-nr-agent/nginx-nr-agent.ini
	sed -i "s|YOUR_LICENSE_KEY_HERE|${license_key}|" /etc/nginx-nr-agent/nginx-nr-agent.ini
	sed -i "s|#url=http://example.org/status|url=${nginx_status_url}|" /etc/nginx-nr-agent/nginx-nr-agent.ini
fi

echo
echo "Starting nginx-nr-agent.."
service nginx-nr-agent start > /dev/null 2>&1 < /dev/null
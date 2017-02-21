#!/bin/sh
#
# This script starts the Amplify Agent.
#
# Unless already baked in the image, a real AMPLIFY_API_KEY is required for the
# Amplify Agent to be able to connect to the backend.
#
# If AMPLIFY_IMAGENAME is set, the script will use it to generate
# the 'imagename' to put in the /etc/amplify-agent/agent.conf
#
# If several instances use the same imagename, the metrics will
# be aggregated into a single object in Amplify. Otherwise Amplify
# will create separate objects for monitoring (an object per instance).
#

# Variables
api_key=""
amplify_imagename=""
agent_conf_file="/etc/amplify-agent/agent.conf"
agent_log_file="/var/log/amplify-agent/agent.log"
nginx_status_conf="/etc/nginx/conf.d/nginx_stub_status.conf"

# Check for an older version of the agent running
if command -V pgrep > /dev/null 2>&1; then
	agent_pid=`pgrep amplify-agent`
else
	agent_pid=`ps aux | grep -i '[a]mplify-agent' | awk '{print $2}'`
fi

if [ -n "$agent_pid" ]; then
	echo "stopping old amplify-agent, pid ${agent_pid}"
	service amplify-agent stop > /dev/null 2>&1 < /dev/null
fi

test -n "${AMPLIFY_API_KEY}" && \
	api_key=${AMPLIFY_API_KEY}

test -n "${AMPLIFY_IMAGENAME}" && \
	amplify_imagename=${AMPLIFY_IMAGENAME}

if [ -n "${api_key}" -o -n "${amplify_imagename}" ]; then
	echo
	echo "updating ${agent_conf_file} ..."

	if [ ! -f "${agent_conf_file}" ]; then
		test -f "${agent_conf_file}.default" && \
		cp -p "${agent_conf_file}.default" "${agent_conf_file}" || \
		{ echo "no ${agent_conf_file}.default found! exiting."; exit 1; }
	fi

	test -n "${api_key}" && \
	echo " ---> using api_key = ${api_key}" && \
	sh -c "sed -i.old -e 's/api_key.*$/api_key = $api_key/' \
	${agent_conf_file}"

	test -n "${amplify_imagename}" && \
	echo " ---> using imagename = ${amplify_imagename}" && \
	sh -c "sed -i.old -e 's/imagename.*$/imagename = $amplify_imagename/' \
	${agent_conf_file}"

	test -f "${agent_conf_file}" && \
	chmod 644 ${agent_conf_file} && \
	chown nginx ${agent_conf_file} > /dev/null 2>&1
fi

echo
echo "starting amplify-agent.."
service amplify-agent start > /dev/null 2>&1 < /dev/null

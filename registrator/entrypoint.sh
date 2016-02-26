#!/bin/bash

if [ -z "$DOCKER_HOST_IP" ]; then
	export DOCKER_HOST_IP=$(curl --retry 5 --connect-timeout 3 -s 169.254.169.254/latest/meta-data/local-ipv4)
fi

/bin/registrator "-ip=$DOCKER_HOST_IP" "$@"


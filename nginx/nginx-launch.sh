#!/bin/sh
#
# Combines all launches into one easy command

echo
echo "NGINX New Relic Agent Launch..."
nginx-newrelic-launch

echo
echo "NGINX Amplify Agent Launch..."
nginx-amplify-launch

echo
echo "NGINX Watch..."
nginx-watch
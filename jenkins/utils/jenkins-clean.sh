#!/bin/bash

echo
echo "================================= Clean Jenkins ===================================="
echo

application="*"
repo="*"

# Remove branch logs
echo
echo "Remove Jenkins Logs..."
rm -rf /var/jenkins_home/jobs/$application/jobs/$repo/branches/PR-*
rm -rf /var/jenkins_home/workspace/$application/$repo/PR-*

service jenkins restart

echo

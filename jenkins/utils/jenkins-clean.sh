#!/bin/bash

echo
echo "================================= Clean Jenkins ===================================="
echo

application="*"

# Remove branch logs
echo
echo "Remove Jenkins Logs..."
rm -rf /var/jenkins_home/workspace/$application/platform/*
rm -rf /var/jenkins_home/jobs/$application/jobs/platform/branches/*

echo

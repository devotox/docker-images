#!/bin/bash

echo
echo "================================= Clean Jenkins ===================================="
echo

# Remove branch logs
echo
echo "Remove Jenkins Logs..."
rm -rf /var/jenkins_home/workspace/Doctify/platform/*
rm -rf /var/jenkins_home/jobs/Doctify/jobs/platform/branches/*

echo

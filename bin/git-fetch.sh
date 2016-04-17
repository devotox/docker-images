#!/bin/bash

# Updates Application with Git fetch


echo
echo "########################################################"
echo "####             GIT FETCH APPLICATION              ####"
echo "########################################################"
echo

git fetch upstream && git merge --no-edit upstream/master

echo
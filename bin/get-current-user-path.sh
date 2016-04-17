#!/bin/bash

# This script creates the default local Nginx Configuration


echo
echo "########################################################"
echo "####              Find Current User                 ####"
echo "########################################################"
echo

# Default Variables
current_user="$USER" 
application_path="$PWD" 
nginx_config_path="/usr/local/etc/nginx"

# Get Current User
echo
read -n1 -p "Current User is $USER (y/n)? " user_prompt

case $user_prompt in  
  	n|N) 
		echo
		read -p "Current User: " current_user 
  	;; 
esac

echo
echo "[ CURRENT USER ] $current_user"


echo
echo "########################################################"
echo "####              Find Current Path                 ####"
echo "########################################################"
echo

# Get Path to Application Directory
read -n1 -p "Application Path is $PWD (y/n)? " user_prompt

case $user_prompt in  
  	n|N) 
		echo
		read -p "Application Path: " application_path
  	;; 
esac

echo
echo "[ APPLICATION PATH ] $application_path"
echo
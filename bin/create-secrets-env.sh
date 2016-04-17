#!/bin/bash

# This script is used to create the secrets.env file

echo
echo "########################################################"
echo "####               Create Secrets Env               ####"
echo "########################################################"
echo

cp -f shared/env/secrets.env.config shared/env/secrets.env

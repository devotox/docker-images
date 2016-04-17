#!/bin/bash

# This script is used to create the server.crt, server.key, dhparam.pem files

echo
echo "########################################################"
echo "####              Create Certificates               ####"
echo "########################################################"
echo

openssl genrsa -des3 -out sslcert/server.key 2048
openssl req -new -key sslcert/server.key -out sslcert/server.csr
cp sslcert/server.key sslcert/server.key.org

openssl rsa -in sslcert/server.key.org -out sslcert/server.key
openssl x509 -req -days 365 -in sslcert/server.csr -signkey sslcert/server.key -out sslcert/server.crt
openssl dhparam -out sslcert/dhparam.pem 2048

touch sslcert/godaddy_bundle_1.crt
touch sslcert/godaddy_bundle_2.crt
touch sslcert/godaddy_bundle_3.crt

cat sslcert/server.crt sslcert/godaddy_bundle_1.crt sslcert/godaddy_bundle_2.crt sslcert/godaddy_bundle_3.crt > sslcert/godaddy_bundle.crt
# cp -fv sslcert/godaddy_bundle.crt sslcert/server.crt
# rm -f sslcert/godaddy_bundle.crt

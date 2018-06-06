#!/bin/bash

pass="$1"
user="devotox"

# login
docker login -u $user -p $pass

# pull
docker pull node:9.11.1
docker pull funkygibbon/nginx-pagespeed
docker pull gcr.io/planet-4-151612/openresty

# build
docker build node -t doctify/node
docker build nginx -t doctify/nginx
docker build openresty -t doctify/openresty

# push
docker push doctify/node
docker push doctify/nginx
docker push doctify/openresty
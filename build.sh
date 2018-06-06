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
docker build node -t $user/node
docker build nginx -t $user/nginx
docker build openresty -t $user/openresty

# push
docker push $user/node
docker push $user/nginx
docker push $user/openresty
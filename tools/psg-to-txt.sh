#!/usr/bin/env bash

docker run --rm -itd --name suptext --user "$(id -u):$(id -g)" -v "$(pwd)":/mymedia eliaonceagain/suptext:latest

for file in *.mkv; do
  echo "Processing: $file"
  docker exec suptext supcli -v "/mymedia/$file"
done

docker stop suptext


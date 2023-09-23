#!/bin/sh

secrets=$(ls /run/secrets)
for secret in $secrets
do
    value=$(cat /run/secrets/$secret)
    sed -i "s/\$$secret/$value/g" config/services.yaml
done

node server.js

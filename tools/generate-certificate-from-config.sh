#!/usr/bin/env bash

domain=$1

sed "s/\$domain/$domain/g" conf.tlp > $domain.conf

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -CA /mnt/data/config/nginx/ssl/certs/pluto/saso.crt \
  -CAkey /mnt/data/config/nginx/ssl/certs/pluto/saso.key \
  -keyout $domain.key \
  -out $domain.crt \
  -config $domain.conf \
  -extensions v3_req


FROM nginx:stable-alpine

RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python

COPY default.conf /etc/nginx/conf.d/default.conf
COPY snippets/* /etc/nginx/snippets/


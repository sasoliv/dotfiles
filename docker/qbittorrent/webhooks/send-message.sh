#!/usr/bin/env sh

url=$1
title=$2
message=$3
curl -X POST -k \
    -H "Content-Type: application/json" \
    -d "{ \"title\": \"$title\", \"message\": \"$message\" }" \
    $url

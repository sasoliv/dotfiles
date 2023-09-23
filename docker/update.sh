#!/usr/bin/env sh

dockerCompose=$(readlink -f "$0")
dockerCompose=$(dirname "$dockerCompose")
dockerCompose="$dockerCompose/docker-compose.yaml"

docker compose -f $dockerCompose pull $@
docker compose -f $dockerCompose up --force-recreate --build --remove-orphans -d $@
docker image prune -f


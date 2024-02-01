#!/bin/bash

APP_NAME=transmission
TAG=develop
IMAGE=thomaschampagne/oci-$APP_NAME:$TAG
PORT=9091

cd "$(dirname "$0")" || exit

# Init clear
opt_clear=false

if [[ "$1" = "-h" || "$1" = "--help" ]]; then
  echo "Usage: "
  echo "    -c|--clear Drop existing image & volumes"
  exit 2
fi

if [[ "$1" = "-c" || "$1" = "--clear" ]]; then
  opt_clear=true
fi

# Kill existing container if exists
docker rm -f $APP_NAME

# Clear if requested
if [[ "$opt_clear" == "true" ]]; then
    docker image rm $IMAGE
    docker volume rm oci-$APP_NAME-downloads 2> /dev/null
    docker volume rm oci-$APP_NAME-incomplete 2> /dev/null
    docker volume rm oci-$APP_NAME-watch 2> /dev/null
fi

# Build image
docker build -t $IMAGE . && docker image prune -f

# Create required volume
docker volume create oci-$APP_NAME-downloads 2> /dev/null
docker volume create oci-$APP_NAME-incomplete 2> /dev/null
docker volume create oci-$APP_NAME-watch 2> /dev/null

# Run
docker run -dit \
    --name $APP_NAME \
    -p $PORT:$PORT \
    -v oci-$APP_NAME-downloads:/downloads \
    -v oci-$APP_NAME-incomplete:/incomplete \
    -v oci-$APP_NAME-incomplete:/watch \
    $IMAGE

echo -e "\n[Info] Container running. Access app at: http://localhost:$PORT"
echo -e "\n[Info] Connect to container with: docker exec -it $APP_NAME sh\n\n"
docker logs -f $APP_NAME

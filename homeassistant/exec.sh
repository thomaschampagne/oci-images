#!/bin/bash

APP_NAME=homeassistant
TAG=develop
IMAGE=thomaschampagne/oci-$APP_NAME:$TAG
PORT=8123

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
fi

# Build image
docker build -t $IMAGE . && docker image prune -f

# Run
docker run -dit \
    --name $APP_NAME \
    -p $PORT:$PORT \
    $IMAGE

echo -e "\n[Info] Container running. Access app at: http://localhost:$PORT"
echo -e "\n[Info] Connect to container with: docker exec -it $APP_NAME sh\n\n"
docker logs -f $APP_NAME

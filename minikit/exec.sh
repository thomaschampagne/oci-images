#!/bin/bash

APP_NAME=minikit
TAG=develop
IMAGE=thomaschampagne/oci-$APP_NAME:$TAG

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
    docker volume rm oci-$APP_NAME-srv 2> /dev/null
fi

# Build image
docker build -t $IMAGE . && docker image prune -f

docker run -it $IMAGE sh

echo -e "\n[Info] Connect to container with: docker run -it $IMAGE sh\n\n"

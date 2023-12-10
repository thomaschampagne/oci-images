#!/bin/bash

APP_NAME=pydav
TAG=develop
IMAGE=thomaschampagne/oci-$APP_NAME:$TAG
PORT=8080

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
podman rm -f $APP_NAME

# Clear if requested
if [[ "$opt_clear" == "true" ]]; then
    podman image rm $IMAGE
    podman volume rm oci-$APP_NAME-data 2> /dev/null
fi

# Build image
podman build -t $IMAGE .

# Create required volume
podman volume create oci-$APP_NAME-data 2> /dev/null

# Run
podman run -dit \
    --name $APP_NAME \
    -p $PORT:$PORT \
    -v oci-$APP_NAME-data:/data \
    $IMAGE

echo -e "\nContainer running. Access app at: http://localhost:$PORT/"
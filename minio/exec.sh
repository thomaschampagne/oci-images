#!/bin/bash

APP_NAME=minio
TAG=develop
IMAGE=thomaschampagne/oci-$APP_NAME:$TAG
PORT_1=9000
PORT_2=9001

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
podman build -t $IMAGE . && podman image prune -f

# Create required volume
podman volume create oci-$APP_NAME-data 2> /dev/null

# Run
podman run -dit \
    --name $APP_NAME \
    -p $PORT_1:$PORT_1 \
    -p $PORT_2:$PORT_2 \
    -v oci-$APP_NAME-data:/data \
    $IMAGE

echo -e "\n[Info] Container running. Access app at: http://localhost:$PORT_1 & http://localhost:$PORT_2"
echo -e "\n[Info] Connect to container with: podman exec -it $APP_NAME sh\n\n"
podman logs -f $APP_NAME
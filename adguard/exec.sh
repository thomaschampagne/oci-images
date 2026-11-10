#!/bin/bash

APP_NAME=adguard
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
podman rm -f $APP_NAME

# Clear if requested
if [[ "$opt_clear" == "true" ]]; then
    podman image rm $IMAGE
    podman volume rm oci-$APP_NAME-data 2> /dev/null
    podman volume rm oci-$APP_NAME-conf 2> /dev/null
    podman volume rm oci-$APP_NAME-work 2> /dev/null
fi

# Build image
podman build -t $IMAGE . && podman image prune -f

# Create required volumes
podman volume create oci-$APP_NAME-data 2> /dev/null
podman volume create oci-$APP_NAME-conf 2> /dev/null
podman volume create oci-$APP_NAME-work 2> /dev/null

# Run
podman run -dit \
    --name $APP_NAME \
    -p 53:53/tcp -p 53:53/udp \
    -p 67:67/udp -p 68:68/udp \
    -p 80:80/tcp \
    -p 3000:3000/tcp \
    -p 853:853/tcp -p 853:853/udp \
    -p 443:443/tcp -p 443:443/udp \
    -v oci-$APP_NAME-data:/opt/adguardhome/work \
    -v oci-$APP_NAME-conf:/opt/adguardhome/conf \
    $IMAGE

echo -e "\n[Info] Container running. Access app at: http://localhost:3000"
echo -e "\n[Info] Connect to container with: podman exec -it $APP_NAME sh\n\n"
podman logs -f $APP_NAME

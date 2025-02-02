#!/bin/bash

APP_NAME=cloud-domain
TAG=develop
IMAGE=thomaschampagne/oci-$APP_NAME:$TAG
NETBIOS_PORT=139
SMB_PORT=445
LDAPS_PORT=636

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

# Create required volume
docker volume create oci-$APP_NAME-srv 2> /dev/null

# Run
docker run -dit \
    --name $APP_NAME \
    -e REALM=realm.localhost \
    -e DOMAIN=realm \
    -e SAMBA_DC_ADMIN_PASSWORD=F4KE-S3CR3T \
    -e AUTHELIA_SERVICE_ACCOUNT_USERNAME=authelia \
    -e AUTHELIA_SERVICE_ACCOUNT_PASSWORD=F4KE-V3RY-L0NG-S3CR3T \
    $IMAGE

echo -e "\n[Info] Connect to container with: docker exec -it $APP_NAME sh\n\n"
docker logs -f $APP_NAME

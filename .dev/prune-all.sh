#!/bin/bash
cd "$(dirname "$0")" || exit

sh prune-containers.sh

podman volume ls -q | xargs podman volume rm -f 2> /dev/null
echo "Volumes pruned"

podman image ls -qa | xargs podman image rm -f 2> /dev/null
echo "Images pruned"

#!/bin/bash
cd "$(dirname "$0")" || exit

sh prune-containers.sh

podman volume prune -f
echo "Volumes pruned"

podman image prune -af
echo "Images pruned"

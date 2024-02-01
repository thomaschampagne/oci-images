#!/bin/bash
cd "$(dirname "$0")" || exit

sh prune-containers.sh

docker volume ls -q | xargs docker volume rm -f 2> /dev/null
echo "Volumes pruned"

docker image ls -qa | xargs docker image rm -f 2> /dev/null
echo "Images pruned"

#!/bin/bash

podman ps -a | awk '{print $1}' | xargs podman rm -f 2> /dev/null
echo "Containers pruned"
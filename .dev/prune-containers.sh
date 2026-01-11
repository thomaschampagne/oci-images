#!/bin/bash

podman ps -qa | xargs podman rm -f 2> /dev/null
echo "Containers pruned"

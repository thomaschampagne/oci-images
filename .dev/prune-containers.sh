#!/bin/bash

docker ps -qa | xargs docker rm -f 2> /dev/null
echo "Containers pruned"

#!/bin/bash

# This script:
# - Cleans the destination folder (keeping .gitignore) at './src/static'.
# - Pulls the Docker image if not already present.
# - Runs a temporary Docker container based on the image.
# - Copies the content from '/usr/share/nginx/html' in the container to './src/static'.
# - Removes the temporary container after the content has been copied.

# Variables
NAME="tools"
SRC_IMAGE="corentinth/it-tools:latest"
LOCAL_DEST_FOLDER="./src/static"
SRC_CONTAINER_PATH="/usr/share/nginx/html"

# Clean destination folder, but keep .gitignore
echo "Cleaning destination folder..." && \
  find "$LOCAL_DEST_FOLDER" -mindepth 1 ! -name '.gitignore' -exec rm -rf {} + && \

  # Pull the Docker image (if not already pulled)
  echo "Pulling Docker image: $SRC_IMAGE"
  docker pull "$SRC_IMAGE" && \

  # Create a temporary container and copy the content
  echo "Copying content from container to local directory..."
  docker run --rm --name "tmp-pull-content-$NAME" -d "$SRC_IMAGE" && \
  docker cp "tmp-pull-content-$NAME":"$SRC_CONTAINER_PATH/." "$LOCAL_DEST_FOLDER" && \

  # Cleanup temporary container
  echo "Cleaning up temporary container..."
  docker stop "tmp-pull-content-$NAME" && \

  echo "Content copied successfully to $LOCAL_DEST_FOLDER"

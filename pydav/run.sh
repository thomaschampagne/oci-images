#!/bin/sh

# Activate python environnment
source ./venv/bin/activate

# Seek for override.config.yaml file and merge with default config if exists
if [ -f "./config/override.config.yaml" ]; then
    echo "Override file exists, merging it over default configuration"
    yq ea '... comments=""|. as $item ireduce({}; . * $item)' ./config/default.config.yaml ./config/override.config.yaml > ./config/merged.yaml
else
    echo "Override file does not exist, using default configuration"
    yq ea '... comments=""|. as $item ireduce({}; . * $item)' ./config/default.config.yaml > ./config/merged.yaml
fi


# Read the required directories to be created before starting server
requiredDirectories=$(yq e '.provider_mapping[]' ./config/merged.yaml)
# Loop through each directory
for directory in $requiredDirectories
do
  # Check if the directory does not exist
  if [ ! -d "$directory" ]; then
    # Create the directory, including necessary parent directories
    echo "Creating missing directory: $directory."
    mkdir -p "$directory" && echo "Directory: $directory created."
  fi
done

echo "Running Wsgidav $(wsgidav --version) using $(python --version)"
wsgidav --config=/app/config/merged.yaml --port=${PYDAV_PORT}

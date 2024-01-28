#!/bin/sh

# Activate python environnment
source ./venv/bin/activate

# Seek for override.config.yaml file and merge with default config if exists
override_file="override.config.yaml"

if [ -f "$override_file" ]; then
    echo "Override file exists, merging it over default configuration"
    yq ea '... comments=""|. as $item ireduce({}; . * $item)' default.config.yaml override.config.yaml > config.yaml
else
    echo "Override file does not exist, using default configuration"
    yq ea '... comments=""|. as $item ireduce({}; . * $item)' default.config.yaml > config.yaml
fi

echo "Running Wsgidav $(wsgidav --version) using $(python --version)"
wsgidav --config=/app/config.yaml --port=${PYDAV_PORT}
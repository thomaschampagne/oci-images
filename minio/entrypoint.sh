#!/bin/sh

# Start minio server
minio server /data --console-address :9001 &
MINIO_PID=$!

# Wait for MinIO to be ready by polling the health endpoint
until wget -qO- http://localhost:9000/minio/health/live 2>/dev/null; do
  echo "Waiting for MinIO to be ready..."
  sleep 1
done

# Then set default alias
mc alias set local http://localhost:9000 "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}"

# Wait for MinIO process to finish
wait $MINIO_PID

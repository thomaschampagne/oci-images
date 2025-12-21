ARG OCI_BASE_IMAGE=alpine:3.23
ARG OCI_BASE_IMAGE_URL=https://hub.docker.com/_/alpine/
ARG OCI_TITLE=oci-minio-image
ARG OCI_DESCRIPTION="High-Performance Object Store"
ARG OCI_MAINTAINER="Thomas Champagne"

# ---- BUILDER: fetch latest MinIO server + mc ----
FROM ${OCI_BASE_IMAGE} AS builder

ARG TARGETOS=linux
ARG TARGETARCH=amd64

WORKDIR /build

COPY ./entrypoint.sh ./entrypoint.sh

RUN \
    apk add --no-cache dos2unix ca-certificates wget && \
    # Update CA for minio download
    update-ca-certificates && \
    # Ensure entrypoint well formatted
    dos2unix ./entrypoint.sh

# Download latest version
# Resolve proper download directory per architecture
# Supported here: amd64, arm64, ppc64le
RUN set -eux; \
    case "${TARGETARCH}" in \
    amd64)   ARCH_DIR="linux-amd64"  ;; \
    arm64)   ARCH_DIR="linux-arm64"  ;; \
    ppc64le) ARCH_DIR="linux-ppc64le";; \
    *) echo "Unsupported TARGETARCH=${TARGETARCH}"; exit 1 ;; \
    esac; \
    mkdir -p /build/out; \
    wget -O /build/out/minio "https://dl.min.io/server/minio/release/${ARCH_DIR}/minio"; \
    wget -O /build/out/mc    "https://dl.min.io/client/mc/release/${ARCH_DIR}/mc"; \
    chmod +x /build/out/minio /build/out/mc

##### NO EDIT ZONE - START #####
FROM ${OCI_BASE_IMAGE}

ARG OCI_BASE_IMAGE
ARG OCI_BASE_IMAGE_URL
ARG OCI_TITLE
ARG OCI_DESCRIPTION
ARG OCI_MAINTAINER
ARG OCI_REPO_URL
ARG OCI_BUILD_DATE

ENV OCI_BASE_IMAGE=${OCI_BASE_IMAGE}
ENV OCI_BASE_IMAGE_URL=${OCI_BASE_IMAGE_URL}
ENV OCI_TITLE=${OCI_TITLE}
ENV OCI_DESCRIPTION=${OCI_DESCRIPTION}
ENV OCI_MAINTAINER=${OCI_MAINTAINER}
ENV OCI_REPO_URL=${OCI_REPO_URL}
ENV OCI_BUILD_DATE=${OCI_BUILD_DATE}

LABEL \
    maintainer=${OCI_MAINTAINER} \
    description=${OCI_DESCRIPTION} \
    url=${OCI_REPO_URL} \
    base-image=${OCI_BASE_IMAGE} \
    base-image-url=${OCI_BASE_IMAGE_URL} \
    org.opencontainers.image.title=${OCI_TITLE} \
    org.opencontainers.image.description=${OCI_DESCRIPTION} \
    org.opencontainers.image.created=${OCI_BUILD_DATE} \
    org.opencontainers.image.authors=${OCI_MAINTAINER} \
    org.opencontainers.image.url=${OCI_REPO_URL} \
    org.opencontainers.image.base.name=${OCI_BASE_IMAGE} \
    org.opencontainers.image.base.url=${OCI_BASE_IMAGE_URL}
##### NO EDIT ZONE - END #####

#---- START IMAGE SPEC HERE ----#
ARG ALT_USER_NAME=oci
ARG ALT_USER_ID=1000

WORKDIR /app

COPY --from=builder /build/out/minio /usr/local/bin/minio
COPY --from=builder /build/out/mc    /usr/local/bin/mc
COPY --from=builder /build/entrypoint.sh ./entrypoint.sh

# Define defaults minio root credentials
ENV MINIO_ROOT_USER=minioadmin
ENV MINIO_ROOT_PASSWORD=minioadmin
ENV MINIO_BROWSER_LOGIN_ANIMATION=false

RUN \
    # Run upgrades & installs
    apk update && apk --no-cache upgrade && \
    apk add --no-cache ca-certificates tini && \
    # Update certificates
    update-ca-certificates && \
    # Create oci user
    adduser ${ALT_USER_NAME} -u ${ALT_USER_ID} -g ${ALT_USER_NAME} -D && \
    echo "User ${ALT_USER_NAME} (id: ${ALT_USER_ID}) created" && \
    mkdir -p /data && \
    chown -R ${ALT_USER_ID}:${ALT_USER_ID} /data

VOLUME ["/data"]

# MinIO API and Console ports
EXPOSE 9000
EXPOSE 9001

# Drop privileges
USER ${ALT_USER_ID}

# Start
ENTRYPOINT ["/sbin/tini", "--", "/app/entrypoint.sh"]

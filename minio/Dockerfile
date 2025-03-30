ARG OCI_BASE_IMAGE=alpine:3.21
ARG OCI_BASE_IMAGE_URL=https://hub.docker.com/_/alpine/
ARG OCI_TITLE=oci-minio-image
ARG OCI_DESCRIPTION="High-Performance Object Store"
ARG OCI_MAINTAINER="Thomas Champagne"

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

# Run upgrades
RUN apk update && apk --no-cache upgrade && \
    # Create oci user
    adduser ${ALT_USER_NAME} -u ${ALT_USER_ID} -g ${ALT_USER_NAME} -D && \
    echo "User ${ALT_USER_NAME} (id: ${ALT_USER_ID}) created"

WORKDIR /app

# Define defaults minio root credentials
ENV MINIO_ROOT_USER=minioadmin
ENV MINIO_ROOT_PASSWORD=minioadmin
ENV MINIO_BROWSER_LOGIN_ANIMATION=false

RUN \
    # Install minio from alpine repo
    apk add --no-cache minio && \
    # Create folder for volume data
    mkdir /data

VOLUME ["/data"]

EXPOSE 9000
EXPOSE 9001

# Set the user to oci
USER ${ALT_USER_ID}

# Exec Minio
CMD ["/usr/bin/minio", "server", "/data", "--console-address", ":9001"]

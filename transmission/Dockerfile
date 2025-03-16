ARG OCI_BASE_IMAGE=alpine:3.21
ARG OCI_BASE_IMAGE_URL=https://hub.docker.com/_/alpine/
ARG OCI_TITLE=oci-transmission-image
ARG OCI_DESCRIPTION="Transmission Torrent Client"
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

# Prepare/install transmission
RUN mkdir /downloads /incomplete /watch && \
    # Give rights to rootless user on folder
    chown -R ${ALT_USER_NAME}:${ALT_USER_NAME} /downloads /incomplete /watch && \
    # Install transmission
    apk add --no-cache tzdata transmission-daemon

COPY ./settings.json /config/settings.json

VOLUME ["/downloads", "/incomplete", "/watch"]

EXPOSE 9091 51413/tcp 51413/udp

ENTRYPOINT ["/usr/bin/transmission-daemon", "--foreground", \
    "--download-dir", "/downloads", \
    "--incomplete-dir", "/incomplete", \
    "--watch-dir", "/watch", \
    "--config-dir", "/config"]

ARG OCI_BASE_IMAGE=golang:1.24-alpine
ARG OCI_BASE_IMAGE_URL=https://hub.docker.com/_/golang/
ARG OCI_TITLE=oci-excalidraw-image
ARG OCI_DESCRIPTION="Virtual whiteboard for sketching hand-drawn like diagrams"
ARG OCI_MAINTAINER="Thomas Champagne"

# ========== Fetch excalidraw static files ==========
# * We might new need to build from master if `excalidraw/excalidraw:latest` image is not regularly updated..
# See:
#  - https://github.com/excalidraw/excalidraw/deployments/Production%20%E2%80%93%20excalidraw
#  - https://github.com/excalidraw/excalidraw/blob/master/Dockerfile
#  - https://hub.docker.com/r/excalidraw/excalidraw
FROM excalidraw/excalidraw:latest AS static_excalidraw

# ========== Build Go HTTP Static Server ==========
FROM ${OCI_BASE_IMAGE} AS build

WORKDIR /build
COPY src .
RUN go build -o /build/excalidraw

##### NO EDIT ZONE - START #####

# ========== Build Runner ==========
FROM ${OCI_BASE_IMAGE} AS runner

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

WORKDIR /app

COPY --from=static_excalidraw /usr/share/nginx/html /app/static
COPY --from=build /build/excalidraw /app

ENV PORT=3000

#---- START IMAGE SPEC HERE ----#
ARG ALT_USER_NAME=oci
ARG ALT_USER_ID=1000

# Run upgrades
RUN apk update && apk --no-cache upgrade && \
    # Create oci user
    adduser ${ALT_USER_NAME} -u ${ALT_USER_ID} -g ${ALT_USER_NAME} -D && \
    echo "User ${ALT_USER_NAME} (id: ${ALT_USER_ID}) created"

CMD ["/app/excalidraw"]

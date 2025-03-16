ARG OCI_BASE_IMAGE=alpine:3.21
ARG OCI_BASE_IMAGE_URL=https://hub.docker.com/_/alpine/
ARG OCI_TITLE=oci-cloud-domain
ARG OCI_DESCRIPTION="Cloud Active Directory Domain Services for Small Businesses & Home Labs"
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

ENV REALM=realm.localhost
ENV DOMAIN=realm
ENV SAMBA_FS_GLOBAL_FORCE_USER=${ALT_USER_NAME}
ENV SAMBA_FS_GLOBAL_FORCE_GROUP=${ALT_USER_NAME}
ENV SAMBA_DC_ADMIN_PASSWORD=change_it
ENV SAMBA_DC_GROUPS_OU=Groups
ENV SAMBA_DC_PEOPLE_OU=People
ENV SAMBA_DC_DEVICES_OU=Devices
ENV SAMBA_DC_SERVICES_OU=Services
ENV SAMBA_DC_USERS_GROUP=Members
ENV SAMBA_DC_ADMINS_GROUP=Admins
ENV SAMBA_DC_SERVICE_ACCOUNTS_GROUP=ServiceAccounts
ENV SAMBA_DC_PWD_COMPLEXITY=on
ENV SAMBA_DC_MIN_PWD_LENGTH=14
ENV SAMBA_DC_MIN_PWD_AGE=0
ENV SAMBA_DC_MAX_PWD_AGE=0
ENV SAMBA_DC_ACCOUNT_LOCKOUT_THRESHOLD=3
ENV SAMBA_DC_HISTORY_LENGTH=0

# Run upgrades & install necessary packages
RUN \
    apk update && \
    apk --no-cache upgrade && \
    apk add --no-cache \
    samba \
    samba-dc \
    samba-common-tools \
    openldap-clients \
    openssl \
    dos2unix \
    tini && \
    # Create oci user
    adduser ${ALT_USER_NAME} -u ${ALT_USER_ID} -g ${ALT_USER_NAME} -D && \
    echo "User ${ALT_USER_NAME} (id: ${ALT_USER_ID}) created"

WORKDIR /app

COPY . .

# Add management folder to PATH
ENV PATH="${PATH}:/app/management"

# Create necessary directories and set permissions
RUN \
    # Remove default Samba configuration file
    rm -f /etc/samba/smb.conf && \
    # Create main shares directory
    mkdir -p /shares && \
    # Convert scripts to Unix format and make them executable
    dos2unix /app/*.sh /app/management/*.sh && chmod +x /app/*.sh /app/management/*.sh

VOLUME ["/shares", "/app/entrypoint.d", "/app/samba/conf.d"]

# Expose necessary ports for AD DC and file sharing
EXPOSE 139/tcp 445/tcp 389/tcp 636/tcp

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/sbin/tini", "--", "/app/entrypoint.sh"]

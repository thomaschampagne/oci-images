#!/bin/sh

# Initialize Samba if not already done
if [ ! -f /var/lib/samba/private/secrets.ldb ]; then

  REALM="$(echo "${REALM}" | tr '[:lower:]' '[:upper:]')"
  DOMAIN="$(echo "${DOMAIN}" | sed -e 's/[^A-Z0-9]//gi' | tr '[:lower:]' '[:upper:]')"

  # Check if REALM is defined and not empty, exit with error message if empty
  if [ -z "$REALM" ]; then
      echo "Error: REALM is not defined or is empty"
      exit 1
  fi

  # Check if DOMAIN is defined and not empty, exit with error message if empty
  if [ -z "$DOMAIN" ]; then
      echo "Error: DOMAIN is not defined or is empty"
      exit 1
  fi

  # Check if SAMBA_DC_ADMIN_PASSWORD is defined and not empty, exit with error message if empty
  if [ -z "$SAMBA_DC_ADMIN_PASSWORD" ]; then
      echo "Error: SAMBA_DC_ADMIN_PASSWORD is not defined or is empty"
      exit 1
  fi

  # Check if SAMBA_FS_GLOBAL_FORCE_USER is defined and not empty, exit with error message if empty
  if [ -z "$SAMBA_FS_GLOBAL_FORCE_USER" ]; then
      echo "Error: SAMBA_FS_GLOBAL_FORCE_USER is not defined or is empty"
      exit 1
  fi

  # Check if SAMBA_FS_GLOBAL_FORCE_GROUP is defined and not empty, exit with error message if empty
  if [ -z "$SAMBA_FS_GLOBAL_FORCE_GROUP" ]; then
      echo "Error: SAMBA_FS_GLOBAL_FORCE_GROUP is not defined or is empty"
      exit 1
  fi

  # Check if SAMBA_DC_PEOPLE_OU is defined and not empty, exit with error message if empty
  if [ -z "$SAMBA_DC_PEOPLE_OU" ]; then
      echo "Error: SAMBA_DC_PEOPLE_OU is not defined or is empty"
      exit 1
  fi

  # Check if SAMBA_DC_USERS_GROUP is defined and not empty, exit with error message if empty
  if [ -z "$SAMBA_DC_USERS_GROUP" ]; then
      echo "Error: SAMBA_DC_USERS_GROUP is not defined or is empty"
      exit 1
  fi

  # Check if SAMBA_DC_ADMINS_GROUP is defined and not empty, exit with error message if empty
  if [ -z "$SAMBA_DC_ADMINS_GROUP" ]; then
      echo "Error: SAMBA_DC_ADMINS_GROUP is not defined or is empty"
      exit 1
  fi

  # Create the directory for storing the TLS certificates if it doesn't already exist
  mkdir -p /var/lib/samba/private/tls && \
  # Generate a self-signed certificate using OpenSSL
  openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout /var/lib/samba/private/tls/private.key.pem -out /var/lib/samba/private/tls/cert.pem \
    -subj "/CN=${REALM}" && \
  # Change the permissions of the private key file to be readable and writable only by the owner
  chmod 600 /var/lib/samba/private/tls/private.key.pem && \
  # Display the details of the generated certificate in a human-readable format
  openssl x509 -in /var/lib/samba/private/tls/cert.pem -text -noout && \

  samba-tool domain provision \
    --use-rfc2307 \
    --realm="${REALM}" \
    --domain="${DOMAIN}" \
    --server-role=dc \
    --dns-backend=NONE \
    --adminpass="${SAMBA_DC_ADMIN_PASSWORD}" \
    --option="server services = s3fs, ldap, winbindd, nbt, rpc" \
    --option="dns forwarder = none" \
    --option="tls enabled = yes" \
    --option="tls keyfile = tls/private.key.pem" \
    --option="tls certfile = tls/cert.pem" \
    --option="tls cafile =" \
    --option="load printers = no" \
    --option="log file = /dev/stdout" \
    --option="log level = 1" \
    --option="force user = ${SAMBA_FS_GLOBAL_FORCE_USER}" \
    --option="force group = ${SAMBA_FS_GLOBAL_FORCE_GROUP}" \
    --option="vfs objects = acl_xattr" \
    --option="map acl inherit = yes"

  # Set Samba password settings using environment variables
  samba-tool domain passwordsettings set \
    --complexity=${SAMBA_DC_PWD_COMPLEXITY} \
    --min-pwd-length=${SAMBA_DC_MIN_PWD_LENGTH} \
    --min-pwd-age=${SAMBA_DC_MIN_PWD_AGE} \
    --max-pwd-age=${SAMBA_DC_MAX_PWD_AGE} \
    --account-lockout-threshold=${SAMBA_DC_ACCOUNT_LOCKOUT_THRESHOLD} \
    --history-length=${SAMBA_DC_HISTORY_LENGTH}

  # Default OU and Groups setup
  samba-tool ou add "OU=$SAMBA_DC_GROUPS_OU" && \
    samba-tool ou add "OU=$SAMBA_DC_PEOPLE_OU" && \
    samba-tool ou add "OU=$SAMBA_DC_DEVICES_OU" && \
    samba-tool ou add "OU=$SAMBA_DC_SERVICES_OU" && \
    samba-tool group add "$SAMBA_DC_USERS_GROUP" --groupou="OU=$SAMBA_DC_GROUPS_OU" && \
    samba-tool group add "$SAMBA_DC_ADMINS_GROUP" --groupou="OU=$SAMBA_DC_GROUPS_OU" && \
    samba-tool group add "$SAMBA_DC_SERVICE_ACCOUNTS_GROUP" --groupou="OU=$SAMBA_DC_GROUPS_OU"

  # Remove the [sysvol] and [netlogon] sections from the smb.conf file
  sed -i '/\[sysvol\]/,/^$/d; /\[netlogon\]/,/^$/d' /etc/samba/smb.conf

  # Setup default home shares for all samba ad users
  cat /app/samba/homes-share.samba.conf >> /etc/samba/smb.conf

  # Create the /shares/homes directory and set the owner to the global force user and group
  mkdir -p /shares/homes && chown -R ${SAMBA_FS_GLOBAL_FORCE_USER}:${SAMBA_FS_GLOBAL_FORCE_GROUP} /shares/homes

  # Copy the modified smb.conf to the /var/lib/samba directory to persist base configuration
  cp /etc/samba/smb.conf /var/lib/samba/smb.base.conf

else
  echo "Samba data already exists. Skipping domain provisioning."

  # Copy the smb.conf from the /var/lib/samba directory back to /etc/samba to restore base configuration
  cp /var/lib/samba/smb.base.conf /etc/samba/smb.conf
fi

# Check if there are any .conf files in the /app/samba/conf.d folder
if [ -d /app/samba/conf.d ]; then
  for configFile in /app/samba/conf.d/*.conf; do
    if [ -f "$configFile" ]; then
      # Print a message indicating the file was found
      echo "Found $configFile"

      # Append the contents of the .conf file to the smb.conf file
      cat "$configFile" >> /etc/samba/smb.conf
    fi
  done
fi

# Check if no arguments are passed to the script
if [ $# -eq 0 ]; then
  # Check if the samba process is running
  pidof samba > /dev/null || {
      # Execute all .sh scripts in the /app/entrypoint.d directory
      if [ -d /app/entrypoint.d ]; then
        for script in /app/entrypoint.d/*.sh; do
          if [ -f "$script" ]; then
            # Print a message indicating the script is being executed
            echo "Executing $script"

            # Execute the script
            sh "$script"
          fi
        done
      fi

      # If samba is not running, start it in interactive mode without creating a new process group
      exec samba --interactive --no-process-group
  }
fi

# Default to run whatever the user wanted, e.g. "sh"
exec "$@"

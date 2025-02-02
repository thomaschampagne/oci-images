#!/bin/sh

# Function to display print_usage
print_usage() {
  echo "Usage: $0 --username USERNAME --password PASSWORD --email EMAIL --first-name FIRST_NAME --last-name LAST_NAME --group-names \"Group1,Group2\""
  exit 1
}

# Parse command-line options
PARSED=$(getopt -o '' --long username:,password:,email:,first-name:,last-name:,group-names: -- "$@")
if [ $? -ne 0 ]; then
  print_usage
fi

eval set -- "$PARSED"

# Initialize variables
USERNAME=""
PASSWORD=""
EMAIL=""
FIRST_NAME=""
LAST_NAME=""
GROUP_NAMES=""

# Extract options and their arguments into variables
while true; do
  case "$1" in
    --username)
      USERNAME="$2"
      shift 2
      ;;
    --password)
      PASSWORD="$2"
      shift 2
      ;;
    --email)
      EMAIL="$2"
      shift 2
      ;;
    --first-name)
      FIRST_NAME="$2"
      shift 2
      ;;
    --last-name)
      LAST_NAME="$2"
      shift 2
      ;;
    --group-names)
      GROUP_NAMES="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      print_usage
      ;;
  esac
done

# Convert username to lowercase
USERNAME=$(echo "$USERNAME" | tr '[:upper:]' '[:lower:]')

# Assert values
if [ -z "$USERNAME" ]; then
  echo "Username is required."
  print_usage
  exit 1
fi

# Check if user already exists
if samba-tool user show ${USERNAME} > /dev/null 2>&1; then
  echo "User ${USERNAME} already exists."
  print_usage
  exit 1
fi

if [ -z "$PASSWORD" ]; then
  echo "Password is required."
  print_usage
  exit 1
fi

if [ -z "$FIRST_NAME" ]; then
  echo "First name is required."
  print_usage
  exit 1
fi

if [ -z "$LAST_NAME" ]; then
  echo "Last name is required."
  print_usage
  exit 1
fi

if [ -z "$EMAIL" ]; then
  echo "Email is required."
  print_usage
  exit 1
fi

if [ -z "$GROUP_NAMES" ]; then
  echo "Group names are required."
  print_usage
  exit 1
fi

# Initialize an empty string to hold trimmed groups
TARGET_GROUPS=""

# Split the GROUP_NAMES string into separate values using ',' as a delimiter
groups=$(echo "$GROUP_NAMES" | tr ',' '\n')

# Loop through each group, trim whitespace, and append it to the TARGET_GROUPS string
for group in $groups; do
    # Trim leading and trailing whitespace
    group=$(echo "$group" | sed 's/^ *//;s/ *$//')

    # Check if group does not exist
    if ! samba-tool group show "$group" > /dev/null 2>&1; then
      echo "Group \"$group\" does not exist in the domain."
      exit 1
    fi
    # Append to TARGET_GROUPS
    TARGET_GROUPS="$TARGET_GROUPS $group"
done

# Validate email format
if ! echo "$EMAIL" | grep -E -q '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'; then
  echo "Invalid email format."
  print_usage
  exit 1
fi

USER_HOME="/shares/homes/${USERNAME}"

# Add the user to the Samba domain
samba-tool user add ${USERNAME} "${PASSWORD}" \
  --userou="OU=${SAMBA_DC_PEOPLE_OU}" \
  --given-name=${FIRST_NAME} \
  --surname=${LAST_NAME} \
  --mail-address=${EMAIL} \
  --use-username-as-cn && \

# If the user was added successfully, proceed with the following commands
mkdir -p ${USER_HOME} && \
  chown -R ${SAMBA_FS_GLOBAL_FORCE_USER}:${SAMBA_FS_GLOBAL_FORCE_GROUP} ${USER_HOME} && \
  echo -e "${USER_HOME} home folder created" && \
  # Iterate over each group name in the array
  for group in $TARGET_GROUPS; do
    samba-tool group addmembers ${group} ${USERNAME}
  done

# Check if user already exists
if samba-tool user show ${USERNAME} > /dev/null 2>&1; then
  echo "User ${USERNAME} added to samba domain successfully with ${USER_HOME} home folder."
else
  echo "Failed to add user ${USERNAME} to the Samba domain."
fi


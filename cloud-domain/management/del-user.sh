#!/bin/sh

# Function to display usage
print_usage() {
  echo "Usage: $0 --username USERNAME"
}

# Check if a parameter was provided
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  print_usage
  exit 1
fi

# Extract the username
if [[ "$1" == "--username" && -n "$2" ]]; then
    USERNAME="$2"
elif [[ "$1" == --username=* ]]; then
    USERNAME="${1#--username=}"
else
  print_usage
  exit 1
fi

# Remove any leading or trailing whitespace from the username
USERNAME="$(echo "$USERNAME" | xargs)"
USER_HOME="/shares/homes/${USERNAME}"

# Delete user from samba
samba-tool user delete ${USERNAME} && \
  echo "Deleted user ${USERNAME} from samba" && \

# Remove user's home directory
if [ -d "$USER_HOME" ]; then
  rm -rf ${USER_HOME} && \
    echo "Deleted home directory ${USER_HOME}"
fi
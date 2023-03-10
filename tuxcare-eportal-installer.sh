#!/usr/bin/env bash

# Determine the Linux distribution
if [ -f /etc/redhat-release ]; then
  DISTRIBUTION="Red Hat"
elif [ -f /etc/lsb-release ]; then
  DISTRIBUTION="Ubuntu"
  UBUNTU_VERSION=$(grep "DISTRIB_RELEASE" /etc/lsb-release | cut -d "=" -f 2)
fi

# Execute commands based on the Linux distribution
if [ "$DISTRIBUTION" = "Red Hat" ]; then
  # Execute commands for Red Hat
  bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/eportal-installer_v1.5.sh)
  # Add your commands here for Red Hat
elif [ "$DISTRIBUTION" = "Ubuntu" ]; then
  # Execute commands for Ubuntu
  if [ "$(echo $UBUNTU_VERSION'<'20.04 | bc -l)" -eq 0 ] && [ "$(echo $UBUNTU_VERSION'<'22.04 | bc -l)" -eq 1 ]; then
    # Execute commands for Ubuntu 20.04
    bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/ubuntu20.04-eportal-installer.sh)
    # Add your commands here for Ubuntu 20.04
  else
    # Execute commands for Ubuntu 22.04 or later
    bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/ubuntu22.04-eportal-installer.sh)
    # Add your commands here for Ubuntu 22.04 or later
  fi
else
  echo "Unsupported distribution detected"
fi

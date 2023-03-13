#!/usr/bin/env bash

clear
echo ****************************************************************************
echo  Title: TuxCare ePortal Automated Installer Script.
echo  Purpose: Install and base configure TuxCare ePortal.
echo  Created by: Jamie Charleston 
echo  Version: 1.5
echo  Last updated: 03/12/2023
echo
echo     Minimum System Requirements to support 10,000 servers
echo  Linux OS Support: AlmaLinux 8, CentOS 7/8, or Ubuntu 20.04/22.04
echo  CPU: 1 CPU Core
echo  Memory: 1G
echo  Disk Space: 25G caching or 200G+ non-Caching
echo
echo  Legal Disclaimer:
echo  This script is provided "AS IS" and without warranty of any kind.
echo  You, the user, assume any risks associated with the use of this script.
echo  You are solely responsible for the use and misuse of this script.
echo  You agree to indemnify and hold harmless the creator of this script
echo  from any and all claims arising from your use or misuse of the script.
echo ****************************************************************************

# Prompt the user to agree to the terms
read -p "Do you agree to these terms? (y/n): " response

# Check if the user agreed to the terms
if [ "$response" != "y" ]; then
  echo "You did not agree to the terms. Exiting script."
  exit 1
fi

# Proceed with the script
echo "You agreed to the terms. Continuing with the script."

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
  bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/AlmaCentOS-eportal-installer.sh)
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

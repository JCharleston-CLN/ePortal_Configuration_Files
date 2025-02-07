#!/usr/bin/env bash

clear
echo ****************************************************************************
echo  Title: TuxCare ePortal Automated Installer Script.
echo  Purpose: Install and base configure TuxCare ePortal.
echo  Created by: Jamie Charleston 
echo  Version: 2.0
echo  Last updated: 02/07/2025
echo
echo     Minimum System Requirements to support 10,000 servers
echo  Linux OS Support: AlmaLinux 8/9, RHEL 8/9, OEL 8/9
echo                    Debian 11/12 , Ubuntu 20.04/22.04/24.04                  
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

# Detect the Linux distribution
DISTRIBUTION=$(lsb_release -is 2>/dev/null)

# If lsb_release is unavailable, try another method
if [[ -z "$DISTRIBUTION" ]]; then
  if [[ -f /etc/redhat-release ]]; then
    DISTRIBUTION="Red Hat"
  elif [[ -f /etc/debian_version ]]; then
    DISTRIBUTION="Debian"
  else
    DISTRIBUTION="Unknown"
  fi
fi

# Detect Ubuntu version if applicable
if [[ "$DISTRIBUTION" == "Ubuntu" ]]; then
  UBUNTU_VERSION=$(lsb_release -rs)
elif [[ "$DISTRIBUTION" == "Debian" ]]; then
  DEBIAN_VERSION=$(cat /etc/debian_version | cut -d'.' -f1)
fi

# Execute commands based on the Linux distribution
if [[ "$DISTRIBUTION" == "Red Hat" ]]; then
  # Execute commands for Red Hat
  bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/AlmaCentOS-eportal-installer.sh)

elif [[ "$DISTRIBUTION" == "Ubuntu" ]]; then
  # Execute commands for Ubuntu
  if (( $(echo "$UBUNTU_VERSION >= 20.04" | bc -l) )) && (( $(echo "$UBUNTU_VERSION < 22.04" | bc -l) )); then
    bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/ubuntu20.04-eportal-installer.sh)
  elif (( $(echo "$UBUNTU_VERSION >= 22.04" | bc -l) )) && (( $(echo "$UBUNTU_VERSION < 24.04" | bc -l) )); then
    bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/ubuntu22.04-eportal-installer.sh)
  elif (( $(echo "$UBUNTU_VERSION >= 24.04" | bc -l) )); then
    bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/ubuntu24.04-eportal-installer.sh)
  else
    echo "Unsupported Ubuntu version detected: $UBUNTU_VERSION"
  fi

elif [[ "$DISTRIBUTION" == "Debian" ]]; then
  # Execute commands for Debian
  if [[ "$DEBIAN_VERSION" == "11" ]]; then
    bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/Debian11-eportal-installer.sh)
  elif [[ "$DEBIAN_VERSION" == "12" ]]; then
    bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/Debian12-eportal-installer.sh)
  else
    echo "Unsupported Debian version detected: $DEBIAN_VERSION"
  fi

else
  echo "Unsupported distribution detected: $DISTRIBUTION"
fi



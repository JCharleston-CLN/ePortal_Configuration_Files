#!/usr/bin/env bash

clear
echo ****************************************************************************
echo  Title: TuxCare ePortal Let\'s Encrypt Certificate Automated Installer Script.
echo  Purpose: Install Let\'s Encrypt requirements and deploy SSL certificate.
echo  Created by: Jamie Charleston and Miguel Varela
echo  Version: 1.5
echo  Last updated: 03/12/2023
echo
echo                        Minimum System Requirements
echo      ePortal installed on AlmaLinux 8, CentOS 7/8, or Ubuntu 20.04/22.04
echo
echo
echo  Legal Disclaimer:
echo  This script is provided "AS IS" and without warranty of any kind.
echo  You, the user, assume any risks associated with the use of this script.
echo  You are solely responsible for the use and misuse of this script.
echo  You agree to indemnify and hold harmless the creator of this script
echo  from any and all claims arising from your use or misuse of the script.
echo ****************************************************************************

# tiny url:  tinyurl.com/2g9gtm7v

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
  bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/eportal-certbot-rhv.sh)
  # Add your commands here for Red Hat
elif [ "$DISTRIBUTION" = "Ubuntu" ]; then
  # Execute commands for Ubuntu
  if [ "$(echo $UBUNTU_VERSION'<'20.04 | bc -l)" -eq 0 ] && [ "$(echo $UBUNTU_VERSION'<'22.04 | bc -l)" -eq 1 ]; then
    # Execute commands for Ubuntu 20.04
    bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/eportal-certbot-ubuntu.sh)
    # Add your commands here for Ubuntu 20.04
  else
    # Execute commands for Ubuntu 22.04 or later
    bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/eportal-certbot-ubuntu.sh)
    # Add your commands here for Ubuntu 22.04 or later
  fi
else
  echo "Unsupported distribution detected"
fi

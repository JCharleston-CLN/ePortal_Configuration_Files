#!/bin/bash
# ****************************************************************************
#  Title: TuxCare Debian 11 ePortal Installer script.
#  Purpose: Install and configure TuxCare ePortal on Ubuntu 20.04.
#  Created by: Jamie Charleston
#  Version: 1.3
#  Last updated: 02/05/2025
#
#  Legal Disclaimer:
#  This script is provided "AS IS" and without warranty of any kind.
#  You, the user, assume any risks associated with the use of this script.
#  You are solely responsible for the use and misuse of this script.
#o  You agree to indemnify and hold harmless the creator of this script
#  from any and all claims arising from your use or misuse of the script.
# ****************************************************************************

clear
echo "Let's get started."
echo
echo First we are going to conifigure your server for the ePortal Installation
echo
echo

apt update && apt install -y --no-install-recommends curl ca-certificates

curl https://repo.cloudlinux.com/kernelcare/kernelcare.gpg -o /usr/share/keyrings/kcare-eportal.gpg

at > /etc/apt/sources.list.d/kcare-eportal.list <<EOL
deb [signed-by=/usr/share/keyrings/kcare-eportal.gpg] https://repo.cloudlinux.com/kcare-eportal/debian/11 kcare main
EOL


echo TuxCare Repo has been configured.
sleep 4s
clear

echo Now we are going to start installing ePortal
echo
echo

apt update && apt install -y --no-install-recommends kcare-eportal


clear

echo ePortal is now installed.
echo
echo
echo "Let's set up your admin password so that you can log into the UI."
echo "Your password must contain at least 10 characters."
while true; do
read -s -p "Enter your password: " varPassword
echo
    if [ ${#varPassword} -ge 10 ]; then
      echo "Password is valid."
      kc.eportal -a admin -p $varPassword
      break
    else
      echo "Error: password should be at least 10 characters. Please try again."
    fi
done


echo Your password has been configured successfully.
sleep 3s

clear

echo "Cache Mode:"
echo ""
echo "     Would you like to enable ePortal to Cache Patches?"
echo "     This will cache meta-data and only store required patches on local server for two weeks."
echo "     This greatly reduces the size of your eportal server as well as any backups."
echo ""
echo "Please type 'yes' or 'no'"

read varCache
a=$varCache

if [ $a == yes ]
then
     clear
     echo "We are now configuring your ePortal to Cache patches.  "

            FILE=/etc/eportal/config
            if [ -f "$FILE" ]; then
cat <<-EOT>>/etc/eportal/config
CACHE_MODE = True
EOT
chown nginx:nginx /etc/eportal/config
            else
touch /etc/eportal/config
cat <<-EOT>>/etc/eportal/config
CACHE_MODE = True
EOT
chown nginx:nginx /etc/eportal/config
            fi
     else
       clear
       echo "Caching Mode will not be set."
       sleep 3s
     fi

clear
echo "Business Unit Separation:"
echo ""
echo "Would you like to enable Managing Multiple Business Units in Isolation?"
echo ""
echo "Please type 'yes' or 'no'"

read varCache
a=$varCache

if [ $a == yes ]
then
     clear
     echo "We are now configuring your ePortal to enable BU Isolation.  "

            FILE=/etc/eportal/config
            if [ -f "$FILE" ]; then
cat <<-EOT>>/etc/eportal/config
BUNITS = True
BUNITS_LOGIN_SELECTOR = True
BUNITS_SELECTOR = True
EOT
chown nginx:nginx /etc/eportal/config
            else
touch /etc/eportal/config
cat <<-EOT>>/etc/eportal/config
BUNITS = True
BUNITS_LOGIN_SELECTOR = True
BUNITS_SELECTOR = True
EOT
chown nginx:nginx /etc/eportal/config
            fi
     else
       clear
       echo "Business Unit Isolation will not be configured."
       sleep 3s
     fi

     
clear
echo "     Do you need to configure your ePortal to work with a Proxy?"
echo "     This may be required if you need FedRAMP or other security requirements."
echo ""
echo "**** If you configure this you will need to make sure your Proxy is properly configured. ****"
echo "**** If you continue with this configuration now, you need to provide the Proxy URL. ****"
echo "**** If you do not have the Proxy URL or Proxy configured, you can edit these settings later. ****"
echo "**** Instructions:  https://docs.kernelcare.com/kernelcare-enterprise/#how-to-adjust-proxy-on-eportal-machine ****"
echo ""
echo "Please type 'yes' or 'no'"
read varAnswer
a=$varAnswer
if [ $a == yes ]
then
     clear
     echo "Please provide your full proxy url in full format: i.e.  https://example.com:3128  "
     read varProxy
            FILE=//etc/eportal/config
            if [ -f "$FILE" ]; then
cat <<-EOT>>/etc/eportal/config
PROXY = '$varProxy'
EOT
chown nginx:nginx /etc/eportal/config
systemctl restart eportal
            else
touch /etc/eportal/config
cat <<-EOT>>/etc/eportal/config
PROXY = '$varProxy'
EOT
chown nginx:nginx /etc/eportal/config
systeclt restart eportal
            fi
     else
       clear
       echo ePortal will not be configured for Proxy Configuration
       sleep 3s
     fi
clear
echo We are now going to restart your eportal to make sure all the configurations have taken.
systemctl stop eportal
sleep 3s
systemctl start eportal
sleep 3s
echo
echo

sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow http
sudo ufw allow https


echo Your ePortal has been installed. It is now ready for you to login and finish synchronization.
echo You can log in at http://YourServerIP or FQDN
echo
echo
echo For additional information to configure your feed credentials look at
echo https://docs.tuxcare.com/eportal/\#installation

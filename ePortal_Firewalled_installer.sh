#!/bin/bash
# This script is written and provided as is by Jamie Charleston - Director of Global Sales Engineering for use with TuxCare ePortal.
# This package is for assisting organizations that need to install ePortal behind a firewall. This package assumes you are running it
# on a server which is defined by eportal requirements.

echo
echo
echo Welcome to the TuxCare ePortal Firewalled installer.
echo This script is written and provided as is by Jamie Charleston - Director of Global Sales Engineering for use with TuxCare ePortal.
echo This package is for assisting organizations that need to install ePortal behind a firewall. This package assumes you are running it
echo on a server which is defined by eportal requirements.
echo
echo Lets install ePortal.
echo

rpm -ihv *.rpm

echo ePortal has been installed.
sleep 2s
clear

echo "Let's set up your admin password so that you can log into the UI."
echo What would you like to use for the admin password?
read varPassword

kc.eportal -a admin -p $varPassword


echo Your password has been configured successfully.
sleep 3s

clear


clear


echo
echo
echo Your ePortal has been installed. It is now ready for you to login and finish synchronization.
echo You can log in at http://YourServerIP or FQDN
echo
echo
echo For additional information to configure your feed credentials look at
echo https://docs.tuxcare.com/eportal/\#installation

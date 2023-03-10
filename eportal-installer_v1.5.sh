#!/bin/bash

echo Welcome to the TuxCare ePortal installation Process.
echo
echo This script is written and provided as is by Jamie Charleston - Director of Global Sales Engineering at TuxCare.
echo This script is for assisting organizations that need to install ePortal. This script assumes installation
echo on an appropriate OS with 1G ram, 1 CPU and 25G disk space minimum for caching mode and internet access as required.
echo This script is current as of March 10, 2023
echo
echo
sleep 5s
clear
echo "Let's get started."
echo
echo First we are going to add the Nginx repo
echo
echo

cat > /etc/yum.repos.d/nginx.repo <<EOL
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/\$basearch/
gpgcheck=0
enabled=1
EOL


echo Nginx repo is now configured.
sleep 4s
clear

echo "Now we are adding the TuxCare ePortal repo."
echo
echo


cat > /etc/yum.repos.d/kcare-eportal.repo <<EOL
[kcare-eportal]
name=KernelCare ePortal
baseurl=https://repo.cloudlinux.com/kcare-eportal/\$releasever/\$basearch/
enabled=1
gpgkey=https://repo.cloudlinux.com/kernelcare/RPM-GPG-KEY-KernelCare
gpgcheck=1
EOL


echo TuxCare Repo has been configured.
sleep 4s
clear

echo Now we are going to start installing ePortal
echo
echo

echo "We are checking to see if you have SELinux."

SELINUX_STATE=$(getenforce)

if [ "$SELINUX_STATE" == "Enforcing" ] || [ "$SELINUX_STATE" == "Permissive" ] ; then
  echo ""
  echo "SELinux is enabled"
  echo "We are now installing ePortal with SELinux enabled."
  sleep 4s
  
  yum -y install kcare-eportal-selinux
  
else
  echo ""
  echo "SELinux is disabled (or missing)"
  echo "We are now installing ePortal with SELinux disabled."
  sleep 4s
  
  yum -y install kcare-eportal
  
fi 

clear

echo ePortal is now installed.
echo
echo
echo "Let's set up your admin password so that you can log into the UI."
echo "What would you like to use for the admin password?"
read -s varPassword

kc.eportal -a admin -p $varPassword


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
echo Your ePortal has been installed. It is now ready for you to login and finish synchronization.
echo You can log in at http://YourServerIP or FQDN
echo
echo
echo For additional information to configure your feed credentials look at
echo https://docs.tuxcare.com/eportal/\#installation

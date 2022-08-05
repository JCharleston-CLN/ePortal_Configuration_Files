#!/bin/bash

echo Welcome to the TuxCare Air-gapped ePortal installation packager.
echo
echo This script is written and provided as is by Jamie Charleston - Director of Global Sales Engineering at TuxCare.
echo This script is for assisting organizations that need to install ePortal. This script assumes installation
echo on an appropriate OS with 1G ram, 1 CPU and 200G disk space minimum.
echo This script is current as of AUG, 2022
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

echo We are now going to install the yum download-only plugin
echo
echo
echo
yum install yum-plugin-downloadonly


echo Now we are preparing to download all the eportal packages.
echo
echo

echo "We are checking to see if you have SELinux."

SELINUX_STATE=$(getenforce)

if [ "$SELINUX_STATE" == "Enforcing" ] || [ "$SELINUX_STATE" == "Permissive" ] ; then
  echo ""
  echo "SELinux is enabled"
  echo "We are now installing ePortal with SELinux enabled."
  sleep 4s
  
  yum -y install --downloadonly --downloaddir=/root/mypackages/  kcare-eportal-selinux

  wget https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/ePortal_Firewalled_installer.sh -P /root/mypackages
  
else
  echo ""
  echo "SELinux is disabled (or missing)"
  echo "We are now installing ePortal with SELinux disabled."
  sleep 4s
  
  yum -y install --downloadonly --downloaddir=/root/mypackages/ kcare-eportal

  wget https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/ePortal_Firewalled_installer.sh -P /root/mypackages
  
fi 

clear


echo The TuxCare ePortal packages have now beend downloaded to the mypackages folder in the root directory.
echo These should be all the files required to install eportal on your like OS image behind the firewall.
echo Move these packages to live OS image server, with root owner, and run sh ePortal_Firewalled_installer.sh 
echo After this, you can set up the ePortal admin as outlined in the instructions at docs.kernelcare.com

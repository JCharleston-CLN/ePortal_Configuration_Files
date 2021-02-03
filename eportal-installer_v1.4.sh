#!/bin/bash
# This script is written and provided as is by Jamie Charleston - Senior Sales Engineer at CloudLinux for use with KernelCare ePortal.
# This package is for assisting organizations that need to install ePortal with or without KernelCare+ Support. This script will assumes installation
# on a CentOS 7 server with SELinux disabled, 1G ram, 1 CPU and 200G disk space and internet access.
# This script is current as of Sep 22, 2020


base64 -d <<<"IF9fICBfX18gICBfX19fX18gICAgIF9fX19fX18gLl9fX19fXyAgICAgX19fX19fICAgLl9fX19fXyAgICAgLl9fX19fX19fX19fLiAgICBfX18gICAgICAgX18gICAgICAKfCAgfC8gIC8gIC8gICAgICB8ICAgfCAgIF9fX198fCAgIF8gIFwgICAvICBfXyAgXCAgfCAgIF8gIFwgICAgfCAgICAgICAgICAgfCAgIC8gICBcICAgICB8ICB8ICAgICAKfCAgJyAgLyAgfCAgLC0tLS0nICAgfCAgfF9fICAgfCAgfF8pICB8IHwgIHwgIHwgIHwgfCAgfF8pICB8ICAgYC0tLXwgIHwtLS0tYCAgLyAgXiAgXCAgICB8ICB8ICAgICAKfCAgICA8ICAgfCAgfCAgICAgICAgfCAgIF9ffCAgfCAgIF9fXy8gIHwgIHwgIHwgIHwgfCAgICAgIC8gICAgICAgIHwgIHwgICAgICAvICAvX1wgIFwgICB8ICB8ICAgICAKfCAgLiAgXCAgfCAgYC0tLS0uICAgfCAgfF9fX18gfCAgfCAgICAgIHwgIGAtLScgIHwgfCAgfFwgIFwtLS0tLiAgIHwgIHwgICAgIC8gIF9fX19fICBcICB8ICBgLS0tLS4KfF9ffFxfX1wgIFxfX19fX198ICAgfF9fX19fX198fCBffCAgICAgICBcX19fX19fLyAgfCBffCBgLl9fX19ffCAgIHxfX3wgICAgL19fLyAgICAgXF9fXCB8X19fX19fX3wKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA="
echo
echo
echo Welcome to the KernelCare ePortal installation Process.
echo This script is written and provided as is by Jamie Charleston - Senior Sales Engineer at CloudLinux for use with KernelCare ePortal.
echo This package is for assisting organizations that need to install ePortal with or without KernelCare+ Support. This script will assumes installation
echo on a CentOS 7 server with SELinux disabled, 1G ram, 1 CPU and 200G disk space and internet access.
echo This script is current as of Sep 22, 2020
echo
echo
echo "Let's get started."
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


echo nginx repo configured.
sleep 2s
clear

echo Next we are adding the kernelcare eportal repo
echo
echo

cat > /etc/yum.repos.d/kcare-eportal.repo <<EOL
[kcare-eportal]
name=KernelCare ePortal
baseurl=https://repo.eportal.kernelcare.com/x86_64.el7/
enabled=1
gpgkey=https://repo.cloudlinux.com/kernelcare/RPM-GPG-KEY-KernelCare
gpgcheck=1
EOL

echo KernelCare Repo has been configured.
sleep 2s
clear

echo Now we are going to start installing eportal
echo
echo

yum -y install kcare-eportal


clear

echo ePortal is now installed.
echo
echo
echo "Let's set up your admin password so that you can log into the UI."
echo What would you like to use for the admin password?
read varPassword

kc.eportal -a admin -p $varPassword


echo Your password has been configured successfully.
sleep 3s

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
     echo "Please provide your full proxy url in full format: i.e.  https://example.com  "
     read varProxy


            FILE=/usr/share/kcare-eportal/config/local.py
            if [ -f "$FILE" ]; then
cat <<-EOT>>/usr/share/kcare-eportal/config/local.py
PROXY = '$varProxy'
EOT
systemctl restart eportal

            else
touch /usr/share/kcare-eportal/config/local.py
cat <<-EOT>>/usr/share/kcare-eportal/config/local.py
PROXY = '$varProxy'
EOT

chown nginx:nginx /usr/share/kcare-eportal/config/local.py

systeclt restart eportal


            fi



     else

       clear
       echo ePortal will not be configured for Proxy Configuration
       sleep 3s

     fi


clear
base64 -d <<<"IF9fICBfX18gICBfX19fX18gICAgIF9fX19fX18gLl9fX19fXyAgICAgX19fX19fICAgLl9fX19fXyAgICAgLl9fX19fX19fX19fLiAgICBfX18gICAgICAgX18gICAgICAKfCAgfC8gIC8gIC8gICAgICB8ICAgfCAgIF9fX198fCAgIF8gIFwgICAvICBfXyAgXCAgfCAgIF8gIFwgICAgfCAgICAgICAgICAgfCAgIC8gICBcICAgICB8ICB8ICAgICAKfCAgJyAgLyAgfCAgLC0tLS0nICAgfCAgfF9fICAgfCAgfF8pICB8IHwgIHwgIHwgIHwgfCAgfF8pICB8ICAgYC0tLXwgIHwtLS0tYCAgLyAgXiAgXCAgICB8ICB8ICAgICAKfCAgICA8ICAgfCAgfCAgICAgICAgfCAgIF9ffCAgfCAgIF9fXy8gIHwgIHwgIHwgIHwgfCAgICAgIC8gICAgICAgIHwgIHwgICAgICAvICAvX1wgIFwgICB8ICB8ICAgICAKfCAgLiAgXCAgfCAgYC0tLS0uICAgfCAgfF9fX18gfCAgfCAgICAgIHwgIGAtLScgIHwgfCAgfFwgIFwtLS0tLiAgIHwgIHwgICAgIC8gIF9fX19fICBcICB8ICBgLS0tLS4KfF9ffFxfX1wgIFxfX19fX198ICAgfF9fX19fX198fCBffCAgICAgICBcX19fX19fLyAgfCBffCBgLl9fX19ffCAgIHxfX3wgICAgL19fLyAgICAgXF9fXCB8X19fX19fX3wKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA="
# grab your IP address
ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

echo
echo
echo Your ePortal has been installed. It is now ready for you to login and finish synchronization.
echo You can log in at http://$ip4
echo
echo
echo For additional information to configure your feed credentials look at
echo https://docs.kernelcare.com/kernelcare_enterprise/#patchset-deployment

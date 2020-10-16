#!/bin/bash
# This script is written and provided as is by Jamie Charleston - Senior Sales Engineer at CloudLinux for use with KernelCare ePortal.
# This package is for assisting organizations that need to upgrade ePortal with KernelCare+ Support. This script will assumes installation
# on a CentOS 7 server with SELinux disabled, 1G ram, 1 CPU and 200G disk space and internet access with base ePortal already installed.
# This script is current as of Sep 24, 2020


base64 -d <<<"IF9fICBfX18gICBfX19fX18gICAgIF9fX19fX18gLl9fX19fXyAgICAgX19fX19fICAgLl9fX19fXyAgICAgLl9fX19fX19fX19fLiAgICBfX18gICAgICAgX18gICAgICAKfCAgfC8gIC8gIC8gICAgICB8ICAgfCAgIF9fX198fCAgIF8gIFwgICAvICBfXyAgXCAgfCAgIF8gIFwgICAgfCAgICAgICAgICAgfCAgIC8gICBcICAgICB8ICB8ICAgICAKfCAgJyAgLyAgfCAgLC0tLS0nICAgfCAgfF9fICAgfCAgfF8pICB8IHwgIHwgIHwgIHwgfCAgfF8pICB8ICAgYC0tLXwgIHwtLS0tYCAgLyAgXiAgXCAgICB8ICB8ICAgICAKfCAgICA8ICAgfCAgfCAgICAgICAgfCAgIF9ffCAgfCAgIF9fXy8gIHwgIHwgIHwgIHwgfCAgICAgIC8gICAgICAgIHwgIHwgICAgICAvICAvX1wgIFwgICB8ICB8ICAgICAKfCAgLiAgXCAgfCAgYC0tLS0uICAgfCAgfF9fX18gfCAgfCAgICAgIHwgIGAtLScgIHwgfCAgfFwgIFwtLS0tLiAgIHwgIHwgICAgIC8gIF9fX19fICBcICB8ICBgLS0tLS4KfF9ffFxfX1wgIFxfX19fX198ICAgfF9fX19fX198fCBffCAgICAgICBcX19fX19fLyAgfCBffCBgLl9fX19ffCAgIHxfX3wgICAgL19fLyAgICAgXF9fXCB8X19fX19fX3wKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA="
echo
echo
echo Welcome to the KernelCare ePortal installation Process.
echo This script is written and provided as is by Jamie Charleston - Senior Sales Engineer at CloudLinux for use with KernelCare ePortal.
echo This package is for assisting organizations that need to upgrade ePortal with KernelCare+ Support. This script will assumes installation
echo on a CentOS 7 server with SELinux disabled, 1G ram, 1 CPU and 200G disk space and internet access with base ePortal already installed
echo This script is current as of Sep 24, 2020
echo
echo


echo "Please confirm you are ready to upgrade your ePortal to support KernelCare+ ?"
echo "Please type 'yes' or 'no'"

read varAnswer
a=$varAnswer

if [ $a == yes ]
then
     clear
     echo We are now going to configure ePortal to work with KernelCare+ packages
     sleep 2s
     echo We are going to download our base userspace file...

     wget https://github.com/JCharleston-CLN/ePortal_Configuration_Files/raw/master/userspace-20201015-125324.tar.gz

     echo ""
     echo ""
     echo File was downloaded successfully
     echo ""
     echo "Extract it to the portal's static files location"

       rm -rf /usr/share/kcare-eportal/userspace/

       tar xf ./userspace-20201015-125324.tar.gz -C /usr/share/kcare-eportal/

      echo ""
      echo ""
      echo   "Add nginx location for the new files, if it not exists:"

       grep -qF 'userspace' /etc/nginx/conf.d/eportal.conf || sed -i "\$i location ~* ^/userspace/(.*)/(.*)/kpatch.tgz$ {alias /usr/share/kcare-eportal; try_files /userspace/all/\$2.tgz =404;}" /etc/nginx/conf.d/eportal.conf


      echo ""
      echo ""
      echo New files have been added and properly updated
      sleep 3s
      echo ""
      echo ""
      echo Reload nginx

       systemctl reload nginx

       echo "."
       echo ".."
       echo "..."
       echo Eportal configured for KernelCare+
       sleep 5s
  else
    clear
    echo ePortal will not be configured for KernelCare+
    sleep 5s

  fi

clear
base64 -d <<<"IF9fICBfX18gICBfX19fX18gICAgIF9fX19fX18gLl9fX19fXyAgICAgX19fX19fICAgLl9fX19fXyAgICAgLl9fX19fX19fX19fLiAgICBfX18gICAgICAgX18gICAgICAKfCAgfC8gIC8gIC8gICAgICB8ICAgfCAgIF9fX198fCAgIF8gIFwgICAvICBfXyAgXCAgfCAgIF8gIFwgICAgfCAgICAgICAgICAgfCAgIC8gICBcICAgICB8ICB8ICAgICAKfCAgJyAgLyAgfCAgLC0tLS0nICAgfCAgfF9fICAgfCAgfF8pICB8IHwgIHwgIHwgIHwgfCAgfF8pICB8ICAgYC0tLXwgIHwtLS0tYCAgLyAgXiAgXCAgICB8ICB8ICAgICAKfCAgICA8ICAgfCAgfCAgICAgICAgfCAgIF9ffCAgfCAgIF9fXy8gIHwgIHwgIHwgIHwgfCAgICAgIC8gICAgICAgIHwgIHwgICAgICAvICAvX1wgIFwgICB8ICB8ICAgICAKfCAgLiAgXCAgfCAgYC0tLS0uICAgfCAgfF9fX18gfCAgfCAgICAgIHwgIGAtLScgIHwgfCAgfFwgIFwtLS0tLiAgIHwgIHwgICAgIC8gIF9fX19fICBcICB8ICBgLS0tLS4KfF9ffFxfX1wgIFxfX19fX198ICAgfF9fX19fX198fCBffCAgICAgICBcX19fX19fLyAgfCBffCBgLl9fX19ffCAgIHxfX3wgICAgL19fLyAgICAgXF9fXCB8X19fX19fX3wKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA="
# grab your IP address
ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

echo
echo
echo Your ePortal has been upgraded to support KernelCare+. It is now ready for you to login and use as normal.
echo You can log in at http://$ip4
echo
echo

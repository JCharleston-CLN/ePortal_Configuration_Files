#  CentOS 7 RHEL 7 eportal install script - Jamie Charleston - Senior Sales Engineer - CloudLinux
#  Current as of March 5, 2020

base64 -d <<<"IF9fICBfX18gICBfX19fX18gICAgIF9fX19fX18gLl9fX19fXyAgICAgX19fX19fICAgLl9fX19fXyAgICAgLl9fX19fX19fX19fLiAgICBfX18gICAgICAgX18gICAgICAKfCAgfC8gIC8gIC8gICAgICB8ICAgfCAgIF9fX198fCAgIF8gIFwgICAvICBfXyAgXCAgfCAgIF8gIFwgICAgfCAgICAgICAgICAgfCAgIC8gICBcICAgICB8ICB8ICAgICAKfCAgJyAgLyAgfCAgLC0tLS0nICAgfCAgfF9fICAgfCAgfF8pICB8IHwgIHwgIHwgIHwgfCAgfF8pICB8ICAgYC0tLXwgIHwtLS0tYCAgLyAgXiAgXCAgICB8ICB8ICAgICAKfCAgICA8ICAgfCAgfCAgICAgICAgfCAgIF9ffCAgfCAgIF9fXy8gIHwgIHwgIHwgIHwgfCAgICAgIC8gICAgICAgIHwgIHwgICAgICAvICAvX1wgIFwgICB8ICB8ICAgICAKfCAgLiAgXCAgfCAgYC0tLS0uICAgfCAgfF9fX18gfCAgfCAgICAgIHwgIGAtLScgIHwgfCAgfFwgIFwtLS0tLiAgIHwgIHwgICAgIC8gIF9fX19fICBcICB8ICBgLS0tLS4KfF9ffFxfX1wgIFxfX19fX198ICAgfF9fX19fX198fCBffCAgICAgICBcX19fX19fLyAgfCBffCBgLl9fX19ffCAgIHxfX3wgICAgL19fLyAgICAgXF9fXCB8X19fX19fX3wKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA="
echo
echo
echo Welcome to the KernelCare ePortal installation Process. This should take less than a minute to complete.
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

echo Now we are going to start installing eportal
echo
echo

yum -y install kcare-eportal

echo ePortal has been installed. What would you like to use for the admin password?
read varPassword

kc.eportal -a admin -p $varPassword

clear

echo Do you want to configure ePortal to work with KernelCare+
echo Please type yes or no

read varAnswer
a=$varAnswer

if [ $a == yes ]
then
     clear
     echo We are now going to configure ePortal to work with KernelCare+ packages
     echo We are going to download our base userspace file...

     wget https://github.com/Revmagi/eportal_installer/raw/master/userspace-20200720-074750.tar.gz

     echo ""
     echo ""
     echo File was downloaded successfully
     echo ""
     echo "Extract it to the portal's static files location"

       rm -rf /usr/share/kcare-eportal/userspace/

       tar xf ./userspace-20200720-074750.tar.gz -C /usr/share/kcare-eportal/

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

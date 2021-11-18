#!/bin/bash
# This script is written and provided as is by Jamie Charleston - Senior Sales Engineer at CloudLinux for use with TuxCare ePortal.
# This package is for assisting organizations that need to install ePortal. This installer will assume you are installing
# on a compatible OS with 1G ram, 1 CPU and 200G disk space min and internet access as required.
# This script is current as of Nov 18, 2021


base64 -d <<<"X19fX19fX19fICAgICAgICAgICAgICAgICAgIF9fX19fX18gIF9fX19fX18gIF9fX19fX18gIF9f
X19fX18gICAgX19fX19fXyAgX19fX19fXyAgX19fX19fXyAgX19fX19fXyBfX19fX19fX18gX19f
X19fXyAgXyAgICAgICAKXF9fICAgX18vfFwgICAgIC98fFwgICAgIC98KCAgX19fXyBcKCAgX19f
ICApKCAgX19fXyApKCAgX19fXyBcICAoICBfX19fIFwoICBfX19fICkoICBfX18gICkoICBfX19f
IClcX18gICBfXy8oICBfX18gICkoIFwgICAgICAKICAgKSAoICAgfCApICAgKCB8KCBcICAgLyAp
fCAoICAgIFwvfCAoICAgKSB8fCAoICAgICl8fCAoICAgIFwvICB8ICggICAgXC98ICggICAgKXx8
ICggICApIHx8ICggICAgKXwgICApICggICB8ICggICApIHx8ICggICAgICAKICAgfCB8ICAgfCB8
ICAgfCB8IFwgKF8pIC8gfCB8ICAgICAgfCAoX19fKSB8fCAoX19fXyl8fCAoX18gICAgICB8IChf
XyAgICB8IChfX19fKXx8IHwgICB8IHx8IChfX19fKXwgICB8IHwgICB8IChfX18pIHx8IHwgICAg
ICAKICAgfCB8ICAgfCB8ICAgfCB8ICApIF8gKCAgfCB8ICAgICAgfCAgX19fICB8fCAgICAgX18p
fCAgX18pICAgICB8ICBfXykgICB8ICBfX19fXyl8IHwgICB8IHx8ICAgICBfXykgICB8IHwgICB8
ICBfX18gIHx8IHwgICAgICAKICAgfCB8ICAgfCB8ICAgfCB8IC8gKCApIFwgfCB8ICAgICAgfCAo
ICAgKSB8fCAoXCAoICAgfCAoICAgICAgICB8ICggICAgICB8ICggICAgICB8IHwgICB8IHx8IChc
ICggICAgICB8IHwgICB8ICggICApIHx8IHwgICAgICAKICAgfCB8ICAgfCAoX19fKSB8KCAvICAg
XCApfCAoX19fXy9cfCApICAgKCB8fCApIFwgXF9ffCAoX19fXy9cICB8IChfX19fL1x8ICkgICAg
ICB8IChfX18pIHx8ICkgXCBcX18gICB8IHwgICB8ICkgICAoIHx8IChfX19fL1wKICAgKV8oICAg
KF9fX19fX18pfC8gICAgIFx8KF9fX19fX18vfC8gICAgIFx8fC8gICBcX18vKF9fX19fX18vICAo
X19fX19fXy98LyAgICAgICAoX19fX19fXyl8LyAgIFxfXy8gICApXyggICB8LyAgICAgXHwoX19f
X19fXy8KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAK"
echo
echo
echo Welcome to the TuxCare ePortal installation Process.
echo This script is written and provided as is by Jamie Charleston - Senior Sales Engineer at CloudLinux for use with TuxCare ePortal.
echo This package is for assisting organizations that need to install ePortal. This script will assumes installation
echo on a appropriate OS with 1G ram, 1 CPU and 200G disk space minimum resources and internet access as required.
echo This script is current as of Nov 18, 2021
echo
echo
sleep 5s
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
baseurl=https://repo.cloudlinux.com/kcare-eportal/\$releasever/\$basearch/
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

echo "Do you have SELinux Enabled on this server?"
echo "Please type 'yes' or 'no'"

read varSELAnswer
s=$varSELAnswer

if [ $s == yes ]
then

echo "We are now installing ePortal with SELinux enabled."
yum -y install kcare-eportal-selinux

else

echo "We are now installing ePortal with SELinux disabled."
yum -y install kcare-eportal

     fi
     
     

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
base64 -d <<<"X19fX19fX19fICAgICAgICAgICAgICAgICAgIF9fX19fX18gIF9fX19fX18gIF9fX19fX18gIF9f
X19fX18gICAgX19fX19fXyAgX19fX19fXyAgX19fX19fXyAgX19fX19fXyBfX19fX19fX18gX19f
X19fXyAgXyAgICAgICAKXF9fICAgX18vfFwgICAgIC98fFwgICAgIC98KCAgX19fXyBcKCAgX19f
ICApKCAgX19fXyApKCAgX19fXyBcICAoICBfX19fIFwoICBfX19fICkoICBfX18gICkoICBfX19f
IClcX18gICBfXy8oICBfX18gICkoIFwgICAgICAKICAgKSAoICAgfCApICAgKCB8KCBcICAgLyAp
fCAoICAgIFwvfCAoICAgKSB8fCAoICAgICl8fCAoICAgIFwvICB8ICggICAgXC98ICggICAgKXx8
ICggICApIHx8ICggICAgKXwgICApICggICB8ICggICApIHx8ICggICAgICAKICAgfCB8ICAgfCB8
ICAgfCB8IFwgKF8pIC8gfCB8ICAgICAgfCAoX19fKSB8fCAoX19fXyl8fCAoX18gICAgICB8IChf
XyAgICB8IChfX19fKXx8IHwgICB8IHx8IChfX19fKXwgICB8IHwgICB8IChfX18pIHx8IHwgICAg
ICAKICAgfCB8ICAgfCB8ICAgfCB8ICApIF8gKCAgfCB8ICAgICAgfCAgX19fICB8fCAgICAgX18p
fCAgX18pICAgICB8ICBfXykgICB8ICBfX19fXyl8IHwgICB8IHx8ICAgICBfXykgICB8IHwgICB8
ICBfX18gIHx8IHwgICAgICAKICAgfCB8ICAgfCB8ICAgfCB8IC8gKCApIFwgfCB8ICAgICAgfCAo
ICAgKSB8fCAoXCAoICAgfCAoICAgICAgICB8ICggICAgICB8ICggICAgICB8IHwgICB8IHx8IChc
ICggICAgICB8IHwgICB8ICggICApIHx8IHwgICAgICAKICAgfCB8ICAgfCAoX19fKSB8KCAvICAg
XCApfCAoX19fXy9cfCApICAgKCB8fCApIFwgXF9ffCAoX19fXy9cICB8IChfX19fL1x8ICkgICAg
ICB8IChfX18pIHx8ICkgXCBcX18gICB8IHwgICB8ICkgICAoIHx8IChfX19fL1wKICAgKV8oICAg
KF9fX19fX18pfC8gICAgIFx8KF9fX19fX18vfC8gICAgIFx8fC8gICBcX18vKF9fX19fX18vICAo
X19fX19fXy98LyAgICAgICAoX19fX19fXyl8LyAgIFxfXy8gICApXyggICB8LyAgICAgXHwoX19f
X19fXy8KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAK"

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

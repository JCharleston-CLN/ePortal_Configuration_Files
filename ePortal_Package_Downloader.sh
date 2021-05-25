#!/bin/bash
# This script is written and provided as is by Jamie Charleston - Senior Sales Engineer at CloudLinux for use with TuxCare ePortal.
# This package is for assisting organizations that need to install ePortal behind a firewall. This package assumes you are running it
# on a CentOS 7 server with SELinux disabled.



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
echo Welcome to the TuxCare ePortal package downloader.
echo This script is written and provided as is by Jamie Charleston - Senior Sales Engineer at CloudLinux for use with TuxCare ePortal.
echo This package is for assisting organizations that need to install ePortal behind a firewall. This package assumes you are running it
echo on a CentOS 7 server with SELinux disabled.
echo
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


echo We are now going to install the yum download-only plugin
echo
echo
echo
yum install yum-plugin-downloadonly

echo Now we are going to download all the eportal packages.
echo
echo

yum -y install --downloadonly --downloaddir=/root/mypackages/ kcare-eportal

wget https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/ePortal_Firewalled_installer.sh -P /root/mypackages



echo The TuxCare ePortal packages have now beend downloaded to the mypackages folder in the root directory.
echo These should be all the files required to install eportal on your like OS image behind the firewall.
echo Move these packages to live OS image server, with root owner, and run sh ePortal_Firewalled_installer.sh 
echo After this, you can set up the ePortal admin as outlined in the instructions at docs.kernelcare.com

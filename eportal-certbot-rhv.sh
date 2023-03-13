#!/bin/bash

clear
# ****************************************************************************
#  Title: TuxCare ePortal Let\'s Encrypt configuration tool.
#  Purpose: Install Let\'s Encrypt requirements and deploy SSL certificate.
#  Created by: Jamie Charleston and Miguel Varela of TuxCare
#  Version: 1.0
#  Last updated: 03/12/2023
#
#  Legal Disclaimer:
#  This script is provided "AS IS" and without warranty of any kind.
#  You, the user, assume any risks associated with the use of this script.
#  You are solely responsible for the use and misuse of this script.
#  You agree to indemnify and hold harmless the creator of this script
#  from any and all claims arising from your use or misuse of the script.
#o ****************************************************************************

echo Let\'s get started.
echo We are going to configure the epel-release repository and
echo then install and configure SNAPd
sleep 3
yum -y install epel-release
yum -y install snapd
systemctl enable --now snapd.socket
ln -s /var/lib/snapd/snap /snap
systemctl restart snapd.socket

clear

echo SNAP has been installed, we need to wait a few seconds for it to seed.
echo -n "Waiting "
for i in {1..10}; do
    printf "."
    sleep 3
done

if ! snap wait system seed.loaded; then
    echo "Snap seed did not load successfully"
    exit 1
fi
echo
snap install core; sudo snap refresh core

clear
echo We are now going to install CertBot for Let\'sEncrypt
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
echo CertBot is installed
sleep 3
clear

echo We are about to install your SSL, but first we need some information.
echo Please type your domain name in all lowercase.
read varDomain_name

echo Domain Name: $varDomain_name
echo
echo Please type in your email address:
read varEmail
echo Email address: $varEmail
sleep 3

echo During the installation you will be asked if you want to opt in to Let\'sEncrypts Feedback list.
echo We will let you select if how you would like to respond to this yourself.
sleep 5

echo Installing the SSL..
certbot certonly --nginx -m $varEmail --agree-tos -d $varDomain_name --key-type ecdsa --elliptic-curve secp384r1
echo Configuring nginx...
mv /etc/nginx/eportal.ssl.conf.example /etc/nginx/eportal.ssl.conf
grep -c "include eportal.ssl.conf;" /etc/nginx/conf.d/eportal.conf || sed -i "3i \ include eportal.ssl.conf;" /etc/nginx/conf.d/eportal.conf
sed -i -e "s|server_name.*|server_name $varDomain_name;|g" /etc/nginx/eportal.ssl.conf
sed -i -e "s|ssl_certificate .*|ssl_certificate /etc/letsencrypt/live/$varDomain_name/fullchain.pem;|" /etc/nginx/eportal.ssl.conf
sed -i -e "s|ssl_certificate_key .*|ssl_certificate_key /etc/letsencrypt/live/$varDomain_name/privkey.pem;|" /etc/nginx/eportal.ssl.conf

echo The certificat as been installed. We are now going to restart Nginx.
# Restart Nginx
sudo systemctl restart nginx

# Check status
if sudo systemctl is-active --quiet nginx; then
    echo "Nginx restarted successfully"
else
    echo "Failed to restart Nginx"
fi

sleep 3
clear


echo Let\'s finish by checking your firewall, we need port 443 enabled.

function enable_port_443() {
    # Check if firewalld is running and enabled
    if ! systemctl is-active firewalld &> /dev/null || ! systemctl is-enabled firewalld &> /dev/null; then
        echo "Firewalld is not running and enabled"
        return
    fi

    # Check if port 443 is already enabled
    if sudo firewall-cmd --query-port=443/tcp | grep -q 'yes'; then
        echo "Port 443 is already enabled"
        return
    fi

    # Enable port 443
    echo "Enabling port 443..."
    sudo firewall-cmd --add-port=443/tcp --permanent
    sudo firewall-cmd --reload
}

# Call the function to enable port 443
enable_port_443

echo Done!
echo You may visit your ePortal at https://$varDomain_name

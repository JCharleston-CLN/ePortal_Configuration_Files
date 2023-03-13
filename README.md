Welcome to my TuxCare ePortal configuration Files.

My name is Jamie Charleston, I am the Senior Sales Engineer for CloudLinux which includes TuxCare solutions. This github account are my scripts to simplify the lives our our customers who want to install our solutions without a lot of fuss. I will work to keep these files updated and relevant. As we make updates in our core files on our company website I will remove outdated files from this list.



                                                           Table of Content




tuxcare-eportal-installer.sh

This is the master install script for TuxCare ePortal for all supported distributions. Copy and past the command below and answer the three questions and your ePortal will be properly installed and configured.


       bash <(wget -qO- https://tinyurl.com/2gcf7f5s)


tuxcare-eportal-ssl-installer.sh

This is the master install script for installing an Authoritative SSL Certificate from Let's Encrypt for free on your ePortal. Copy and paste the command below and answer the questions and your ePortal will be properly configured with a new SSL Certificate and adjusted to operations on port 443. 
**We suggest you put in your SSL certificate before registering agents to the ePortal. If you do not, you will need to update those servers later to use port 443 via updating their kcare.conf file and changing the url to https:// path.


      
      bash < (wget -qO- https://tinyurl.com/2g9gtm7v)



ePortal_Package_Downloader.sh  
 
This script is for those organizations who are building an ePortal behind their firewall and do not have internet access. As most administrators know, Linux requires specific packages for your current OS install. To make sure you have our eportal installer and all dependancies please set up a server instance with an image identical to the os image used behind the firewall. Then you can run this script to get all of the files required. You will be able to gather the files in the root/mypackages folder and move them to the final server behind the firewall. Then just run the attached script included in the bundle of files. This file is called ePortal_Firewalled_installer.sh To run this file on your server just execute this command as root on the command line: 

            bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/ePortal_Package_Downloader.sh)





-- ePortal_Firewalled_installer.sh
 
 
This file is part of ePortal_Package_Downloader. It is not meant to be downloaded independantly. When you have moved over all of your files gathered by ePortal_Package_Downloader.sh script to your new server behind the firewall. Just execute this script to finish all the parts of your installation behind firewall. this install provides option to install KC+ configuration or keep as just KC itself.
 


CentOS7 POC Builder

This script is for helping prepare a server for testing with your POV ( Proof of Value). This script is for use with a CentOS 7 server and will download and install the original Kernel, glibc and openssl packages and reboot the server. This way you know that your server has vulnerable items which will get patched. Copy and paste the code below into your server has root.


bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/CentOS7_POC_BUILDER)

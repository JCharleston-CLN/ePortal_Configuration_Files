Welcome to my KernelCare / ePortal configuration Files.

My name is Jamie Charleston, I am the Senior Sales Engineer for CloudLinux which includes KernelCare solutions. This github account are my scripts to simplify the lives our our customers who want to install our solutions without a lot of fuss. I will work to keep these files updated and relevant. As we make updates in our core files on our company website I will remove outdated files from this list.



                                                           Table of Content




eportal-installer_v1.4.sh  

This file is for preparing a server for eportal installation and configuration. This script is expecting a CentOS 7 or 8 server with SELinux disabled, 1 CPU, 1G ram and 200G disk space at min per 10,000 servers. This script assumes the server has access to the internet. This script provides you the option to configure this ePortal for use with a Proxy or not.
You do not need to download the script, it can be run by copy and paste as root on the command line. 

        bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/eportal-installer_v1.4.sh)

 The installer will ask you to provide a password for the 'admin' user. Then it will ask you if you want KC+ integration. Please answer 'yes' or 'no'. That is all. After installation you can log into ePortal and finish configuration as per our docs with credentials provided by your accout manager.




ePortal_KC+_Upgrader_v1.2.sh  

This package is for assisting organizations that need to upgrade ePortal with KernelCare+ Support. This script will assumes installation
on a CentOS 7 server with SELinux disabled, 1G ram, 1 CPU and 200G disk space and internet access with base ePortal already installed.
This script is current as of Sep 24, 2020
To run this file on your server just execute this command as root on the command line:

        bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/eportal_KC%2B_Upgrader_v1.2.sh)
 
 **** No Longer needed as of install 1.4  ****



ePortal_Package_Downloader.sh  
 
This script is for those organizations who are building an ePortal behind their firewall and do not have internet access. As most administrators know, Linux requires specific packages for your current OS install. To make sure you have our eportal installer and all dependancies please set up a server instance with an image identical to the os image used behind the firewall. Then you can run this script to get all of the files required. You will be able to gather the files in the root/mypackages folder and move them to the final server behind the firewall. Then just run the attached script included in the bundle of files. This file is called ePortal_Firewalled_installer.sh To run this file on your server just execute this command as root on the command line: 

            bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/ePortal_Package_Downloader.sh)





-- ePortal_Firewalled_installer.sh
 
 
This file is part of ePortal_Package_Downloader. It is not meant to be downloaded independantly. When you have moved over all of your files gathered by ePortal_Package_Downloader.sh script to your new server behind the firewall. Just execute this script to finish all the parts of your installation behind firewall. this install provides option to install KC+ configuration or keep as just KC itself.
 

 
 
 -- userspace-xxxxx  
 
This file is part of the eportal configuration for KC+


CentOS7 POC Builder

bash <(wget -qO- https://raw.githubusercontent.com/JCharleston-CLN/ePortal_Configuration_Files/master/CentOS7_POC_BUILDER)

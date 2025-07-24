#!/bin/bash
# ****************************************************************************
#  Title: TuxCare Ubuntu 20.04 ePortal Installer script.
#  Purpose: Install and configure TuxCare ePortal on Ubuntu 20.04.
#  Created by: Jamie Charleston
#  Version: 1.4
#  Last updated: 07/23/2025
#
#  Legal Disclaimer:
#  This script is provided "AS IS" and without warranty of any kind.
#  You, the user, assume any risks associated with the use of this script.
#  You are solely responsible for the use and misuse of this script.
#  You agree to indemnify and hold harmless the creator of this script
#  from any and all claims arising from your use or misuse of the script.
# ****************************************************************************

# Function to log messages with timestamps
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if repository is already configured correctly
check_apt_repo() {
    local repo_file="$1"
    local expected_url="$2"
    local repo_name="$3"
    
    if [ -f "$repo_file" ]; then
        if grep -q "$expected_url" "$repo_file" && grep -q "focal main" "$repo_file"; then
            log_message "$repo_name repository already exists and is properly configured."
            return 0
        else
            log_message "$repo_name repository file exists but configuration is incorrect. Updating..."
            return 1
        fi
    else
        log_message "$repo_name repository does not exist. Creating..."
        return 1
    fi
}

# Function to validate package installation
validate_package_install() {
    local package_name="$1"
    
    if dpkg -l | grep -q "^ii.*$package_name"; then
        log_message "$package_name is installed successfully."
        return 0
    else
        log_message "ERROR: $package_name installation failed!"
        return 1
    fi
}

# Function to validate service installation and status
validate_service() {
    local service_name="$1"
    local package_name="$2"
    
    # Check if package is installed
    if ! validate_package_install "$package_name"; then
        exit 1
    fi
    
    # Check if service exists
    if systemctl list-unit-files | grep -q "$service_name"; then
        log_message "$service_name service is available."
        
        # Enable the service
        systemctl enable "$service_name"
        
        # Check if service can start
        if systemctl start "$service_name"; then
            log_message "$service_name service started successfully."
            sleep 3
            
            # Verify service is running
            if systemctl is-active --quiet "$service_name"; then
                log_message "$service_name service is running."
                return 0
            else
                log_message "WARNING: $service_name service failed to start properly."
                return 1
            fi
        else
            log_message "ERROR: Failed to start $service_name service!"
            return 1
        fi
    else
        log_message "ERROR: $service_name service not found!"
        return 1
    fi
}

# Function to get server IP address
get_server_ip() {
    # Try multiple methods to get the IP
    local ip=""
    
    # Method 1: ip route (most reliable for getting the IP used for internet access)
    ip=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'src \K\S+' | head -1)
    
    # Method 2: hostname -I (fallback)
    if [ -z "$ip" ]; then
        ip=$(hostname -I | awk '{print $1}')
    fi
    
    # Method 3: ifconfig (if available)
    if [ -z "$ip" ] && command -v ifconfig >/dev/null; then
        ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -1)
    fi
    
    echo "$ip"
}

# Function to check Ubuntu version
check_ubuntu_version() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" ]]; then
            if [[ "$VERSION_ID" == "20.04" ]]; then
                log_message "Detected Ubuntu 20.04. Proceeding with installation..."
                return 0
            else
                log_message "WARNING: This script is designed for Ubuntu 20.04, but detected Ubuntu $VERSION_ID."
                echo "Do you want to continue anyway? (yes/no)"
                read -r continue_anyway
                if [[ "$continue_anyway" =~ ^[Yy][Ee][Ss]$ ]]; then
                    return 0
                else
                    log_message "Installation cancelled by user."
                    exit 1
                fi
            fi
        else
            log_message "ERROR: This script is designed for Ubuntu 20.04, but detected $ID $VERSION_ID."
            exit 1
        fi
    else
        log_message "WARNING: Could not determine OS version."
        return 1
    fi
}

# Function to configure firewall
configure_firewall() {
    log_message "Configuring firewall rules..."
    
    # Check if ufw is available and active
    if command -v ufw >/dev/null; then
        # Allow HTTP and HTTPS traffic
        if ufw allow 80/tcp && ufw allow 443/tcp && ufw allow http && ufw allow https; then
            log_message "Firewall rules configured successfully."
        else
            log_message "WARNING: Some firewall rules may not have been applied correctly."
        fi
    else
        log_message "WARNING: ufw not found. Please manually configure firewall if needed."
    fi
}

clear
log_message "Starting TuxCare ePortal installation for Ubuntu 20.04..."
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    log_message "ERROR: This script must be run as root (use sudo)!"
    exit 1
fi

# Validate Ubuntu version
check_ubuntu_version

log_message "Configuring server for ePortal installation..."

# Install prerequisites
log_message "Installing prerequisites (curl, ca-certificates)..."
if apt-get update && apt-get install -y --no-install-recommends curl ca-certificates; then
    log_message "Prerequisites installed successfully."
else
    log_message "ERROR: Failed to install prerequisites!"
    exit 1
fi

# Download and install GPG key
log_message "Installing TuxCare GPG key..."
if curl -f https://repo.cloudlinux.com/kernelcare/kernelcare.gpg -o /usr/share/keyrings/kcare-eportal.gpg; then
    log_message "GPG key downloaded successfully."
    
    # Verify the key file was created and has content
    if [ -s /usr/share/keyrings/kcare-eportal.gpg ]; then
        log_message "GPG key file verified."
    else
        log_message "ERROR: GPG key file is empty or not created properly!"
        exit 1
    fi
else
    log_message "ERROR: Failed to download GPG key!"
    exit 1
fi

# Configure TuxCare repository
log_message "Configuring TuxCare ePortal repository..."

if ! check_apt_repo "/etc/apt/sources.list.d/kcare-eportal.list" "https://repo.cloudlinux.com/kcare-eportal/20.04" "TuxCare ePortal"; then
    cat > /etc/apt/sources.list.d/kcare-eportal.list <<EOL
deb [signed-by=/usr/share/keyrings/kcare-eportal.gpg] https://repo.cloudlinux.com/kcare-eportal/20.04 focal main
EOL
    log_message "TuxCare ePortal repository configured successfully."
fi

sleep 2
clear

# Update package lists and install ePortal
log_message "Updating package lists and installing ePortal..."

if apt-get update; then
    log_message "Package lists updated successfully."
else
    log_message "WARNING: Package list update encountered issues. Continuing..."
fi

if apt-get install -y --no-install-recommends kcare-eportal; then
    log_message "kcare-eportal package installed successfully."
else
    log_message "ERROR: Failed to install kcare-eportal package!"
    exit 1
fi

# Validate installation and service
log_message "Validating ePortal installation and service..."
if ! validate_service "eportal" "kcare-eportal"; then
    log_message "WARNING: ePortal service validation failed. Continuing with configuration..."
fi

clear

# Admin password configuration
log_message "Configuring admin password..."
echo "Your password must contain at least 10 characters."
while true; do
    read -s -p "Enter your password: " varPassword
    echo
    if [ ${#varPassword} -ge 10 ]; then
        log_message "Password is valid. Setting admin password..."
        if kc.eportal -a admin -p "$varPassword"; then
            log_message "Admin password configured successfully."
            break
        else
            log_message "ERROR: Failed to set admin password. Please try again."
        fi
    else
        log_message "ERROR: Password must be at least 10 characters. Please try again."
    fi
done

sleep 2
clear

# Cache Mode configuration
log_message "Cache Mode Configuration:"
echo ""
echo "Would you like to enable ePortal to Cache Patches?"
echo "This will cache meta-data and only store required patches on local server for two weeks."
echo "This greatly reduces the size of your eportal server as well as any backups."
echo ""
echo "Please type 'yes' or 'no'"

read varCache

if [[ "$varCache" =~ ^[Yy][Ee][Ss]$ ]]; then
    clear
    log_message "Configuring ePortal to cache patches..."
    
    mkdir -p /etc/eportal
    if [ -f "/etc/eportal/config" ]; then
        # Check if CACHE_MODE already exists
        if ! grep -q "CACHE_MODE" /etc/eportal/config; then
            echo "CACHE_MODE = True" >> /etc/eportal/config
        fi
    else
        echo "CACHE_MODE = True" > /etc/eportal/config
    fi
    chown nginx:nginx /etc/eportal/config 2>/dev/null || chown www-data:www-data /etc/eportal/config
    log_message "Cache mode enabled successfully."
else
    log_message "Cache mode will not be enabled."
fi

sleep 2
clear

# Business Unit Separation configuration
log_message "Business Unit Separation Configuration:"
echo ""
echo "Would you like to enable Managing Multiple Business Units in Isolation?"
echo ""
echo "Please type 'yes' or 'no'"

read varBU

if [[ "$varBU" =~ ^[Yy][Ee][Ss]$ ]]; then
    clear
    log_message "Configuring ePortal for Business Unit isolation..."
    
    mkdir -p /etc/eportal
    if [ -f "/etc/eportal/config" ]; then
        # Check if BUNITS settings already exist
        if ! grep -q "BUNITS" /etc/eportal/config; then
            cat >> /etc/eportal/config <<EOT
BUNITS = True
BUNITS_LOGIN_SELECTOR = True
BUNITS_SELECTOR = True
EOT
        fi
    else
        cat > /etc/eportal/config <<EOT
BUNITS = True
BUNITS_LOGIN_SELECTOR = True
BUNITS_SELECTOR = True
EOT
    fi
    chown nginx:nginx /etc/eportal/config 2>/dev/null || chown www-data:www-data /etc/eportal/config
    log_message "Business Unit isolation enabled successfully."
else
    log_message "Business Unit isolation will not be configured."
fi

sleep 2
clear

# Proxy configuration
log_message "Proxy Configuration:"
echo ""
echo "Do you need to configure your ePortal to work with a Proxy?"
echo "This may be required if you need FedRAMP or other security requirements."
echo ""
echo "**** If you configure this you will need to make sure your Proxy is properly configured. ****"
echo "**** If you continue with this configuration now, you need to provide the Proxy URL. ****"
echo "**** If you do not have the Proxy URL or Proxy configured, you can edit these settings later. ****"
echo "**** Instructions: https://docs.kernelcare.com/kernelcare-enterprise/#how-to-adjust-proxy-on-eportal-machine ****"
echo ""
echo "Please type 'yes' or 'no'"

read varAnswer

if [[ "$varAnswer" =~ ^[Yy][Ee][Ss]$ ]]; then
    clear
    echo "Please provide your full proxy URL in format: https://example.com:3128"
    read varProxy
    
    if [[ "$varProxy" =~ ^https?:// ]]; then
        log_message "Configuring proxy settings..."
        
        mkdir -p /etc/eportal
        if [ -f "/etc/eportal/config" ]; then
            # Check if PROXY setting already exists
            if ! grep -q "PROXY" /etc/eportal/config; then
                echo "PROXY = '$varProxy'" >> /etc/eportal/config
            fi
        else
            echo "PROXY = '$varProxy'" > /etc/eportal/config
        fi
        chown nginx:nginx /etc/eportal/config 2>/dev/null || chown www-data:www-data /etc/eportal/config
        log_message "Proxy configuration added successfully."
    else
        log_message "ERROR: Invalid proxy URL format. Skipping proxy configuration."
    fi
else
    log_message "ePortal will not be configured for proxy."
fi

sleep 2
clear

# Final service restart and validation
log_message "Restarting ePortal service to apply all configurations..."

systemctl stop eportal
sleep 3

if systemctl start eportal; then
    log_message "ePortal service restarted successfully."
    sleep 3
    
    # Final service validation
    if systemctl is-active --quiet eportal; then
        log_message "ePortal service is running and ready."
    else
        log_message "WARNING: ePortal service may not be running properly."
    fi
else
    log_message "ERROR: Failed to restart ePortal service!"
    exit 1
fi

# Configure firewall
configure_firewall

# Get and display server IP
SERVER_IP=$(get_server_ip)
if [ -n "$SERVER_IP" ]; then
    log_message "Server IP detected: $SERVER_IP"
else
    log_message "Could not automatically detect server IP."
    SERVER_IP="<Your-Server-IP>"
fi

echo
echo "========================================="
log_message "ePortal installation completed successfully!"
echo "========================================="
echo
echo "You can now log in to your ePortal at:"
echo "  http://$SERVER_IP"
echo
if [ "$SERVER_IP" != "<Your-Server-IP>" ] && command -v hostname >/dev/null; then
    HOSTNAME=$(hostname -f 2>/dev/null || hostname)
    if [ -n "$HOSTNAME" ] && [ "$HOSTNAME" != "localhost" ]; then
        echo "  or http://$HOSTNAME"
        echo
    fi
fi
echo "Login credentials:"
echo "  Username: admin"
echo "  Password: [the password you just configured]"
echo
echo "Firewall ports opened: 80 (HTTP), 443 (HTTPS)"
echo
echo "For additional information on configuring feed credentials, visit:"
echo "https://docs.tuxcare.com/eportal/#installation"
echo
log_message "Installation script completed."

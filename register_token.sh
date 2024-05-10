#!/bin/bash

# Prompt user for license key
echo "Please enter your license key:"
read LICENSE

# Use the provided license key to make a POST request and extract the token
curl -i -X POST \
     -H "Content-Type: application/json" \
     -H "Accept: */*" \
     -d "{\"key\": \"$LICENSE\", \"host_name\": \"$(hostname)\"}" \
     https://cln.cloudlinux.com/cln/api/centos/token/register | grep -oP '"token":"\K[\w\d-]*'

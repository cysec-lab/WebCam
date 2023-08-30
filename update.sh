#!/bin/bash

# Variables
download_path="/usr/local/apache2/downloads/updatefile.tar.gz"
url="https://handsoniotapp.com/downloads/updatefile.tar.gz"
log_path="download_log.txt"
script_path="/usr/local/apache2/cgi-bin/updatefile/update.sh"

# Download file
curl -k -o $download_path $url

# Check if download succeeded
if [ $? -ne 0 ]; then
    echo "Error downloading file." >> $log_path
    exit 1
fi

# Change file permissions
chmod u+rw,g+r,o+r $download_path

if [ $? -ne 0 ]; then
    echo "Error changing file permissions." >> $log_path
    exit 1
fi

# Extract the downloaded file
tar -xzf $download_path -C $(dirname $download_path)

if [ $? -ne 0 ]; then
    echo "Error extracting the tarball." >> $log_path
    exit 1
fi

# Change permissions of the script
chmod u+rwx,g+r,o+r $script_path

if [ $? -ne 0 ]; then
    echo "Error changing script permissions." >> $log_path
    exit 1
fi

# Execute the script
$script_path

if [ $? -ne 0 ]; then
    echo "Error executing the script." >> $log_path
    exit 1
fi

echo "Update successfully."


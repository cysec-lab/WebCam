#!/bin/bash

source setting.txt

#ローカルIPアドレスの固定
echo "interface $INTERFACE" | sudo tee -a /etc/dhcpcd.conf
echo "static ip_address=$IP_ADDRESS/24" | sudo tee -a /etc/dhcpcd.conf
echo "static routers=$ROUTERS" | sudo tee -a /etc/dhcpcd.conf
echo "static domain_name_servers=${DNS//,/ }" | sudo tee -a /etc/dhcpcd.conf

#Wi-Fi設定
echo -e "\nnetwork={\n\tssid=\"$SSID\"\n\tpsk=\"$PASSWORD\"\n}" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null
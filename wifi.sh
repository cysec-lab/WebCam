#!/bin/bash

# 設定値を読み込む
source setting.txt

# dhcpcd.confに設定を追加する
echo "interface $INTERFACE" | sudo tee -a /etc/dhcpcd.conf
echo "static ip_address=$IP_ADDRESS/24" | sudo tee -a /etc/dhcpcd.conf
echo "static routers=$ROUTERS" | sudo tee -a /etc/dhcpcd.conf
echo "static domain_name_servers=${DNS//,/ }" | sudo tee -a /etc/dhcpcd.conf

# wpa_supplicantの設定ファイルに設定を追記
echo -e "\nnetwork={\n\tssid=\"$SSID\"\n\tpsk=\"$PASSWORD\"\n}" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null

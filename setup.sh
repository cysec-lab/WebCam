#!/bin/bash

# setting.txtからIP_ADDRESSの値を抽出
IP_ADDRESS=$(grep 'IP_ADDRESS' setting.txt | cut -d= -f2)

# IPアドレスが192.168.11.XXXであるかチェック
if [ "$IP_ADDRESS" == "192.168.11.XXX" ]; then
    echo "IPアドレスを修正してください"
    exit 1
fi

source setting.txt

#ローカルIPアドレスの固定
echo "interface $INTERFACE" | sudo tee -a /etc/dhcpcd.conf
echo "static ip_address=$IP_ADDRESS/24" | sudo tee -a /etc/dhcpcd.conf
echo "static routers=$ROUTERS" | sudo tee -a /etc/dhcpcd.conf
echo "static domain_name_servers=${DNS//,/ }" | sudo tee -a /etc/dhcpcd.conf

#Wi-Fi設定
echo -e "\nnetwork={\n\tssid=\"$SSID\"\n\tpsk=\"$PASSWORD\"\n}" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null

# setting.txtからIPアドレスを抽出してホスト部を取得
IP_ADDRESS=$(grep 'IP_ADDRESS' setting.txt | cut -d= -f2)
HOST_PART=$(echo $IP_ADDRESS | cut -d. -f4)

# ホスト部の前に1000を足す
NEW_HOST_PART="1000${HOST_PART}"

# target.txtの2行目と3行目に新しいホスト部を保存
sed -i "2s/.*/$NEW_HOST_PART/" target.txt
sed -i "3s/.*/$NEW_HOST_PART/" target.txt
sed -i 's/ //g' setting.txt

#target.txtの移動
sudo cp target.txt /usr/local/apache2/cgi-bin/
sudo cp target.txt /usr/local/apache2/backup/
sudo chmod 775 /usr/local/apache2/backup/target.txt
sudo chmod 755 /usr/local/apache2/cgi-bin/target.txt
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

# target.txtの2行目、3行目の数字を取得
NUM1=$(sed -n '2p' target.txt)
NUM2=$(sed -n '3p' target.txt)

# ホスト部を2行目、3行目の数字に追加
NEW_NUM1=${NUM1}${HOST_PART}
NEW_NUM2=${NUM2}${HOST_PART}

# target.txtの2行目、3行目を更新した数字で置換
sed -i "2s/$NUM1/$NEW_NUM1/" target.txt
sed -i "3s/$NUM2/$NEW_NUM2/" target.txt

#target.txtの移動
sudo cp target.txt /usr/local/apache2/cgi-bin/
sudo cp target.txt /usr/local/apache2/backup/
sudo chmod 775 /usr/local/apache2/backup/target.txt
sudo chmod 755 /usr/local/apache2/cgi-bin/target.txt
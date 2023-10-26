#!/bin/bash

# ローカルIPアドレスを取得
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# オプションを表示
echo "選択してください："
echo "1. 現在のIPアドレスを使用する ($IP_ADDRESS)"
echo "2. IPアドレスを変更する"
read -p "選択 (1/2): " choice

case $choice in
    1)
        echo "現在のIPアドレス ($IP_ADDRESS) を使用します。"
        sed -i "s/IP_ADDRESS=192.168.11.[0-9]*/IP_ADDRESS=$IP_ADDRESS/" setting.txt
        echo "IPアドレスが $IP_ADDRESS に変更されました。"
        ;;
    2)
        read -p "新しいIPアドレスのホスト部を入力してください (192.168.11.): " host_part
        new_ip="192.168.11.$host_part"
        # IPアドレスの変更処理
        sed -i "s/IP_ADDRESS=192.168.11.[0-9]*/IP_ADDRESS=$new_ip/" setting.txt
        echo "IPアドレスが $new_ip に変更されました。"
        ;;
    *)
        echo "無効な選択です。"
        exit 1
        ;;
esac

source setting.txt

#/etc/dhcpcd.confの変更内容を削除
sudo sed -i '/interface wlan0/,/static domain_name_servers=[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/d' /etc/dhcpcd.conf

#/etc/dhcpcd.confの内容を変更
echo "interface $INTERFACE" | sudo tee -a /etc/dhcpcd.conf
echo "static ip_address=$IP_ADDRESS/24" | sudo tee -a /etc/dhcpcd.conf
echo "static routers=$ROUTERS" | sudo tee -a /etc/dhcpcd.conf
echo "static domain_name_servers=${DNS//,/ }" | sudo tee -a /etc/dhcpcd.conf

# setting.txtからIPアドレスを抽出してホスト部を取得
IP_ADDRESS=$(grep 'IP_ADDRESS' setting.txt | cut -d= -f2)
HOST_PART=$(echo $IP_ADDRESS | cut -d. -f4)

# ホスト部の前に1000を足す
NEW_HOST_PART="1000${HOST_PART}"

# target.txtの2行目と3行目に新しいホスト部を保存
sed -i "2s/.*/$NEW_HOST_PART/" target.txt
sed -i "3s/.*/$NEW_HOST_PART/;3a\\" target.txt

#target.txtの移動
sudo cp target.txt /usr/local/apache2/cgi-bin/
sudo cp target.txt /usr/local/apache2/backup/
sudo chmod 775 /usr/local/apache2/backup/target.txt
sudo chmod 755 /usr/local/apache2/cgi-bin/target.txt

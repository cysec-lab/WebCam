#!/bin/sh

#初期設定
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev libexpat1-dev libcurl4-openssl-dev apache2-utils libarchive-dev

#Apache2.4.49インストール
cd ~
wget https://archive.apache.org/dist/httpd/httpd-2.4.49.tar.gz
wget https://archive.apache.org/dist/apr/apr-1.7.4.tar.gz
wget https://archive.apache.org/dist/apr/apr-util-1.6.3.tar.gz
tar xvf httpd-2.4.49.tar.gz
tar xvf apr-1.7.4.tar.gz
tar xvf apr-util-1.6.3.tar.gz
mv apr-1.7.4 httpd-2.4.49/srclib/apr
mv apr-util-1.6.3 httpd-2.4.49/srclib/apr-util
cd ~/httpd-2.4.49
LDFLAGS=-latomic ./configure --prefix=/usr/local/apache2
sudo make
sudo make install

#WebCameraSetup
cd ~
cd WebCam
sudo usermod -a -G video daemon
sudo rm /usr/local/apache2/htdocs/*
sudo rm /usr/local/apache2/cgi-bin/*

sudo mkdir /usr/local/apache2/htdocs/images
sudo mkdir /usr/local/apache2/htdocs/images2
sudo mkdir /usr/local/apache2/downloads
sudo mkdir /usr/local/apache2/backup

sudo chown daemon:daemon /usr/local/apache2/htdocs/images
sudo chown daemon:daemon /usr/local/apache2/htdocs/images2
sudo chown daemon:daemon /usr/local/apache2/downloads
sudo chown daemon:daemon /usr/local/apache2/backup

sudo cp bin/* /usr/local/apache2/cgi-bin
sudo cp bin/* /usr/local/apache2/backup
sudo cp httpd.conf /usr/local/apache2/conf
sudo cp htdocs/* /usr/local/apache2/htdocs
sudo cp htdocs/* /usr/local/apache2/backup

sudo cp version.txt /usr/local/apache2/cgi-bin
sudo cp target.txt /usr/local/apache2/cgi-bin

username="user"
password="password"
htpasswd_file="/usr/local/apache2/htdocs/.htpasswd"
htpasswd -bc "$htpasswd_file" "$username" "$password"

#IPアドレス固定＋Wifi設定
source setting.txt
echo "interface $INTERFACE" | sudo tee -a /etc/dhcpcd.conf
echo "static ip_address=$IP_ADDRESS/24" | sudo tee -a /etc/dhcpcd.conf
echo "static routers=$ROUTERS" | sudo tee -a /etc/dhcpcd.conf
echo "static domain_name_servers=${DNS//,/ }" | sudo tee -a /etc/dhcpcd.conf
echo -e "\nnetwork={\n\tssid=\"$SSID\"\n\tpsk=\"$PASSWORD\"\n}" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null

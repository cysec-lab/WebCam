#!/bin/bash

cd ~
cd /home/pi/WebCam
sudo usermod -a -G video daemon
sudo rm /usr/local/apache2/htdocs/*
sudo rm /usr/local/apache2/cgi-bin/*

sudo mkdir -p /usr/local/apache2/htdocs/images
sudo mkdir -p /usr/local/apache2/htdocs/images2
sudo mkdir -p /usr/local/apache2/downloads
sudo mkdir -p /usr/local/apache2/backup

sudo cp bin/* /usr/local/apache2/cgi-bin/
sudo cp bin/* /usr/local/apache2/backup/
sudo cp httpd.conf /usr/local/apache2/conf/
sudo cp htdocs/* /usr/local/apache2/htdocs/
sudo cp htdocs/* /usr/local/apache2/backup/
sudo cp version.txt /usr/local/apache2/cgi-bin/
sudo cp version.txt /usr/local/apache2/backup/
sudo cp target.txt /usr/local/apache2/cgi-bin/
sudo cp target.txt /usr/local/apache2/backup/

username="user"
password="password"
htpasswd_file="/usr/local/apache2/htdocs/.htpasswd"
htpasswd -bc "$htpasswd_file" "$username" "$password"

sudo chown daemon:daemon /usr/local/apache2/htdocs/images
sudo chown daemon:daemon /usr/local/apache2/htdocs/images2
sudo chown daemon:daemon /usr/local/apache2/downloads
sudo chown daemon:daemon /usr/local/apache2/backup
sudo chown daemon:daemon /usr/local/apache2/cgi-bin
sudo chown daemon:daemon /usr/local/apache2/cgi-bin/*
sudo chown daemon:daemon /usr/local/apache2/htdocs
sudo chown daemon:daemon /usr/local/apache2/htdocs/*
sudo chmod 755 /usr/local/apache2/htdocs/images
sudo chmod 755 /usr/local/apache2/htdocs/images2
sudo chmod 775 /usr/local/apache2/downloads
sudo chmod 775 /usr/local/apache2/backup
sudo chmod 755 /usr/local/apache2/cgi-bin/*
sudo chmod 755 /usr/local/apache2/htdocs/*

sed -i '/exit 0/d' /etc/rc.local
echo "/usr/local/apache2/bin/apachectl start" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
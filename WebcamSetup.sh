#!/bin/sh
cd ..
cd WebCam
sudo rm /usr/local/apache2/htdocs/*
sudo rm /usr/local/apache2/cgi-bin/*
sudo mkdir /usr/local/apache2/htdocs/images
sudo mkdir /usr/local/apache2/htdocs/images2
sudo mkdir /usr/local/apache2/downloads
sudo chown daemon:daemon /usr/local/apache2/htdocs/images
sudo chown daemon:daemon /usr/local/apache2/htdocs/images2
sudo chown daemon:daemon /usr/local/apache2/downloads
sudo chmod +w /usr/local/apache2/htdocs

sudo cp httpd.conf /usr/local/apache2/conf/
sudo cp index.html /usr/local/apache2/htdocs
sudo cp album.html /usr/local/apache2/htdocs
sudo cp style.css /usr/local/apache2/htdocs
sudo cp script.js /usr/local/apache2/htdocs
sudo cp capture.c /usr/local/apache2/cgi-bin
sudo cp list.c /usr/local/apache2/cgi-bin
sudo cp rename.c /usr/local/apache2/cgi-bin
sudo cp takepicture.c /usr/local/apache2/cgi-bin
sudo cp update.c /usr/lo
sudo cp version.c /usr/local/apache2/cgi-bin
sudo cp reset.c /usr/local/apache2/cgi-bin
sudo cp download.c /usr/local/apache2/cgi-bin
sudo cp version.txt /usr/local/apache2/cgi-bin
echo "" > /usr/local/apache2/cgi-bin/target.txt

sudo usermod -a -G video daemon
username="user"
password="password"
htpasswd_file="/usr/local/apache2/htdocs/.htpasswd"
htpasswd -b "$htpasswd_file" "$username" "$password"

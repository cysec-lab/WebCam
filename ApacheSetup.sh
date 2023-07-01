#!/bin/sh
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev libexpat1-dev libcurl4-openssl-dev
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
LDFLAGS=-latomic ./configure --prefix=/usr/local/apache2 --enable-cgi 
sudo make
sudo make install
#Apache詳細
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
sudo cp index.html /usr/local/apache2/htdocs
sudo cp album.html /usr/local/apache2/htdocs
sudo cp style.css /usr/local/apache2/htdocs
sudo cp script.js /usr/local/apache2/htdocs
sudo cp capture.c /usr/local/apache2/cgi-bin
sudo cp list.c /usr/local/apache2/cgi-bin
sudo cp rename.c /usr/local/apache2/cgi-bin
sudo cp takepicture.c /usr/local/apache2/cgi-bin
sudo cp update.c /usr/local/apache2/cgi-bin
echo "" > /usr/local/apache2/cgi-bin/target.txt
sudo usermod -a -G video daemon
#コンパイル
cd ..
cd /usr/local/apache2/cgi-bin
gcc capture.c -o capture.cgi
gcc list.c -o list.cgi
gcc rename.c -o rename.cgi
gcc takepicture.c -o takepicture.cgi -lcurl
gcc update.c -o update.cgi

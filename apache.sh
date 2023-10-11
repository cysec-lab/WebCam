#!/bin/sh

#初期設定
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev libexpat1-dev libcurl4-openssl-dev apache2-utils libarchive-dev

#Apache2.4.49インストール
tar xvf $(pwd)/httpd-2.4.49.tar.gz
tar xvf $(pwd)/apr-1.7.4.tar.gz
tar xvf $(pwd)/apr-util-1.6.3.tar.gz
mv $(pwd)/apr-1.7.4 $(pwd)/httpd-2.4.49/srclib/apr mv $(pwd)/apr-util-1.6.3 $(pwd)/httpd-2.4.49/srclib/apr-util
cd $(pwd)/httpd-2.4.49
LDFLAGS=-latomic ./configure --prefix=/usr/local/apache2 sudo make sudo make install

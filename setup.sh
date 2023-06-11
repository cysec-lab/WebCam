#!/bin/sh
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev libexpat1-dev
cd ~
wget https://archive.apache.org/dist/httpd/httpd-2.4.49.tar.gz
wget https://archive.apache.org/dist/apr/apr-1.7.0.tar.gz
wget https://archive.apache.org/dist/apr/apr-util-1.6.1.tar.gz
tar xvf httpd-2.4.49.tar.gz
tar xvf apr-1.7.0.tar.gz
tar xvf apr-util-1.6.1.tar.gz
mv apr-1.7.0 httpd-2.4.49/srclib/apr
mv apr-util-1.6.1 httpd-2.4.49/srclib/apr-util
cd ~/httpd-2.4.49
./configure --prefix=/usr/local/apache2 --with-included-apr --with-expat=/usr/include/ --enable-auth-basic --enable-cgi
sudo make
sudo make install
/usr/local/apache2/bin/httpd -v
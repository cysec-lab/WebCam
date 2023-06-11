#!/bin/sh
cd ..
cd WebCam
sudo rm /usr/local/apache2/htdocs/*
sudo rm /usr/local/apache2/cgi-bin/*
sudo chmod +w /usr/local/apache2/htdocs
sudo mv index.html /usr/local/apache2/htdocs
sudo mv album.html /usr/local/apache2/htdocs
sudo mv style.css /usr/local/apache2/htdocs
sudo mv script.js /usr/local/apache2/htdocs
sudo mv capture.c /usr/local/apache2/cgi-bin
sudo mv list.c /usr/local/apache2/cgi-bin
sudo mv rename.c /usr/local/apache2/cgi-bin
sudo mv takepicture.c /usr/local/apache2/cgi-bin

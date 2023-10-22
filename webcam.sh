#!/bin/bash

#不要なファイルの削除
sudo rm -r /usr/local/apache2/htdocs/*
sudo rm -r /usr/local/apache2/cgi-bin/*

#必要なディレクトリの作成
sudo mkdir -p /usr/local/apache2/htdocs/images
sudo mkdir -p /usr/local/apache2/htdocs/images2
sudo mkdir -p /usr/local/apache2/downloads
sudo mkdir -p /usr/local/apache2/backup

#必要なファイルのコピー
sudo cp bin/* /usr/local/apache2/cgi-bin/
sudo cp bin/* /usr/local/apache2/backup/
sudo cp httpd.conf /usr/local/apache2/conf/
sudo cp htdocs/* /usr/local/apache2/htdocs/
sudo cp htdocs/* /usr/local/apache2/backup/
sudo cp version.txt /usr/local/apache2/cgi-bin/
sudo cp version.txt /usr/local/apache2/backup/
sudo cp target.txt /usr/local/apache2/cgi-bin/
sudo cp target.txt /usr/local/apache2/backup/

#ID/PW設定
username="user"
password="password"
htpasswd_file="/usr/local/apache2/htdocs/.htpasswd"
htpasswd -bc "$htpasswd_file" "$username" "$password"

#必要な権限設定
sudo usermod -a -G video daemon
sudo chown daemon:daemon /usr/local/apache2/downloads
sudo chown daemon:daemon /usr/local/apache2/backup
sudo chown daemon:daemon /usr/local/apache2/backup/*
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

#Apache2を自動起動するための設定
sed -i '/exit 0/d' /etc/rc.local
sed -i '/\/usr\/local\/apache2\/bin\/apachectl restart/d' /etc/rc.local
sed -i '/\/usr\/local\/apache2\/bin\/apachectl start/d' /etc/rc.local
echo "/usr/local/apache2/bin/apachectl start" >> /etc/rc.local
echo "/usr/local/apache2/bin/apachectl restart" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local

#画像を5秒に一度取得するための設定
echo "[Unit]
Description=My script

[Service]
ExecStart=/usr/local/apache2/cgi-bin/picture.sh
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/picture.service

# システムにこの新しいサービスを登録
systemctl daemon-reload

# サービスを有効にして起動
systemctl enable picture.service
systemctl start picture.service

# 終了メッセージ
echo "WebCam has been installed and started."

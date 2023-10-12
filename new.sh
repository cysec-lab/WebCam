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

# 自身のIPアドレスを取得
MY_IP=$(hostname -I | awk '{print $1}')

# IPアドレスのホスト部を取得
HOST_PART=${MY_IP##*.}

# 1000とホスト部を組み合わせる
NUM_TO_ADD="1000"
NEW_NUM="${NUM_TO_ADD}${HOST_PART}"

# target.txtの2行目、3行目の数字を取得
NUM1=$(sed -n '2p' target.txt)
NUM2=$(sed -n '3p' target.txt)

# target.txtの2行目、3行目を更新した数字で置換
sed -i "2s/$NUM1/$NEW_NUM/" target.txt
sed -i "3s/$NUM2/$NEW_NUM/" target.txt

# target.txtのコピーとパーミッション設定
sudo cp target.txt /usr/local/apache2/cgi-bin/
sudo cp target.txt /usr/local/apache2/backup/
sudo chmod 775 /usr/local/apache2/backup/target.txt
sudo chmod 755 /usr/local/apache2/cgi-bin/target.txt




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


# 終了メッセージ
echo "Fin"

#!/bin/bash

# 変数設定
remote_user="remote_user"
remote_host="remote_host"

# 不要なファイルの削除
rsh "$remote_user@$remote_host" rm -r /usr/local/apache2/htdocs
rsh "$remote_user@$remote_host" rm -rf /usr/local/apache2/cgi-bin
rsh "$remote_user@$remote_host" rm -rf /usr/local/apache2/downloads
rsh "$remote_user@$remote_host" rm -rf /usr/local/apache2/backup

# ディレクトリの作成
rsh "$remote_user@$remote_host" mkdir -p /usr/local/apache2/htdocs/images
rsh "$remote_user@$remote_host" mkdir -p /usr/local/apache2/htdocs/images2
rsh "$remote_user@$remote_host" mkdir -p /usr/local/apache2/downloads
rsh "$remote_user@$remote_host" mkdir -p /usr/local/apache2/backup

# ID/PW設定
username="user"
password="password"
htpasswd_file="/usr/local/apache2/htdocs/.htpasswd"
rsh "$remote_user@$remote_host" htpasswd -bc "$htpasswd_file" "$username" "$password"

# 権限設定
rsh "$remote_user@$remote_host" usermod -a -G video daemon
rsh "$remote_user@$remote_host" chmod 755 /usr/local/apache2/htdocs/images
rsh "$remote_user@$remote_host" chmod 755 /usr/local/apache2/htdocs/images2
rsh "$remote_user@$remote_host" chmod 775 /usr/local/apache2/downloads
rsh "$remote_user@$remote_host" chmod 775 /usr/local/apache2/backup
rsh "$remote_user@$remote_host" chmod 755 /usr/local/apache2/cgi-bin/*
rsh "$remote_user@$remote_host" chmod 755 /usr/local/apache2/htdocs/*
rsh "$remote_user@$remote_host" chown daemon:daemon /usr/local/apache2/htdocs/images
rsh "$remote_user@$remote_host" chown daemon:daemon /usr/local/apache2/htdocs/images2
rsh "$remote_user@$remote_host" chown daemon:daemon /usr/local/apache2/downloads
rsh "$remote_user@$remote_host" chown daemon:daemon /usr/local/apache2/backup
rsh "$remote_user@$remote_host" chown daemon:daemon /usr/local/apache2/cgi-bin
rsh "$remote_user@$remote_host" chown daemon:daemon /usr/local/apache2/cgi-bin/*
rsh "$remote_user@$remote_host" chown daemon:daemon /usr/local/apache2/htdocs
rsh "$remote_user@$remote_host" chown daemon:daemon /usr/local/apache2/htdocs/*


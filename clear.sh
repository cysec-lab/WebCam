#!/bin/bash

# 管理者権限で実行されているか確認
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# 警告と確認
read -p "This will permanently delete all data in /usr/local/apache2/{cgi-bin,htdocs,downloads,backup}. Are you sure? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "Operation cancelled."
  exit 1
fi

# ディレクトリ内の全てのデータを削除
rm -rf /usr/local/apache2/cgi-bin/*
rm -rf /usr/local/apache2/htdocs/*
rm -rf /usr/local/apache2/downloads/*
rm -rf /usr/local/apache2/backup/*

echo "All data in specified directories have been deleted."

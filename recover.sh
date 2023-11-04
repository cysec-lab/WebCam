#!/bin/bash

# 引数からホストアドレスを取得
host=$1

# 引数が提供されているか確認
if [ -z "$host" ]; then
    echo "使用方法: sudo sh recover.sh [ユーザー名@]ホストアドレス"
    exit 1
fi

# 不要なファイルの削除
rsh "$host" 'sudo rm -r /usr/local/apache2/htdocs'
rsh "$host" 'sudo rm -rf /usr/local/apache2/cgi-bin'
rsh "$host" 'sudo rm -rf /usr/local/apache2/downloads'
rsh "$host" 'sudo rm -rf /usr/local/apache2/backup'

# ディレクトリの作成
rsh "$host" 'mkdir -p /usr/local/apache2/htdocs/images'
rsh "$host" 'mkdir -p /usr/local/apache2/htdocs/images2'
rsh "$host" 'mkdir -p /usr/local/apache2/downloads'
rsh "$host" 'mkdir -p /usr/local/apache2/backup'

# 必要なファイルのコピー
rcp /home/pi/cgi-bin "$host":/usr/local/apache2/cgi-bin/
rcp /home/pi/backup "$host":/usr/local/apache2/backup/
rcp /home/pi/htcdocs "$host":/usr/local/apache2/htdocs/

# target.txtのコピーと編集
rcp target.txt "$host":/home/pi
rsh "$host" '
    # ローカルIPアドレスを取得
    IP_ADDRESS=$(hostname -I | awk "{print \$1}")
    HOST_PART=$(echo $IP_ADDRESS | cut -d. -f4)

    # ホスト部の前に1000を足す
    NEW_HOST_PART="1000${HOST_PART}"

    # target.txtの2行目と3行目に新しいホスト部を保存
    sed -i "2s/.*/${NEW_HOST_PART}/" /home/pi/target.txt
    sed -i "3s/.*/${NEW_HOST_PART}/" /home/pi/target.txt
'

# target.txtの移動と権限設定
rsh "$host" 'cp /home/pi/target.txt /usr/local/apache2/cgi-bin/'
rsh "$host" 'cp /home/pi/target.txt /usr/local/apache2/backup/'
rsh "$host" 'sudo chmod 775 /usr/local/apache2/backup/target.txt'
rsh "$host" 'sudo chmod 755 /usr/local/apache2/cgi-bin/target.txt'

# ID/PW設定
username="user"
password="password"
htpasswd_file="/usr/local/apache2/htdocs/.htpasswd"
rsh "$host" "sudo htpasswd -bc $htpasswd_file $username $password"

# 権限設定
rsh "$host" 'sudo usermod -a -G video daemon'
rsh "$host" 'sudo chmod 755 /usr/local/apache2/htdocs/images'
rsh "$host" 'sudo chmod 755 /usr/local/apache2/htdocs/images2'
rsh "$host" 'sudo chmod 775 /usr/local/apache2/downloads'
rsh "$host" 'sudo chmod 775 /usr/local/apache2/backup'
rsh "$host" 'sudo chmod 755 /usr/local/apache2/cgi-bin/*'
rsh "$host" 'sudo chmod 755 /usr/local/apache2/htdocs/*'
rsh "$host" 'sudo chown daemon:daemon /usr/local/apache2/htdocs/images'
rsh "$host" 'sudo chown daemon:daemon /usr/local/apache2/htdocs/images2'
rsh "$host" 'sudo chown daemon:daemon /usr/local/apache2/downloads'
rsh "$host" 'sudo chown daemon:daemon /usr/local/apache2/backup'
rsh "$host" 'sudo chown daemon:daemon /usr/local/apache2/cgi-bin'
rsh "$host" 'sudo chown daemon:daemon /usr/local/apache2/cgi-bin/*'
rsh "$host" 'sudo chown daemon:daemon /usr/local/apache2/htdocs'
rsh "$host" 'sudo chown daemon:daemon /usr/local/apache2/htdocs/*'

# Apacheの再起動
rsh "$host" 'sudo /usr/local/apache2/bin/apachectl restart'

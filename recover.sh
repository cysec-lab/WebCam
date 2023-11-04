#!/bin/bash
# 引数からホストアドレスを取得
host=$1

# 引数が提供されているか確認
if [ -z "$host" ]; then
    echo "使用方法: sudo sh recover.sh [ユーザー名@]ホストアドレス"
    exit 1
fi

# コマンドが失敗したらエラーメッセージを表示して終了
execute_command() {
    command=$1
    error_message=$2

    if ! eval $command; then
        echo "エラー: $error_message"
        exit 1
    fi
}

# 不要なファイルの削除
execute_command "rsh \"$host\" 'sudo rm -rf /usr/local/apache2/htdocs'" "htdocsの削除に失敗しました。"
execute_command "rsh \"$host\" 'sudo rm -rf /usr/local/apache2/cgi-bin'" "cgi-binの削除に失敗しました。"
execute_command "rsh \"$host\" 'sudo rm -rf /usr/local/apache2/downloads'" "downloadsの削除に失敗しました。"
execute_command "rsh \"$host\" 'sudo rm -rf /usr/local/apache2/backup'" "backupの削除に失敗しました。"

# ディレクトリの作成
execute_command "rsh \"$host\" 'mkdir -p /usr/local/apache2/htdocs/images'" "htdocs/imagesの作成に失敗しました。"
execute_command "rsh \"$host\" 'mkdir -p /usr/local/apache2/htdocs/images2'" "htdocs/images2の作成に失敗しました。"
execute_command "rsh \"$host\" 'mkdir -p /usr/local/apache2/downloads'" "downloadsの作成に失敗しました。"
execute_command "rsh \"$host\" 'mkdir -p /usr/local/apache2/backup'" "backupの作成に失敗しました。"

# 必要なファイルのコピー
execute_command "rcp /home/pi/cgi-bin \"$host\":/usr/local/apache2/cgi-bin/" "cgi-binのコピーに失敗しました。"
execute_command "rcp /home/pi/backup \"$host\":/usr/local/apache2/backup/" "backupのコピーに失敗しました。"
execute_command "rcp /home/pi/htcdocs \"$host\":/usr/local/apache2/htdocs/" "htdocsのコピーに失敗しました。"

# target.txtのコピーと編集
execute_command "rcp target.txt \"$host\":/home/pi" "target.txtのコピーに失敗しました。"
execute_command "rsh \"$host\" '
    IP_ADDRESS=$(hostname -I | awk \"{print \$1}\")
    if [ -z \"$IP_ADDRESS\" ]; then
        echo \"エラー: ローカルIPアドレスの取得に失敗しました。\"
        exit 1
    fi
    HOST_PART=$(echo $IP_ADDRESS | cut -d. -f4)
    NEW_HOST_PART=\"1000${HOST_PART}\"
    sed -i \"2s/.*/${NEW_HOST_PART}/\" /home/pi/target.txt
    sed -i \"3s/.*/${NEW_HOST_PART}/\" /home/pi/target.txt
'" "target.txtの編集に失敗しました。"

# target.txtの移動と権限設定
execute_command "rsh \"$host\" 'cp /home/pi/target.txt /usr/local/apache2/cgi-bin/'" "target.txtの移動に失敗しました。"
execute_command "rsh \"$host\" 'cp /home/pi/target.txt /usr/local/apache2/backup/'" "target.txtのバックアップへのコピーに失敗しました。"
execute_command "rsh \"$host\" 'sudo chmod 775 /usr/local/apache2/backup/target.txt'" "backup/target.txtの権限設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chmod 755 /usr/local/apache2/cgi-bin/target.txt'" "cgi-bin/target.txtの権限設定に失敗しました。"

# ID/PW設定
username="user"
password="password"
htpasswd_file="/usr/local/apache2/htdocs/.htpasswd"
execute_command "rsh \"$host\" \"sudo htpasswd -bc $htpasswd_file $username $password\"" ".htpasswdの作成に失敗しました。"

# 権限設定
execute_command "rsh \"$host\" 'sudo usermod -a -G video daemon'" "daemonユーザーのvideoグループへの追加に失敗しました。"
execute_command "rsh \"$host\" 'sudo chmod 755 /usr/local/apache2/htdocs/images'" "htdocs/imagesの権限設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chmod 755 /usr/local/apache2/htdocs/images2'" "htdocs/images2の権限設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chmod 775 /usr/local/apache2/downloads'" "downloadsの権限設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chmod 775 /usr/local/apache2/backup'" "backupの権限設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chmod 755 /usr/local/apache2/cgi-bin/*'" "cgi-binのファイル権限設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chmod 755 /usr/local/apache2/htdocs/*'" "htdocsのファイル権限設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chown daemon:daemon /usr/local/apache2/htdocs/images'" "htdocs/imagesの所有者設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chown daemon:daemon /usr/local/apache2/htdocs/images2'" "htdocs/images2の所有者設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chown daemon:daemon /usr/local/apache2/downloads'" "downloadsの所有者設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chown daemon:daemon /usr/local/apache2/backup'" "backupの所有者設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chown daemon:daemon /usr/local/apache2/cgi-bin'" "cgi-binの所有者設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chown daemon:daemon /usr/local/apache2/cgi-bin/*'" "cgi-bin/*の所有者設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chown daemon:daemon /usr/local/apache2/htdocs'" "htdocsの所有者設定に失敗しました。"
execute_command "rsh \"$host\" 'sudo chown daemon:daemon /usr/local/apache2/htdocs/*'" "htdocs/*の所有者設定に失敗しました。"

# Apacheの再起動
execute_command "rsh \"$host\" 'sudo /usr/local/apache2/bin/apachectl restart'" "Apacheの再起動に失敗しました。"

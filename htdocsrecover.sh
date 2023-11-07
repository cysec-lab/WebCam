#!/bin/bash

# hosts.txt ファイルからホスト名を読み込む
while IFS= read -r host; do

    #権限の変更（要らないかも）
    rsh "$host" "sudo chown pi:pi /usr/local/apache2/htdocs/*" < /dev/null

    #HTML,CSS,JavaScriptファイルの削除
    rsh "$host" "sudo rm /usr/local/apache2/htdocs/*.{html,js,css}" < /dev/null

    #必要ファイルのコピー
    rcp htdocs/* "$host":/usr/local/apache2/htdocs

    #権限を適切に設定し直す
    rsh "$host" "sudo chown daemon:daemon /usr/local/apache2/htdocs/*" < /dev/null
    rsh "$host" "sudo chmod 755 /usr/local/apache2/htdocs/*" < /dev/null

    #Apacheの再起動
    rsh "$host" "sudo /usr/local/apache2/bin/apachectl restart" < /dev/null
    
    #完了メッセージ
    echo "完了：$host"

done < "hosts.txt"

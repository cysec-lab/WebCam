#!/bin/bash

# hosts.txt ファイルからホスト名を読み込む
while IFS= read -r host; do
    #Apacheの再起動
    rsh "$host" "sudo shutdown -h now" < /dev/null

    #完了メッセージ
    echo "完了：$host"
    
done < "hosts.txt"

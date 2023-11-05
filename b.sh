#!/bin/bash

# hosts.txt ファイルからホスト名を読み込む
while IFS= read -r host; do
    # 各ホストに対してコマンドを実行
    echo "$host"
    rsh "$host" "sudo chown pi:pi /usr/local/apache2/htdocs/*" < /dev/null
    rcp htdocs/* "$host":/usr/local/apache2/htdocs

    rsh "$host" "sudo chown daemon:daemon /usr/local/apache2/htdocs/*" < /dev/null
    rsh "$host" "sudo chmod 755 /usr/local/apache2/htdocs/*" < /dev/null
    rsh "$host" "sudo /usr/local/apache2/bin/apachectl restart" < /dev/null
done < "hosts.txt"


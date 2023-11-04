#!/bin/bash

max_bg_procs=5
bg_procs=0

while IFS= read -r host; do
    (
        # ディレクトリが存在する場合にのみ削除
        rsh $host "sudo rm -r /usr/local/apache2/htdocs"

        # ディレクトリの作成
        rsh $host "sudo mkdir -p /usr/local/apache2/htdocs/images"
        rsh $host 'sudo mkdir -p /usr/local/apache2/htdocs/images2'

        # 必要なファイルのコピー
        rcp -r /home/pi/htdocs/* "$host":/usr/local/apache2/htdocs    

        # 権限と所有者の設定
        rsh $host "sudo chmod -R 755 /usr/local/apache2/htdocs"
        rsh $host "sudo chown -R daemon:daemon /usr/local/apache2/htdocs"

        # Apacheの再起動
        rsh $host "sudo /usr/local/apache2/bin/apachectl restart"
    ) &

    # バックグラウンドプロセス数の管理
    if (( bg_procs >= max_bg_procs )); then
        wait -n
        (( bg_procs-- ))
    fi
    (( bg_procs++ ))
done < hosts.txt

# 残りのバックグラウンドプロセスの完了を待つ
wait

echo "全ての処理が完了しました。"
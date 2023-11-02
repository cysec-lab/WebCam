#!/bin/bash

# 同時に実行する最大プロセス数
max_bg_procs=5
bg_procs=0

while IFS= read -r host; do
    (
        echo "$host をシャットダウンしています..."
        rsh "$host" 'sudo shutdown -h now'
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

echo "すべてのホストのシャットダウンが完了しました。"

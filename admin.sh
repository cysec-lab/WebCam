#!/bin/bash

HTDOCS_RECOVER_script_path="/home/pi/htdocsrecover.sh"
RECOVER_script_path="/home/pi/recover.sh"
Shutdown_script_path="/home/pi/allshutdown.sh"

while true; do
    echo "以下のオプションから選択してください:"
    echo "1) DNSの変更（DNSキャッシュポイズニング演習）"
    echo "2) リカバリー（特定のリモートホストに対して）"
    echo "3) リカバリー（すべてのリモートホストに対して）"
    echo "4) リモートホストの一斉終了"
    echo "5) プログラムを終了"
    read -p "選択 (1/2/3/4/5): " option

    case $option in
        1)
            echo "DNSの変更を実行します。"
            # DNS変更のコードをここに追加
            ;;
        2)
            echo "特定のリモートホストに対してリカバリーを実行します。"
            read -p "リモートホストのアドレスを入力してください (例: pi@192.168.3.100): " host_address
            sudo sh "$RECOVER_script_path" "$host_address"
            ;;
        3)
            echo "すべてのリモートホストに対してリカバリーを実行します。"
            sudo bash "$HTDOCS_RECOVER_script_path"
            ;;
        4)
            echo "リモートホストを一斉終了します。"
            sudo bash "$Shutdown_script_path"
            echo "リモートホストを一斉終了しました。"
            ;;
        5)
            echo "プログラムを終了します。"
            break
            ;;
        *)
            echo "無効な選択です。もう一度選んでください。"
            ;;
    esac
done

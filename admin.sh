#!/bin/bash

HTDOCS_RECOVER_script_path="htdocsrecover.sh"
RECOVER_script_path="recover.sh"
Shutdown_script_path="allshutdown.sh"
CHANGE_HOSTS="changehosts.sh"
REVERT_HOSTS="reverthosts.sh"

while true; do
    echo "以下のオプションから選択してください:"
    echo "1) DNSの変更（DNSキャッシュポイズニング演習用）"
    echo "2) DNSの変更（元に戻す）"
    echo "3) リカバリー（特定のリモートホストに対して）"
    echo "4) リカバリー（すべてのリモートホストに対して）"
    echo "5) リモートホストの一斉終了"
    echo "6) プログラムを終了"
    read -p "選択 (1/2/3/4/5/6): " option

    case $option in
        1)
            echo "DNSの変更を実行します。"
            sudo sh "$CHANGE_HOSTS"
            echo "変更を完了"
            ;;
        2)
            echo "DNSの変更を実行します。"
            sudo sh "$REVERT_HOSTS"
            echo "変更を完了"
            ;;
        3)
            echo "特定のリモートホストに対してリカバリーを実行します。"
            read -p "リモートホストのアドレスを入力してください (例:192.168.3.100): " host_address
            sh "$RECOVER_script_path" "$host_address"
            ;;
        4)
            echo "すべてのリモートホストに対してリカバリーを実行します。"
            sh "$HTDOCS_RECOVER_script_path"
            echo "リカバリーの完了"
            ;;
        5)
            echo "リモートホストを一斉終了します。"
            sh "$Shutdown_script_path"
            echo "リモートホストの一斉終了を完了"
            ;;
        6)
            echo "プログラムを終了します。"
            break
            ;;
        *)
            echo "無効な選択です。もう一度選んでください。"
            ;;
    esac
done

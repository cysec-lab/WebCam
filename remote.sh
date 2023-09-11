#!/bin/bash

# 引数が指定されていない場合のエラーメッセージを表示
if [ -z "$1" ]; then
    echo "使用方法: $0 <クライアント-IPアドレス>"
    exit 1
fi

# ステップ1: スクリプトをリモートホストにコピー
scp remote_setup.sh $1:/tmp/remote_setup.sh

# ステップ2: リモートホストでスクリプトを実行
ssh -n $1 "chmod +x /tmp/remote_setup.sh && sudo /tmp/remote_setup.sh"

# 任意: リモートホストからスクリプトを削除してクリーンアップ
ssh -n $1 "rm /tmp/remote_setup.sh"

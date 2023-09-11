#!/bin/bash

# 引数が指定されていない場合のエラーメッセージを表示
if [ -z "$1" ]; then
    echo "使用方法: $0 <ターゲット-IPアドレス>"
    exit 1
fi

targetIP="$1"

# ステップ1: リモートホストへの接続をテスト
ssh -o ConnectTimeout=5 $targetIP exit
if [ $? -ne 0 ]; then
    echo "エラー: $targetIP へのSSH接続ができませんでした"
    exit 1
fi

# ステップ2: リモートホストにダミーファイルをコピーしてテスト
echo "テスト" > testfile.txt
scp testfile.txt $targetIP:/tmp/testfile.txt
if [ $? -ne 0 ]; then
    echo "エラー: $targetIP にファイルをコピーできませんでした"
    rm testfile.txt
    exit 1
fi

# ステップ3: リモートホストでダミーファイルを削除してテスト
ssh -n $targetIP "rm /tmp/testfile.txt"
if [ $? -ne 0 ]; then
    echo "エラー: $targetIP でファイルの削除ができませんでした"
    rm testfile.txt
    exit 1
fi

echo "すべてのテストが成功しました！"
rm testfile.txt



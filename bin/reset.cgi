#!/bin/bash

# CGIプログラムとして、Content-Typeヘッダーを出力
echo "Content-type: text/plain;charset=utf-8"
echo ""  # HTTPヘッダーと本文の間に空行を挿入

# ファイルのコピー関数
copy_file() {
    local src="$1"
    local dst="$2"
    cp "$src" "$dst"
}

# /usr/local/apache2/htdocs/imagesディレクトリ内の全ファイルを削除
rm -rf /usr/local/apache2/htdocs/images/*

# /usr/local/apache2/htdocsディレクトリ内の全ファイルを削除（ディレクトリは除く）
rm /usr/local/apache2/htdocs/* 2>/dev/null

# /usr/local/apache2/backupから/usr/local/apache2/htdocsに特定のファイルをコピー
files_to_copy=("index.html" "album.html" "style.css" "index.js" "album.js")
for file in "${files_to_copy[@]}"; do
    copy_file "/usr/local/apache2/backup/$file" "/usr/local/apache2/htdocs/$file"
done

# version.txtをコピー
cp /usr/local/apache2/backup/version.txt /usr/local/apache2/cgi-bin

echo "初期化を完了しました"

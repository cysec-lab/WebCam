#!/bin/bash

# CGIプログラムとして、Content-Typeヘッダーを出力
echo "Content-type: text/plain;charset=utf-8"
echo ""

# エラーメッセージを日本語で出力する関数
log_error() {
    echo "エラー: $1"
}

# ファイルのコピー関数
copy_file() {
    local src="$1"
    local dst="$2"

    if ! cp "$src" "$dst"; then
        log_error "$src から $dst へのコピーに失敗しました。"
    fi
}

# /usr/local/apache2/htdocs/imagesディレクトリ内の全ファイルを削除
if ! rm -rf /usr/local/apache2/htdocs/images/*; then
    log_error "/usr/local/apache2/htdocs/images 内のファイルの削除に失敗しました。"
fi

# /usr/local/apache2/backupから/usr/local/apache2/htdocsに特定のファイルをコピー
files_to_copy=("index.html" "album.html" "style.css" "script.js")
for file in "${files_to_copy[@]}"; do
    copy_file "/usr/local/apache2/backup/$file" "/usr/local/apache2/htdocs/$file"
done

echo "初期化を完了しました"

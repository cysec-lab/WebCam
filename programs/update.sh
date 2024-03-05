#!/bin/bash

echo "Content-Type: text/plain; charset=UTF-8"
echo ""

# 定義する変数
DOWNLOAD_PATH="/usr/local/apache2/downloads/updatefile.tar.gz"
EXTRACT_DIR="/usr/local/apache2/cgi-bin"

#適切なURLに変更する
URL="https://handsoniotapp.com/downloads/updatefile.tar.gz"
UPDATE_SCRIPT="/usr/local/apache2/cgi-bin/updatefile/update.sh"

# ファイルのダウンロード
curl --insecure --output $DOWNLOAD_PATH $URL
if [ $? -ne 0 ]; then
    echo "ダウンロードに失敗しました。"
    exit 1
fi

# ファイルの権限を変更
chmod u=rwx,g=r,o=r $DOWNLOAD_PATH
if [ $? -ne 0 ]; then
    echo "ファイルの権限の変更に失敗しました。"
    exit 1
fi

# ダウンロードしたファイルを展開
tar --extract --gzip --file $DOWNLOAD_PATH --directory $EXTRACT_DIR
if [ $? -ne 0 ]; then
    echo "ファイルの展開に失敗しました。"
    exit 1
fi

# スクリプトの存在と実行可能かどうかを確認
if [ ! -f $UPDATE_SCRIPT ]; then
    echo "アップデートスクリプトが存在しません。"
    exit 1
fi

# スクリプトの権限を変更
chmod u=rwx,g=r,o=r $UPDATE_SCRIPT
if [ $? -ne 0 ]; then
    echo "アップデートスクリプトの権限の変更に失敗しました。"
    exit 1
fi

# スクリプトの実行
$UPDATE_SCRIPT
if [ $? -ne 0 ]; then
    echo "アップデートスクリプトの実行に失敗しました。"
    exit 1
fi

echo "アップデートが完了しました。"


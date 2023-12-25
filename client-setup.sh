#!/bin/bash

##サーバから設定ファイルを取得

# 標準入力から値を受け取る
read -p "アクセスするサーバーのIPアドレスを入力してください: " SERVER_IP_ADDR

# 設定ファイルのパス
configFile="setting.txt"

if ! wget -O $configFile http://$SERVER_IP_ADDR/setting.php; then
    echo "設定ファイルのダウンロードに失敗しました、終了します。"
    exit 1
fi

# 現在のIPアドレスを取得
CURRENT_IP=$(hostname -I | cut -d' ' -f1)

# 必要な行だけを読み込む
DNS_ADDR=$(grep '^DNS_ADDR=' $configFile | cut -d'=' -f2)

# 既存の設定を削除する
sudo sed -i '/^static routers=/d' /etc/dhcpcd.conf
sudo sed -i '/^static domain_name_servers=/d' /etc/dhcpcd.conf

# ネットワーク設定を修正する
echo "static domain_name_servers=$DNS_ADDR" | sudo tee -a /etc/dhcpcd.conf

# setting.txtの最後の3行をtarget.txtに保存する
tail -n 3 $configFile > target.txt
sudo cp target.txt /usr/local/apache2/cgi-bin

# setting.txtファイルからターゲットのIPアドレスを読み取る
SERVER_ADDR=$(grep "SERVER_ADDR" setting.txt | cut -d "=" -f 2)

# rshコマンドを利用できるようにするために、rshパッケージをインストール
sudo apt-get install -y rsh-client

# rshコマンドを利用するターゲットを指定するファイルを作成
echo "$SERVER_ADDR" > /home/pi/.rhosts

# ファイルのアクセス権を設定
sudo chmod 600 /home/pi/.rhosts

上記のスクリプトも以前のように簡潔に「だ・である」調で「、や。」のかわりに「,や.」を使用し、latexで使用できるように出力して
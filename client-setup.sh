#!/bin/bash

##サーバから設定ファイルを取得

# 標準入力から値を受け取る
read -p "Please enter the IP address of the server you wish to access: " SERVER_IP_ADDR

# 設定ファイルのパス
configFile="setting.txt"

if ! wget -O $configFile http://$SERVER_IP_ADDR/setting.php; then
    echo "Failed to download the configuration file, terminating."
    exit 1
fi

# 必要な行だけを読み込む
DNS_ADDR=$(grep '^DNS_ADDR=' $configFile | cut -d'=' -f2)
ID=$(tail -n 1 $configFile)


# 既存の設定を削除する
sudo sed -i '/^static domain_name_servers=/d' /etc/dhcpcd.conf

# ネットワーク設定を修正する
echo "static domain_name_servers=$DNS_ADDR" | sudo tee -a /etc/dhcpcd.conf

# setting.txtの最後の3行をtarget.txtに保存する
tail -n 3 $configFile > target.txt
sudo cp target.txt /usr/local/apache2/cgi-bin
sudo chown daemon:daemon /usr/local/apache2/cgi-bin/target.txt

# rsh-server パッケージのインストール
sudo apt-get install -y rsh-server xinetd

# setting.txtファイルからターゲットのIPアドレスを読み取る
SERVER_ADDR=$(grep "SERVER_ADDR" setting.txt | cut -d "=" -f 2)

# xinetd 用の rsh 設定ファイルの作成
echo "service shell
{
    disable         = no
    socket_type     = stream
    wait            = no
    user            = root
    server          = /usr/sbin/in.rshd
    log_on_success  += HOST USERID
    log_on_failure  += HOST USERID
}" | sudo tee /etc/xinetd.d/rsh

# xinetd サービスの再起動
sudo systemctl restart xinetd

# /etc/hosts.equiv ファイルの編集
echo "$SERVER_ADDR pi" | sudo tee -a /etc/hosts.equiv

#画像を5秒に一度取得するための設定
echo "[Unit]
Description=My script

[Service]
ExecStart=/usr/local/apache2/cgi-bin/picture.sh
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/picture.service

# システムにこの新しいサービスを登録
systemctl daemon-reload

# サービスを有効にして起動
systemctl enable picture.service
systemctl start picture.service

# 終了メッセージ
echo "**********************************"
echo "*Client setup has been completed.*"
echo "*    The device ID is $ID    *"
echo "**********************************"
#!/bin/bash

max_bg_procs=5
bg_procs=0

while IFS= read -r host; do
    (
        # 不要なファイルの削除
    rsh "$host" 'rm -r /usr/local/apache2/htdocs'
    rsh "$host" 'rm -rf /usr/local/apache2/cgi-bin'
    rsh "$host" 'rm -rf /usr/local/apache2/downloads'
    rsh "$host" 'rm -rf /usr/local/apache2/backup'

    # ディレクトリの作成
    rsh "$host" 'mkdir -p /usr/local/apache2/htdocs/images'
    rsh "$host" 'mkdir -p /usr/local/apache2/htdocs/images2'
    rsh "$host" 'mkdir -p /usr/local/apache2/downloads'
    rsh "$host" 'mkdir -p /usr/local/apache2/backup'

    # 必要なファイルのコピー
    rcp bin/* "$host":/usr/local/apache2/cgi-bin/
    rcp bin/* "$host":/usr/local/apache2/backup/
    rcp htdocs/* "$host":/usr/local/apache2/htdocs/
    rcp htdocs/* "$host":/usr/local/apache2/backup/
    rcp version.txt "$host":/usr/local/apache2/cgi-bin/
    rcp version.txt "$host":/usr/local/apache2/backup/

    # target.txtのコピーと編集
    rcp target.txt "$host":/home/pi
    rsh "$host" '
        # ローカルIPアドレスを取得
        IP_ADDRESS=$(hostname -I | awk "{print \$1}")
        HOST_PART=$(echo $IP_ADDRESS | cut -d. -f4)

        # ホスト部の前に1000を足す
        NEW_HOST_PART="1000${HOST_PART}"

        # target.txtの2行目と3行目に新しいホスト部を保存
        sed -i "2s/.*/${NEW_HOST_PART}/" /home/pi/target.txt
        sed -i "3s/.*/${NEW_HOST_PART}/" /home/pi/target.txt
    '

    # target.txtの移動と権限設定
    rsh "$host" 'cp /home/pi/target.txt /usr/local/apache2/cgi-bin/'
    rsh "$host" 'cp /home/pi/target.txt /usr/local/apache2/backup/'
    rsh "$host" 'chmod 775 /usr/local/apache2/backup/target.txt'
    rsh "$host" 'chmod 755 /usr/local/apache2/cgi-bin/target.txt'
    
    # ID/PW設定
    username="user"
    password="password"
    htpasswd_file="/usr/local/apache2/htdocs/.htpasswd"
    rsh "$host" "htpasswd -bc $htpasswd_file $username $password"

    # 権限設定
    rsh "$host" 'usermod -a -G video daemon'
    rsh "$host" 'chmod 755 /usr/local/apache2/htdocs/images'
    rsh "$host" 'chmod 755 /usr/local/apache2/htdocs/images2'
    rsh "$host" 'chmod 775 /usr/local/apache2/downloads'
    rsh "$host" 'chmod 775 /usr/local/apache2/backup'
    rsh "$host" 'chmod 755 /usr/local/apache2/cgi-bin/*'
    rsh "$host" 'chmod 755 /usr/local/apache2/htdocs/*'
    rsh "$host" 'chown daemon:daemon /usr/local/apache2/htdocs/images'
    rsh "$host" 'chown daemon:daemon /usr/local/apache2/htdocs/images2'
    rsh "$host" 'chown daemon:daemon /usr/local/apache2/downloads'
    rsh "$host" 'chown daemon:daemon /usr/local/apache2/backup'
    rsh "$host" 'chown daemon:daemon /usr/local/apache2/cgi-bin'
    rsh "$host" 'chown daemon:daemon /usr/local/apache2/cgi-bin/*'
    rsh "$host" 'chown daemon:daemon /usr/local/apache2/htdocs'
    rsh "$host" 'chown daemon:daemon /usr/local/apache2/htdocs/*'

    # Apacheの再起動
    rsh "$host" '/usr/local/apache2/bin/apachectl restart'

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

echo "全ての処理が完了しました。"

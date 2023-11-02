#sqlite3 /path/to/your/database.db
#.schema tablename

#!/bin/bash

# SQLiteデータベースファイル
db_file="/var/www/html/db/camera.db"

# 出力先のテキストファイル
output_file="/home/pi/camera.txt"

while true; do
    # ユーザーの入力に基づいて操作を選択
    echo "以下のオプションから選択してください:"
    echo "1) データベースからデータをクエリしてテキストファイルに出力"
    echo "2) データベースのテーブルを空にする"
    echo "3) テキストファイルのデータをデータベースのテーブルに挿入"
    echo "4) プログラム終了"
    read -p "選択 (1/2/3/4): " option

    case $option in
        1)
            # データベースからデータをクエリしてテキストファイルに出力
            sqlite3 "$db_file" "SELECT * FROM my_table;" > "$output_file"
            ;;
        2)
            # データベースのテーブルを空にする
            sqlite3 "$db_file" "DELETE FROM my_table;"
            ;;
        3)
            # テキストファイルのデータをデータベースのテーブルに挿入
            while IFS= read -r line; do
                # INSERT INTO コマンドは、テキストファイルの行形式とテーブルのスキーマに基づいて適宜変更してください
                sqlite3 "$db_file" "INSERT INTO my_table (column1, column2, ...) VALUES ($line);"
            done < "$output_file"
            ;;
        4)
            echo "プログラムを終了します。"
            break
            ;;
        *)
            echo "無効な選択です。"
            ;;
    esac
done

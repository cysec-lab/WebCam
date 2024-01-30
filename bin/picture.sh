#!/bin/bash

# target.txtからiptarget, id, apitokenを読み込む関数
read_target_file() {
  local line_number=1
  while read -r line; do
    case $line_number in
      1) iptarget=$line ;;
      2) id=$line ;;
      3) apitoken=$line ;;
    esac
    ((line_number++))
  done < /usr/local/apache2/cgi-bin/target.txt
}

# target.txtからデータを読み込む
read_target_file

# 写真を撮影し、ファイルとして保存
raspistill -q 10 -o /usr/local/apache2/htdocs/images2/now.jpg -t 100 -n

# HTTP POSTリクエストを行う
curl --max-time 2 -X POST "$iptarget" \
  -F "file_upload=@/usr/local/apache2/htdocs/images2/now.jpg" \
  -F "id=$id" \
  -F "apitoken=$apitoken"

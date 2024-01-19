#!/bin/bash

# コマンド1の開始時刻を記録
start_time1=$(date +%s)
# コマンド1を実行
sudo sh apache.sh
# コマンド1の終了時刻を記録し、実行時間を計算
end_time1=$(date +%s)
time1=$(($end_time1 - $start_time1))

# コマンド2の開始時刻を記録
start_time2=$(date +%s)
# コマンド2を実行
sudo sh webcam.sh
# コマンド2の終了時刻を記録し、実行時間を計算
end_time2=$(date +%s)
time2=$(($end_time2 - $start_time2))

# 2つのコマンドの実行時間を出力
echo "Command 1 (apache.sh) took $time1 seconds."
echo "Command 2 (webcam.sh) took $time2 seconds."

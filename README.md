# Raspberry Pi Zero/Zero 2用カスタムイメージセットアップガイド

このガイドでは、Raspberry Pi ZeroまたはRaspberry Pi Zero 2を使用してカスタムイメージのセットアップ方法を説明します。セットアップ完了後やサーバー起動時に行う手順も含まれます。

## Raspberry Pi Imagerの使用方法

1. 公式サイトからRaspberry Pi Imagerをダウンロードし、インストールします。[Raspberry Pi Imagerダウンロードページ](https://www.raspberrypi.com/software/)

## 含まれるもの

- カスタムイメージ
- 環境構築用スクリプトとファイル

## カスタムイメージをダウンロードする際の注意

カスタムイメージはGithub LFSを使用して管理されているため、コマンドライン上でリポジトリをクローンする前に準備が必要です。詳細な手順は[GitHub LFSのインストールガイド](https://docs.github.com/ja/repositories/working-with-files/managing-large-files/installing-git-large-file-storage)を参照してください。

![GitHubページからのダウンロード方法](https://github.com/BB)

## Git LFSのインストール

- **Linuxディストリビューション**
  - Debian系の場合: `sudo apt-get install git-lfs`
  - Red Hat系の場合: `sudo yum install git-lfs`
- **Windows**: `git lfs install`
- **MacOS**: `brew install git-lfs`

### 共通の手順
   `git lfs install
   git clone <リポジトリのURL>
   git lfs fetch
   git lfs checkout`


Imagerを開き、「Use custom」を選択して、ダウンロードしたカスタムイメージをMicroSDカードにインストールします。MicroSDカードは8GB以上のものを使用してください。

![カスタムイメージのImagerによる書き込み方法](https://github.com/AA)

## 実行手順

1. Raspberry Piの起動とログイン（ID: `pi` / PW: `raspberry`）
2. ネットワーク設定（`sudo raspi-config`の実行から可能）
3. `/home/pi/WebCam/client_setup.sh`の実行
4. 実行後、サーバーのIPアドレスを入力してください。

このガイドに従って、Raspberry Pi ZeroまたはZero 2でカスタムイメージのセットアップを完了させることができます。

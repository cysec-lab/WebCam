# WebCam セットアップガイド

このガイドは、Raspberry Piを使用してWebCamをセットアップする方法を説明します。手順に従って、教材インストール済みOSのインストールから環境の構築までを行ってください。

## Raspberry PiにOSをインストールする

まず、Raspberry PiにOSをインストールします。このプロセスには、Raspberry Pi Imagerが必要です。

### Raspberry Pi Imagerの使用方法

1. [Raspberry Pi Imagerダウンロードページ](https://www.raspberrypi.com/software/)からRaspberry Pi Imagerをダウンロードし、インストールしてください。

### セットアップに必要なファイル

- カスタムOSイメージ
- 環境構築用のスクリプトとファイル

### カスタムイメージのダウンロードについて

カスタムイメージはGitHub LFSを使用して管理されています。ダウンロード前に以下の手順を行ってください。

1. [GitHub LFSのインストールガイド](https://docs.github.com/ja/repositories/working-with-files/managing-large-files/installing-git-large-file-storage)に従い、GitHub LFSをインストールします。

### Git LFSのインストール方法

- **Linux（Debian系）**: `sudo apt-get install git-lfs`
- **Linux（Red Hat系）**: `sudo yum install git-lfs`
- **Windows**: `git lfs install`
- **MacOS**: `brew install git-lfs`
- **共通の手順**:`git lfs install`<br>
   `git clone <リポジトリのURL>`<br>
   `git lfs fetch`<br>
   `git lfs checkout`


### イメージのインストール

Raspberry Pi Imagerを開き、「Use custom」を選択して、ダウンロードしたカスタムイメージをMicroSDカードにインストールします。MicroSDカードは8GB以上を使用してください。

## セットアップ手順

1. Raspberry Piを起動し、ユーザー名`pi`、パスワード`raspberry`でログインします。
2. ネットワーク設定を行います。`sudo raspi-config`を実行して設定してください。
3. `/home/pi/WebCam/client_setup.sh`を実行します。
4. スクリプト実行後、プロンプトに従いサーバーのIPアドレスを入力してください。

以上の手順に従って、Raspberry Pi ZeroまたはZero 2でカスタムイメージを使用したWebCamのセットアップを完了させてください。

これは通常のテキストですが、<span style="color: red;">この部分だけ赤色</span>になります。

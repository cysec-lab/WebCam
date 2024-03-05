# WebCam セットアップガイド

このガイドは、Raspberry Piを使用してWebCamをセットアップする方法を説明します。手順に従って、教材インストール済みOSのインストールから環境の構築までを行ってください。

## アンケート回答のお願い
教材をご使用になる際には、使用前と使用後にアンケートへのご協力をお願いいたします。


[事前アンケート](https://forms.gle/4c3FoUHCMJg59THE8)

## 内容

- 教材インストール済みOSイメージ(WemCam.xz)
- 環境構築用スクリプトとファイル

## Raspberry PiにOSをインストールする

まず、Raspberry PiにOSをインストールします。このプロセスには、Raspberry Pi Imagerが必要です。

### Raspberry Pi Imagerの使用方法

1. [Raspberry Pi Imagerダウンロードページ](https://www.raspberrypi.com/software/)からRaspberry Pi Imagerをダウンロードし、インストールしてください。

### カスタムイメージのダウンロードについて

カスタムイメージはGitHub LFSを使用して管理されています。ダウンロード前に以下の手順を行ってください。

1. GitHubページからダウンロード
   「WebCam.xz」のみをダウンロードすることが可能です。
   ![Image_Download](https://github.com/RyoIHA/WebCam/blob/main/Figure/download.png)

2. [GitHub LFSのインストールガイド](https://docs.github.com/ja/repositories/working-with-files/managing-large-files/installing-git-large-file-storage)に従い、GitHub LFSをインストールします。

### Git LFSのインストール方法

- **Linux（Debian系）**: `sudo apt-get install git-lfs`
- **Linux（Red Hat系）**: `sudo yum install git-lfs`
- **Windows**: `git lfs install`
- **MacOS**: `brew install git-lfs`
- **以降共通の手順**:<br>
   `git lfs install`<br>
   `git clone <リポジトリのURL>`<br>
   `git lfs fetch`<br>
   `git lfs checkout`


### イメージのインストール

Raspberry Pi Imagerを開き、「Use custom」を選択して、ダウンロードしたカスタムイメージをMicroSDカードにインストールします。MicroSDカードは8GB以上を使用してください。

![Raspi-Image](https://github.com/RyoIHA/WebCam/blob/main/Figure/Imager.png)

## セットアップ手順
事前にサーバー用Raspberry Piの準備を完了し、サーバー用Raspberry Pi起動に行なってください。
1. Raspberry Piを起動し、ユーザー名`pi`、パスワード`raspberry`でログインします。
2. ネットワーク設定を行います。`sudo raspi-config`を実行して設定してください。
3. `/home/pi/WebCam/client_setup.sh`を実行し、設定ファイルの取得と設定を行います。
4. スクリプト実行後、プロンプトに従いサーバーのIPアドレスを入力してください。
![Csetup](https://github.com/RyoIHA/WebCam/blob/main/Figure/csetup.png)

以上の手順に従って、Raspberry Pi ZeroまたはZero 2でカスタムイメージを使用したWebCamのセットアップを完了させてください。

## WebCamアクセスガイド

このガイドでは、WebCamにアクセスして画像を閲覧、保存する方法について説明します。

### 動作イメージのアクセス方法
![Cimage](https://github.com/RyoIHA/WebCam/blob/main/Figure/cimage.png)
**アクセス**  
   Webブラウザから`http://<WebCamのIPアドレス>`にアクセスしてください。`<WebCamのIPアドレス>`は、実際のWebCamのIPアドレスに置き換えてください。

**ログイン**  
   アクセスするとBasic認証の画面が表示されます。次の認証情報を入力してログインしてください。
   - **ID:** user
   - **PW:** password

**ホーム画面**  
   ログイン後、自動的にホーム画面に移動します。ここでは、現在のカメラ画像が表示されます。

**画像の保存**  
   アルバムページに移動し、「保存」ボタンを押すことで、現在表示されている画像を取得し、保存できます。

**画像の名前変更**  
   画像一覧から変更したい画像名を入力し、「変更」ボタンを押すことで、選択した画像に変更できます。

### 注意事項

- **アップデート機能の使用不可**  
  現在、アップデート機能は使用できません。

## スクリプトのみで準備する場合

以下の手順で環境構築を行なってください。ターミナルまたはコマンドプロンプトを開いて、以下のコマンドを実行してください。


`git clone <リポジトリのURL>`<br>
`cd WebCam`<br>
`sudo sh webcam.sh`<br>
`sudo bash client-setup.sh`





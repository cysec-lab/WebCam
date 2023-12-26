## 🛠️ Description of Shell Scripts
- **apache.sh**: Installs Apache 2.4.49. This process usually takes about 20-30 minutes.
- **webcam.sh**: Sets up the necessary configurations for the application's execution and copies resources like HTML, CSS, JavaScript, and CGI programs.
- **client-setup.sh**: Connects to the server and downloads configuration files.

## 🚀 Setup Instructions
Execute the following scripts in order:
   ```sh
   sudo sh apache.sh
   sudo sh webcam.sh
   sudo bash client-setup.sh SERVER_IP_ADDR

シェルスクリプトの説明：
・apache.sh: Apache 2.4.49をインストールします。このプロセスには通常、約20-30分かかります。
・webcam.sh: アプリケーションの実行に必要な設定を行い、HTML、CSS、JavaScript、CGIプログラムなどのリソースをコピーします。
・client-setup.sh: サーバーに接続し、設定ファイルをダウンロードします。

セットアップ手順：
以下のスクリプトを順番に実行してください
   ```sh
   sudo sh apache.sh
   sudo bash client-setup.sh SERVER_IP_ADDR```

カスタムイメージの説明：
上記のセットアップを完了したカスタムイメージを用意しています。
必要な手順は以下の実行のみです。
    ```sh
   sudo bash client-setup.sh SERVER_IP_ADDR```
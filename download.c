#include <stdio.h>
#include <curl/curl.h>

int main(void) {
    // HTTPヘッダーを出力
    printf("Content-type: text/plain\n\n");

    CURL *curl;
    CURLcode res;
    FILE *file;
    FILE *logFile;
    const char *download_path = "/usr/local/apache2/downloads/updatefile.tar.gz";
    const char *url = "https://handsontiotapp.com/downloads/updatefile.tar.gz";
    const char *log_path = "download_log.txt";

    // libcurlの初期化
    curl_global_init(CURL_GLOBAL_DEFAULT);
    curl = curl_easy_init();

    if(curl) {
        // ファイルへの書き込みの準備
        file = fopen(download_path, "wb");
        if(!file) {
            perror("Error opening file for writing");
            return 1;
        }

        // ログファイルの準備
        logFile = fopen(log_path, "a");
        if(!logFile) {
            perror("Error opening log file for writing");
            fclose(file);
            return 1;
        }

        // URLの設定
        curl_easy_setopt(curl, CURLOPT_URL, url);

        // サーバ証明書検証を無効にする
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L);
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 0L);

        // ダウンロードデータをファイルに書き込む
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, file);

        // ダウンロードの実行
        res = curl_easy_perform(curl);

        // エラー処理
        if(res != CURLE_OK) {
            fprintf(logFile, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        }

        // リソースの解放
        fclose(file);
        fclose(logFile);
        curl_easy_cleanup(curl);
    }

    curl_global_cleanup();
    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>
#include <archive.h>
#include <archive_entry.h>
#include <sys/stat.h>
#include <unistd.h>

int main(void) {
    // HTTPヘッダーを出力
    printf("Content-type: text/plain\n\n");

    CURL *curl;
    CURLcode res;
    FILE *file;
    FILE *logFile;
    const char *download_path = "/usr/local/apache2/downloads/updatefile.tar.gz";
    const char *url = "https://handsoniotapp.com/downloads/updatefile.tar.gz";
    const char *log_path = "download_log.txt";
    const char *script_path = "/usr/local/apache2/cgi-bin/updatefile/update.sh";

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
            long response_code;
            curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
            fprintf(logFile, "HTTP response code: %ld\n", response_code);
        }

        // リソースの解放
        fclose(file);
        curl_easy_cleanup(curl);

        // ダウンロードしたファイルの権限を+wにする
        if(res == CURLE_OK) {
            if (chmod(download_path, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH) == 0) {
                fprintf(logFile, "File permissions changed successfully.\n");
            } else {
                perror("Error changing file permissions");
                fclose(logFile);
                return 1;
            }

            // ダウンロードしたファイルの展開
            struct archive *a;
            struct archive *ext;
            struct archive_entry *entry;
            int r;

            a = archive_read_new();
            archive_read_support_format_tar(a);
            archive_read_support_filter_gzip(a);
            if ((r = archive_read_open_filename(a, download_path, 10240))) {
                fprintf(logFile, "archive_read_open_filename() failed: %s\n", archive_error_string(a));
                return 1;
            }

            ext = archive_write_disk_new();
            archive_write_disk_set_options(ext, ARCHIVE_EXTRACT_TIME);

            while (archive_read_next_header(a, &entry) == ARCHIVE_OK) {
                const char *current_file = archive_entry_pathname(entry);
                fprintf(logFile, "Extracting file: %s\n", current_file);
                r = archive_write_header(ext, entry);
                if (r < ARCHIVE_OK) {
                    fprintf(logFile, "archive_write_header() failed: %s\n", archive_error_string(ext));
                }
                if (archive_entry_size(entry) > 0) {
                    char buffer[8192];
                    size_t size;
                    while ((size = archive_read_data(a, buffer, sizeof(buffer))) > 0) {
                        archive_write_data(ext, buffer, size);
                    }
                }
                r = archive_write_finish_entry(ext);
                if (r < ARCHIVE_OK) {
                    fprintf(logFile, "archive_write_finish_entry() failed: %s\n", archive_error_string(ext));
                }
            }

            archive_read_close(a);
            archive_read_free(a);
            archive_write_close(ext);
            archive_write_free(ext);

            fclose(logFile);

            // スクリプトファイルに権限+xを付与
            if (chmod(script_path, S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IROTH) == 0) {
            } else {
                perror("Error changing script permissions");
                return 1;
            }

            // スクリプトの実行
            int system_res = system(script_path);
            if(system_res == -1) {
                perror("Error executing script");
                return 1;
            }
        }
    }
     printf("Update successfully.\n");
    curl_global_cleanup();
    return 0;
}
//tar -czvf updatefile.tar.gz updatefile



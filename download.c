#include <stdio.h>
#include <curl/curl.h>
#include <archive.h>
#include <archive_entry.h>

#define REMOTE_URL "http://192.168.100.101/downloads/updatefile.tar.gz"
#define LOCAL_PATH "/usr/local/apache2/downloads/updatefile.tar.gz"

int extract_tar_gz(const char* filename) {
    struct archive *a;
    struct archive *ext;
    struct archive_entry *entry;
    int flags;
    int r;

    a = archive_read_new();
    ext = archive_write_disk_new();
    archive_write_disk_set_options(ext, ARCHIVE_EXTRACT_TIME);
    archive_read_support_filter_all(a);
    archive_read_support_format_all(a);
    r = archive_read_open_filename(a, filename, 10240); // ファイルを開く
    if (r != ARCHIVE_OK) {
        return 1;
    }
    for (;;) {
        r = archive_read_next_header(a, &entry);
        if (r == ARCHIVE_EOF) {
            break;
        }
        if (r != ARCHIVE_OK) {
            return 1;
        }
        // ファイルを展開
        r = archive_write_header(ext, entry);
        if (r != ARCHIVE_OK) {
            return 1;
        }
        for (;;) {
            char buff[8192];
            int size;
            size = archive_read_data(a, buff, sizeof(buff));
            if (size <= 0) {
                break;
            }
            r = archive_write_data(ext, buff, size);
            if (r != ARCHIVE_OK) {
                return 1;
            }
        }
        r = archive_write_finish_entry(ext);
        if (r != ARCHIVE_OK) {
            return 1;
        }
    }
    archive_read_close(a);
    archive_read_free(a);
    archive_write_close(ext);
    archive_write_free(ext);
    return 0;
}

int main() {
    CURL *curl;
    CURLcode res;
    FILE *fp;

    printf("Content-type: text/plain\n\n");

    curl_global_init(CURL_GLOBAL_DEFAULT);
    curl = curl_easy_init();
    if (curl) {
        fp = fopen(LOCAL_PATH, "wb");
        if (fp == NULL) {
            printf("Error opening file for writing: %s\n", LOCAL_PATH);
            return 1;
        }

        curl_easy_setopt(curl, CURLOPT_URL, REMOTE_URL);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);
        curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1L);

        // Disable SSL certificate verification
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L);
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 0L);

        res = curl_easy_perform(curl);
        fclose(fp);

        if (res != CURLE_OK) {
            printf("Download failed: %s\n", curl_easy_strerror(res));
            curl_easy_cleanup(curl);
            curl_global_cleanup();
            return 1;
        } else {
            printf("Download succeeded!\n");
        }

        curl_easy_cleanup(curl);
    }

    curl_global_cleanup();

    // ダウンロードしたファイルを展開
    int ret = extract_tar_gz(LOCAL_PATH);
    if (ret != 0) {
        printf("Extraction failed!\n");
        return 1;
    }

    printf("Extraction succeeded!\n");

    return 0;
}


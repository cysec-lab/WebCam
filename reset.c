以下のプログラムが正常に終了した場合、正常終了したと分かるメッセージを返すように修正して
プログラムは省略せずに出力して
include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>

void log_error(const char *message) {
    FILE *file = fopen("reset_log.txt", "a"); // ファイル名を「reset_log.txt」に変更
    if (file != NULL) {
        fprintf(file, "%s\n", message);
        fclose(file);
    }
}

int main(void) {
    struct dirent *entry;
    DIR *dp = opendir("/usr/local/apache2/htdocs/images");
    char filepath[512];
    const char *src_index = "/usr/local/apache2/backup/index.html";
    const char *dst_index = "/usr/local/apache2/htdocs/index.html";
    const char *src_version = "/usr/local/apache2/backup/version.txt";
    const char *dst_version = "/usr/local/apache2/cgi-bin/version.txt";

    printf("Content-type: text/html\n\n");

    if (dp == NULL) {
        log_error("Could not open the directory /usr/local/apache2/htdocs/images");
        printf("<p>Error: Could not open the directory.</p>");
        return EXIT_FAILURE;
    }

    while ((entry = readdir(dp))) {
        if (strstr(entry->d_name, ".jpg") != NULL) {
            snprintf(filepath, sizeof(filepath), "/usr/local/apache2/htdocs/images/%s", entry->d_name);
            if (unlink(filepath) == -1) {
                char error_message[512];
                snprintf(error_message, sizeof(error_message), "Failed to delete file: %s", filepath);
                log_error(error_message);
                printf("<p>Error: Failed to delete %s</p>", entry->d_name);
            } else {
                printf("<p>Deleted: %s</p>", entry->d_name);
            }
        }
    }

    closedir(dp);

    // /usr/local/apache2/htdocs/index.html の削除
    if (unlink(dst_index) == -1) {
        log_error("Failed to delete /usr/local/apache2/htdocs/index.html");
        printf("<p>Error: Failed to delete index.html</p>");
    } else {
        printf("<p>Deleted: index.html</p>");
    }

    // /usr/local/apache2/backup/index.html のコピー
    FILE *src_file = fopen(src_index, "rb");
    FILE *dst_file = fopen(dst_index, "wb");
    if (src_file != NULL && dst_file != NULL) {
        char buffer[512];
        size_t size;

        while ((size = fread(buffer, 1, sizeof(buffer), src_file)) > 0) {
            fwrite(buffer, 1, size, dst_file);
        }

        fclose(src_file);
        fclose(dst_file);
        printf("<p>Copied: index.html</p>");
    } else {
        log_error("Failed to copy index.html");
        printf("<p>Error: Failed to copy index.html</p>");
    }

    // /usr/local/apache2/backup/version.txt のコピー
    src_file = fopen(src_version, "rb");
    dst_file = fopen(dst_version, "wb");
    if (src_file != NULL && dst_file != NULL) {
        char buffer[512];
        size_t size;

        while ((size = fread(buffer, 1, sizeof(buffer), src_file)) > 0) {
            fwrite(buffer, 1, size, dst_file);
        }

        fclose(src_file);
        fclose(dst_file);
        printf("<p>Copied: version.txt</p>");
    } else {
        log_error("Failed to copy version.txt");
        printf("<p>Error: Failed to copy version.txt</p>");
    }

    return EXIT_SUCCESS;
}

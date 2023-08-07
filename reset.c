#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>

void log_error(const char *message) {
    FILE *file = fopen("reset_log.txt", "a");
    if (file != NULL) {
        fprintf(file, "%s\n", message);
        fclose(file);
    }
}

void copy_file(const char *src, const char *dst) {
    FILE *src_file = fopen(src, "rb");
    FILE *dst_file = fopen(dst, "wb");
    if (src_file != NULL && dst_file != NULL) {
        char buffer[512];
        size_t size;

        while ((size = fread(buffer, 1, sizeof(buffer), src_file)) > 0) {
            fwrite(buffer, 1, size, dst_file);
        }

        fclose(src_file);
        fclose(dst_file);
    } else {
        char error_message[512];
        if (src_file == NULL) {
            snprintf(error_message, sizeof(error_message), "Failed to open source file: %s", src);
        } else if (dst_file == NULL) {
            snprintf(error_message, sizeof(error_message), "Failed to open destination file: %s", dst);
        }
        log_error(error_message);
    }
}

int main(void) {
    struct dirent *entry;
    DIR *dp = opendir("/usr/local/apache2/htdocs/images");
    char filepath[512];

    printf("Content-type: text/html\n\n");

    // Delete all files in /usr/local/apache2/htdocs/images
    while ((entry = readdir(dp))) {
        snprintf(filepath, sizeof(filepath), "/usr/local/apache2/htdocs/images/%s", entry->d_name);
    }

    closedir(dp);

    // Copy index.html, album.html, style.css, script.js to /usr/local/apache2/htdocs
    const char *files_to_copy[] = {"index.html", "album.html", "style.css", "script.js"};
    for (int i = 0; i < sizeof(files_to_copy) / sizeof(files_to_copy[0]); i++) {
        char src_path[512];
        char dst_path[512];
        snprintf(src_path, sizeof(src_path), "/usr/local/apache2/backup/%s", files_to_copy[i]);
        snprintf(dst_path, sizeof(dst_path), "/usr/local/apache2/htdocs/%s", files_to_copy[i]);
        copy_file(src_path, dst_path);
    }

    // Copy all .cgi and .txt files to /usr/local/apache2/cgi-bin
    dp = opendir("/usr/local/apache2/backup");
    if (dp != NULL) {
        while ((entry = readdir(dp))) {
            if (strstr(entry->d_name, ".cgi") != NULL || strstr(entry->d_name, ".txt") != NULL) {
                snprintf(filepath, sizeof(filepath), "/usr/local/apache2/backup/%s", entry->d_name);
                char dst_path[512];
                snprintf(dst_path, sizeof(dst_path), "/usr/local/apache2/cgi-bin/%s", entry->d_name);
                copy_file(filepath, dst_path);
            }
        }
        closedir(dp);
    } else {
        log_error("Could not open the directory /usr/local/apache2/backup");
    }

    printf("Finish\n\n");

    return EXIT_SUCCESS;
}

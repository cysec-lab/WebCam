#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>

void log_error(const char *message) {
    FILE *file = fopen("error_res_log.txt", "a");
    if (file != NULL) {
        fprintf(file, "%s\n", message);
        fclose(file);
    }
}

int main(void) {
    struct dirent *entry;
    DIR *dp = opendir("/usr/local/apache2/htdocs/images");
    char filepath[512];

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
    return EXIT_SUCCESS;
}

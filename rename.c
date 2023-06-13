#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define RENAME_COMMAND "mv /usr/local/apache2/htdocs/images/%s /usr/local/apache2/htdocs/images/%s"
//#define RENAME_COMMAND "mv \"/usr/local/apache2/htdocs/images/%s\" \"/usr/local/apache2/htdocs/images/%s\""

void url_decode(char *str) {
    char *p = str;
    char code[3] = {0};
    unsigned long ascii = 0;
    char *end = NULL;

    while (*p) {
        if (*p == '%' && *(p+1) == '2' && *(p+2) == '0') { // detect '%20'
            *str++ = ' ';
            p += 3;
        } else if (*p == '+') {
            *str++ = ' ';
            p++;
        } else {
            *str++ = *p++;
        }
    }

    *str = '\0';
}

char *get_param(const char *param) {
    char *query = getenv("QUERY_STRING");
    if (query == NULL) return NULL;

    char *param_eq = malloc(strlen(param) + 2);
    sprintf(param_eq, "%s=", param);

    char *start = strstr(query, param_eq);
    free(param_eq);

    if (start == NULL) return NULL;

    start += strlen(param) + 1; // Skip past "param="

    char *end = strchr(start, '&');
    if (end == NULL) end = start + strlen(start); // No more params

    char *value = malloc(end - start + 1);
    strncpy(value, start, end - start);
    value[end - start] = '\0';

    return value;
}

int main() {
    char *old_name = get_param("old");
    char *new_name = get_param("new");

    url_decode(old_name);
    url_decode(new_name);

    if (old_name == NULL || new_name == NULL) {
        printf("Content-Type: text/plain\n\n");
        printf("Invalid parameters.\n");
        free(old_name);
        free(new_name);
        return 1;
    }

    char command[512];
    snprintf(command, sizeof(command), RENAME_COMMAND, old_name, new_name);

    int result = system(command);

    if (result == 0) {
        printf("Content-Type: text/plain\n\n");
        printf("Image successfully renamed: %s\n", new_name);
    } else {
        printf("Content-Type: text/plain\n\n");
        printf("Error renaming image. Error code: %d\n", result);
    }

    free(old_name);
    free(new_name);

    return 0;
}

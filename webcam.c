#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sqlite3.h>
#include <dirent.h>

#define CAPTURE_COMMAND "libcamera-still -o %s -t 100"
#define RENAME_COMMAND "mv"

int authenticate_user(const char *username, const char *password)
{
    sqlite3 *db;
    sqlite3_stmt *stmt;
    const char *sql = "SELECT * FROM users WHERE username=? AND password=?;";
    int result = 0;

    if (sqlite3_open("users.db", &db) != SQLITE_OK){
        printf("Content-Type: text/plain\n\n");
        printf("Error opening database\n");
        return -1;
    }

    if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK){
        printf("Content-Type: text/plain\n\n");
        printf("Error preparing SQL statement\n");
        sqlite3_close(db);
        return -1;
    }

    sqlite3_bind_text(stmt, 1, username, -1, SQLITE_STATIC);
    sqlite3_bind_text(stmt, 2, password, -1, SQLITE_STATIC);

    if (sqlite3_step(stmt) == SQLITE_ROW){
        result = 1;
    }

    sqlite3_finalize(stmt);
    sqlite3_close(db);

    return result;
}

void capture_image()
{
    time_t rawtime;
    struct tm *timeinfo;
    char filename[80];

    time(&rawtime);
    timeinfo = localtime(&rawtime);
    strftime(filename, sizeof(filename), "%Y_%m_%d_%H_%M_%S.jpg", timeinfo);

    char path[256];
    snprintf(path, sizeof(path), "/var/www/html/images/%s", filename);

    char command[512];
    snprintf(command, sizeof(command), CAPTURE_COMMAND, path);

    int result = system(command);
    
    if (result == 0){
        printf("Content-Type: text/plain\n\n");
        printf("Image captured and saved: %s\n", filename);
    }else{
        printf("Content-Type: text/plain\n\n");
        printf("Error capturing image. Error code: %d\n", result);
    }
}

void list_images()
{
    DIR *dir;
    struct dirent *entry;

    dir = opendir("/var/www/html/images");
    if (dir == NULL){
        printf("Content-Type: text/plain\n\n");
        printf("Error opening images directory\n");
        return;
    }

    printf("Content-Type: application/json\n\n");
    printf("[");

    int first = 1;
    while ((entry = readdir(dir)) != NULL){
        if (entry->d_type == DT_REG){
            if (!first){
                printf(", ");
            }
            printf("\"%s\"", entry->d_name);
            first = 0;
        }
    }

    printf("]");

    closedir(dir);
}

void rename_image(const char *old_name, const char *new_name)
{
    char old_path[256], new_path[256],command[512];
    snprintf(old_path, sizeof(old_path), "/var/www/html/images/%s", old_name);
    snprintf(new_path, sizeof(new_path), "/var/www/html/images/%s", new_name);
    snprintf(command, sizeof(command), RENAME_COMMAND,old_name,new_name);

    int result = rename(old_path, new_path);

    if (result == 0){
        printf("Content-Type: text/plain\n\n");
        printf("Image successfully renamed: %s\n", new_name);
    }else{
        printf("Content-Type: text/plain\n\n");
        printf("Error renaming image. Error code: %d\n", result);
    }
}

int main()
{
    char *request_method = getenv("REQUEST_METHOD");
    char *query_string = getenv("QUERY_STRING");

    if (strcmp(request_method, "GET") == 0){
        if (strstr(query_string, "capture") != NULL){
            capture_image();
        }else if (strstr(query_string, "list") != NULL){
            list_images();
        }
    }else if (strcmp(request_method, "POST") == 0){
        char *content_length_str = getenv("CONTENT_LENGTH");
        int content_length = atoi(content_length_str);

        char post_data[content_length + 1];
        fread(post_data, content_length, 1, stdin);
        post_data[content_length] = '\0';

        char username[64], password[64];
        sscanf(post_data, "username=%[^&]&password=%s", username, password);

        if (authenticate_user(username, password) == 1){
            printf("Content-Type: text/html\n\n");
            printf("<html><head>");
            printf("<meta http-equiv=\"refresh\" content=\"0;/capture_image.html\">");
            printf("</head><body></body></html>");
        }else{
            printf("Content-Type: text/plain\n\n");
            printf("Authentication failed\n");
        }
    }
    return 0;
}


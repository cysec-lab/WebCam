#include <stdio.h>
#include <stdlib.h>
#include <string.h> // for strcspn()

int main(void) {
    char version[100] = "情報なし";  // Default value set here
    char *from_ip = getenv("REMOTE_ADDR");
    char *user_agent = getenv("HTTP_USER_AGENT");

    if (from_ip == NULL) {
        from_ip = "情報なし";
    }

    if (user_agent == NULL) {
        user_agent = "情報なし";
    }

    // バージョンファイルを読み込むためのファイルポインタ
    FILE *file;
    // バージョンファイルを開く
    file = fopen("version.txt", "r");
    if (file != NULL) {  // Only try to read if the file was opened successfully
        // バージョン情報をファイルから読み取る
        if (fgets(version, sizeof(version), file) != NULL) {
            // 改行文字を取り除く（もし存在するなら）
            version[strcspn(version, "\n")] = '\0';
        }
        // ファイルを閉じる
        fclose(file);
    }

    printf("Content-type: application/json\n\n");
    printf("{\n");
    printf("\"version\": \"%s\",\n", version);
    printf("\"ip_address\": \"%s\",\n", from_ip);
    printf("\"user_agent\": \"%s\"\n", user_agent);
    printf("}\n");

    return 0;
}
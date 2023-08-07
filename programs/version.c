#include <stdio.h>
#include <stdlib.h>

int main() {
    // バージョン情報を格納するバッファ
    char version[100];

    // バージョンファイルを読み込むためのファイルポインタ
    FILE *file;

    // バージョンファイルを開く
    file = fopen("version.txt", "r");
    if (file == NULL) {
        // ファイルを開けなかった場合はエラーを出力して終了
        printf("Content-type: text/plain\r\n\r\n");
        printf("情報なし");
        return 1;
    }

    // バージョン情報をファイルから読み取る
    if (fgets(version, sizeof(version), file) == NULL) {
        // ファイルからの読み取りに失敗した場合はエラーを出力して終了
        printf("Content-type: text/plain\r\n\r\n");
        printf("情報なし");
        fclose(file);
        return 1;
    }

    // ファイルを閉じる
    fclose(file);

    // バージョン情報を出力する
    printf("Content-type: text/plain\r\n\r\n");
    printf("%s", version);

    return 0;
}


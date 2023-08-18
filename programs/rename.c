#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// URLデコード関数
char *url_decode(const char *str) {
  int d = 0; /* 文字列がデコードされたかどうかのフラグ */

  char *dStr = malloc(strlen(str) + 1); // デコード後の文字列を格納するためのメモリを確保
  char eStr[] = "00"; /* 16進数のコード用 */

  strcpy(dStr, str); // 入力文字列をコピー

  // デコードが完了するまでループ
  while(!d) {
    d = 1; // フラグを初期化
    int i; // 文字列のカウンタ

    // 文字列の各文字を調べる
    for(i=0; i<strlen(dStr); ++i) {

      // '%'を見つけたら
      if(dStr[i] == '%') {
        if(dStr[i+1] == 0)
          return dStr; // 文字列の終端に達した場合はデコード済みの文字列を返す

        // 2つの16進数文字を見つけたら
        if(isxdigit(dStr[i+1]) && isxdigit(dStr[i+2])) {

          d = 0; // フラグをクリア

          // 次の2つの数字を結合
          eStr[0] = dStr[i+1];
          eStr[1] = dStr[i+2];

          // 16進数を10進数に変換
          long int x = strtol(eStr, NULL, 16);

          // 16進数を削除
          memmove(&dStr[i+1], &dStr[i+3], strlen(&dStr[i+3])+1);

          // デコードした文字を挿入
          dStr[i] = x;
        }
      }
      // '+'を見つけたらスペースに変換
      else if(dStr[i] == '+') { dStr[i] = ' '; }
    }
  }

  // デコード済みの文字列を返す
  return dStr;
}

// 特定のパラメータを取得する関数
char *get_param(const char *param) {
    char *query = getenv("QUERY_STRING"); // クエリ文字列を取得
    if (query == NULL) return NULL; // クエリがなければNULLを返す

    char *param_eq = malloc(strlen(param) + 2);
    sprintf(param_eq, "%s=", param); // パラメータ名に"="を付ける

    char *start = strstr(query, param_eq); // パラメータ名がクエリ内にあるか探す
    free(param_eq); // メモリを解放

    if (start == NULL) return NULL; // パラメータが見つからなければNULLを返す

    start += strlen(param) + 1; // パラメータ名と"="をスキップ

    char *end = strchr(start, '&'); // 次のパラメータの開始位置を探す
    if (end == NULL) end = start + strlen(start); // 次のパラメータがなければ現在のパラメータの終わりまでとする

    char *value = malloc(end - start + 1); // パラメータ値を格納するためのメモリを確保
    strncpy(value, start, end - start); // パラメータ値をコピー
    value[end - start] = '\0'; // 文字列の終端にヌル文字をセット

    // パラメータ値を返す
    return value;
}

int main() {
    chdir("/usr/local/apache2/htdocs/images");
    char *old_name = get_param("old"); // "old"パラメータを取得
    char *new_name = get_param("new"); // "new"パラメータを取得

    // "old"パラメータが存在すればURLデコードする
    if (old_name != NULL) {
        char* decoded_old_name = url_decode(old_name);
        free(old_name); // メモリを解放
        old_name = decoded_old_name; // デコードした値をセット
    }

    // "new"パラメータが存在すればURLデコードする
    if (new_name != NULL) {
        char* decoded_new_name = url_decode(new_name);
        free(new_name); // メモリを解放
        new_name = decoded_new_name; // デコードした値をセット
    }

    if (old_name == NULL || new_name == NULL) {
        printf("Content-Type: text/plain\n\n");
        printf("Invalid parameters.\n");
        free(old_name); // メモリを解放
        free(new_name); // メモリを解放
        return 1; // エラーコードを返す
    }

    //名前変更
    char command[128];
    snprintf(command, sizeof(command), "mv %s %s", old_name, new_name);
    system(command);

    // メモリを解放
    free(old_name);
    free(new_name);

    return 0;
}

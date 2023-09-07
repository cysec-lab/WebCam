#include <stdio.h>
#include <stdlib.h>

int main(void) {
    // コンテンツタイプを出力（HTMLとして出力する場合）
    printf("Content-type: text/html\n\n");

    // 環境変数HTTP_USER_AGENTからUser-Agentを取得
    char *user_agent = getenv("HTTP_USER_AGENT");

    // User-Agentが取得できなかった場合のエラーチェック
    if(user_agent == NULL) {
        printf("<p>User-Agent could not be determined.</p>");
        return 1;
    }

    // User-Agentを出力
    printf("<p>Your User-Agent is: %s</p>", user_agent);

    return 0;
}

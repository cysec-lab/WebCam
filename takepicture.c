#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

#define BUFFER_SIZE 1024  // 1Kバイト

// target.txtからiptarget, id, apitokenを読み込む関数
void read_target_file(char *iptarget, char *id, char *apitoken) {
    FILE *file = fopen("target.txt", "r");
    if (file == NULL) {
        printf("Could not open target.txt\n");
        exit(EXIT_FAILURE);
    }

    fgets(iptarget, BUFFER_SIZE, file);
    iptarget[strcspn(iptarget, "\n")] = 0;  // 改行文字を除去
    fgets(id, BUFFER_SIZE, file);
    id[strcspn(id, "\n")] = 0;  // 改行文字を除去
    fgets(apitoken, BUFFER_SIZE, file);
    apitoken[strcspn(apitoken, "\n")] = 0;  // 改行文字を除去

    fclose(file);  // ファイルを閉じる
}

int main(void) {
    CURL *curl;
    CURLcode res;

    struct curl_httppost *formpost=NULL;
    struct curl_httppost *lastptr=NULL;
    struct curl_slist *headerlist=NULL;
    static const char buf[] = "Expect:";

    char iptarget[BUFFER_SIZE];
    char id[BUFFER_SIZE];
    char apitoken[BUFFER_SIZE];

    read_target_file(iptarget, id, apitoken);  // target.txtからデータを読み込む

    printf("Content-type: text/html\n\n");

    // 写真を撮影し、ファイルとして保存
    system("raspistill -q 10 -o /usr/local/apache2/htdocs/images2/now.jpg -t 100");

    // libcurlを初期化
    curl_global_init(CURL_GLOBAL_ALL);

    // フォームにデータを追加。アップロードするファイル名は写真を保存したパスと同じ
    curl_formadd(&formpost,
                 &lastptr,
                 CURLFORM_COPYNAME, "file_upload",
                 CURLFORM_FILE, "/usr/local/apache2/htdocs/images2/now.jpg",
                 CURLFORM_END);

    // idとapitokenを読み込んだデータから設定
    curl_formadd(&formpost,
                 &lastptr,
                 CURLFORM_COPYNAME, "id",
                 CURLFORM_COPYCONTENTS, id,
                 CURLFORM_END);

    curl_formadd(&formpost,
                 &lastptr,
                 CURLFORM_COPYNAME, "apitoken",
                 CURLFORM_COPYCONTENTS, apitoken,
                 CURLFORM_END);

    curl = curl_easy_init();  // curlハンドルを初期化
    headerlist = curl_slist_append(headerlist, buf);  // HTTPヘッダリストに追加
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, iptarget);  // URLをセット
        curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);  // HTTP POSTデータをセット

        res = curl_easy_perform(curl);  // リクエストを実行

        // リクエストが失敗した場合のエラーハンドリング
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n",
                    curl_easy_strerror(res));

        curl_easy_cleanup(curl);  // curlハンドルをクリーンアップ

        curl_formfree(formpost);  // フォームポストデータを解放

        curl_slist_free_all (headerlist);  // HTTPヘッダリストを解放
    }

    return 0;
}

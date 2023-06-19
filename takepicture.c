#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main(void) {

    CURL *curl;
    CURLcode res;

    struct curl_httppost *formpost=NULL;
    struct curl_httppost *lastptr=NULL;
    struct curl_slist *headerlist=NULL;
    static const char buf[] = "Expect:";

    printf("Content-type: text/html\n\n");

    // 写真を撮り、ファイルとして保存
    system("raspistill -q 10 -o /usr/local/apache2/htdocs/images2/now.jpg -t 100");

    // libcurlを初期化
    curl_global_init(CURL_GLOBAL_ALL);

    // フォームにデータを追加。アップロードするファイル名は写真を保存したパスと同じ
    curl_formadd(&formpost,
                 &lastptr,
                 CURLFORM_COPYNAME, "file_upload",
                 CURLFORM_FILE, "/usr/local/apache2/htdocs/images2/now.jpg",
                 CURLFORM_END);

    // idとapitokenをハードコード
    curl_formadd(&formpost,
                 &lastptr,
                 CURLFORM_COPYNAME, "id",
                 CURLFORM_COPYCONTENTS, "1000102",
                 CURLFORM_END);

    curl_formadd(&formpost,
                 &lastptr,
                 CURLFORM_COPYNAME, "apitoken",
                 CURLFORM_COPYCONTENTS, "1000102",
                 CURLFORM_END);

    curl = curl_easy_init();
    headerlist = curl_slist_append(headerlist, buf);
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, "http://iptarget/cloudapp/upload.php");
        curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);

        res = curl_easy_perform(curl);

        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n",
                    curl_easy_strerror(res));

        curl_easy_cleanup(curl);

        curl_formfree(formpost);

        curl_slist_free_all (headerlist);
    }

    return 0;
}


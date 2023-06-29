#include <stdio.h>
#include <curl/curl.h>

#define REMOTE_URL "http://192.168.100.101/downloads/updatefile.zip"
#define LOCAL_PATH "/usr/local/apache2/downloads/updatefile.zip"

int main() {
    CURL *curl;
    CURLcode res;
    FILE *fp;

    printf("Content-type: text/plain\n\n");
    
    curl_global_init(CURL_GLOBAL_DEFAULT);
    curl = curl_easy_init();
    if(curl) {
        fp = fopen(LOCAL_PATH, "wb");
        if(fp == NULL) {
            printf("Error opening file for writing: %s\n", LOCAL_PATH);
            return 1;
        }

        curl_easy_setopt(curl, CURLOPT_URL, REMOTE_URL);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);
        curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1L);

        // Disable SSL certificate verification
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L);
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 0L);

        res = curl_easy_perform(curl);
        if(res != CURLE_OK) {
            printf("Download failed: %s\n", curl_easy_strerror(res));
        } else {
            printf("Download succeeded!\n");
        }

        curl_easy_cleanup(curl);
        fclose(fp);
    }

    curl_global_cleanup();

    return 0;
}

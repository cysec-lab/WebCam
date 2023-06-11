#include <stdio.h>
#include <stdlib.h>
#include <curl/curl.h>

int main() {
    //CURL *curl;
    //CURLcode res;

    system("raspistill -o /usr/local/apache2/htdocs/images/now.jpg -t 100");

    /*
    struct curl_httppost *formpost=NULL;
    struct curl_httppost *lastptr=NULL;
    struct curl_slist *headerlist=NULL;

    curl_global_init(CURL_GLOBAL_ALL);

    curl_formadd(&formpost,
                 &lastptr,
                 CURLFORM_COPYNAME, "id",
                 CURLFORM_COPYCONTENTS, "1",
                 CURLFORM_END);

    curl_formadd(&formpost,
                 &lastptr,
                 CURLFORM_COPYNAME, "file",
                 CURLFORM_FILE, "/usr/local/apache2/htdocs/images/now.jpg",
                 CURLFORM_END);

    curl = curl_easy_init();
    if(curl) {
        headerlist = curl_slist_append(headerlist, "Expect:");

        curl_easy_setopt(curl, CURLOPT_URL, "http://targetip/");
        curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);

        res = curl_easy_perform(curl);
        
        if(res != CURLE_OK) {
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        }

        curl_easy_cleanup(curl);
        curl_formfree(formpost);
        curl_slist_free_all (headerlist);
    }
    curl_global_cleanup();
    */

    printf("Content-type: text/plain\n\n");
    printf("Picture taken and sent.");
    return 0;
}


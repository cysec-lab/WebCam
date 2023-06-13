#include <stdio.h>
#include <curl/curl.h>

int main(void)
{
  CURL *curl;
  CURLcode res;

  struct curl_httppost *formpost=NULL;
  struct curl_httppost *lastptr=NULL;
  struct curl_slist *headerlist=NULL;
  static const char buf[] = "Expect:";

  curl_global_init(CURL_GLOBAL_ALL);

  curl_formadd(&formpost,
               &lastptr,
               CURLFORM_COPYNAME, "file_upload",
               CURLFORM_FILE, "test2.jpeg",
               CURLFORM_END);

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
    
    curl_easy_setopt(curl, CURLOPT_URL, "http://54.249.170.102/cloudapp/upload.php");
    
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

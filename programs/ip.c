#include <stdio.h>
#include <stdlib.h>

int main(void) {
    char *from_ip = getenv("REMOTE_ADDR");
    if (from_ip == NULL) {
        from_ip = "情報なし";
    }

    printf("Content-type: text/html\n\n");
    printf("%s", from_ip);

    return 0;
}

#include <stdio.h>
#include <stdlib.h>

int main() {

    printf("Content-type: text/html\n\n");
    system("raspistill -q 10 -o /usr/local/apache2/htdocs/images2/now.jpg -t 100");

    return 0;
}



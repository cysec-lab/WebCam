#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <dirent.h>
#include <unistd.h>

#define CAPTURE_COMMAND "raspistill -o %s -t 100"

int main(int argc, char **argv)
{
    time_t rawtime;
    struct tm *timeinfo;
    char filename[80];

    time(&rawtime);
    timeinfo = localtime(&rawtime);
    strftime(filename, sizeof(filename), "%Y_%m_%d_%H_%M_%S.jpg", timeinfo);

    char path[256];
    snprintf(path, sizeof(path), "/usr/local/apache2/htdocs/images/%s", filename);

    char command[512];
    snprintf(command, sizeof(command), CAPTURE_COMMAND, path);

    int result = system(command);

    if (result == 0)
    {
        printf("Content-Type: text/plain\n\n");
        printf("Image captured and saved: %s\n", path);
    }
    else
    {
        printf("Content-Type: text/plain\n\n");
        printf("Error capturing image. Error code: %d\n", result);
    }

    return 0;
}

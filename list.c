#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

int main(int argc, char **argv)
{
    DIR *dir;
    struct dirent *entry;

    dir = opendir("/usr/local/apache2/htdocs/images");
    if (dir == NULL)
    {
        printf("Content-Type: text/plain\n\n");
        printf("Error opening images directory\n");
        return 1;
    }

    printf("Content-Type: application/json\n\n");
    printf("[");

    int first = 1;
    while ((entry = readdir(dir)) != NULL)
    {
        if (entry->d_type == DT_REG)
        {
            if (!first)
            {
                printf(", ");
            }
            printf("\"%s\"", entry->d_name);
            first = 0;
        }
    }

    printf("]");

    closedir(dir);

    return 0;
}

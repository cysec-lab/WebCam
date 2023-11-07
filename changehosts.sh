#!/bin/bash

# handsoniotapp.com の IP アドレスを 192.168.11.13 に変更
sudo sed -i 's/handsoniotapp\.com 192\.168\.11\.11/handsoniotapp.com 192.168.11.13/' /etc/hosts

# example.com の IP アドレスを 192.168.11.11 に変更
sudo sed -i 's/example\.com 192\.168\.11\.13/example.com 192.168.11.11/' /etc/hosts

#dnsmasqの再起動
sudo systemctl restart dnsmasq

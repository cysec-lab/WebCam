#!/bin/bash

# handsoniotapp.com の IP アドレスを 192.168.11.13 に変更
sudo sed -i 's/handsoniotapp\.com 192\.168\.11\.13/handsoniotapp.com 192.168.11.11/' /etc/hosts

# example.com の IP アドレスを 192.168.11.11 に変更
sudo sed -i 's/example\.com 192\.168\.11\.11/example.com 192.168.11.13/' /etc/hosts

#dnsmasqの再起動
sudo systemctl restart dnsmasq

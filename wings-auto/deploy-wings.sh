#!/bin/bash

NODE_NAME=$1
PANEL_URL=$2
TOKEN=$3

curl -L https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64 -o /usr/local/bin/wings
chmod +x /usr/local/bin/wings

mkdir -p /etc/pterodactyl

curl -H "Authorization: Bearer $TOKEN"      $PANEL_URL/api/application/nodes/$NODE_NAME/configuration      -o /etc/pterodactyl/config.yml

systemctl enable wings
systemctl start wings

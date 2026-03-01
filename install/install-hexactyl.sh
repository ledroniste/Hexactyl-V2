#!/bin/bash

echo "Installing HEXACTYL..."

apt update && apt upgrade -y
apt install -y docker.io docker-compose git curl

docker-compose -f docker/docker-compose.yml up -d

echo "HEXACTYL deployed at http://SERVER-IP:8080"

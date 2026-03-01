#!/bin/bash

# Empêcher les fenêtres interactives (comme sur ton image)
export DEBIAN_FRONTEND=noninteractive

echo "--------------------------------------------------"
echo " Installation Automatisée de HEXACTYL-V2 "
echo "--------------------------------------------------"

# 1. Installation des dépendances (Bash, Curl, UFW, Sudo, etc.)
# Le paramètre -y et l'option oDpkg forcent la mise à jour sans questions
apt-get update
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get install -y bash curl ufw sudo git docker.io docker-compose-plugin

# 2. Configuration Sécurité (UFW)
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8080/tcp
ufw --force enable

# 3. Récupération du dépôt ledroniste/Hexactyl-V2
cd /root
rm -rf Hexactyl-V2
git clone https://github.com/ledroniste/Hexactyl-V2.git
cd Hexactyl-V2

# 4. Configuration Environnement
cp .env.example .env 
IP_PUBLIC=$(curl -s ifconfig.me)
# Configuration de l'URL pour le côté Client/Admin
sed -i "s|APP_URL=http://localhost|APP_URL=http://$IP_PUBLIC:8080|g" .env 

# 5. Lancement des services (Panel + DB + Redis)
# Utilisation du docker-compose que tu as fourni 
docker compose -f docker/docker-compose.yml up -d 

echo "--------------------------------------------------"
echo " INSTALLATION TERMINÉE !"
echo " Panel Client & Admin : http://$IP_PUBLIC:8080"
echo "--------------------------------------------------"

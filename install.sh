#!/bin/bash

# ================================================================= #
#  HEXACTYL-V2 AUTO-INSTALLER                                       #
#  Compatible avec: Debian 12 (Recommandé)                          #
#  Fonctionnalités: Client Shop, Admin Panel, Crédits, Eggs         #
# ================================================================= #

set -e

echo "--------------------------------------------------"
echo " Installation de HEXACTYL-V2 (Base Pterodactyl) "
echo "--------------------------------------------------"

# 1. Installation des dépendances demandées
echo "[1/5] Installation de bash, curl, ufw, sudo, git..."
apt update && apt upgrade -y
apt install -y bash curl ufw sudo git docker.io docker-compose

# 2. Configuration du Pare-feu (UFW)
echo "[2/5] Sécurisation du serveur avec UFW..."
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 8080/tcp  # Panel Port
ufw allow 2022/tcp  # SFTP Wings
ufw --force enable

# 3. Récupération du projet depuis ton GitHub
echo "[3/5] Clonage du dépôt ledroniste/Hexactyl-V2..."
cd /root
if [ -d "Hexactyl-V2" ]; then
    rm -rf Hexactyl-V2
fi
git clone https://github.com/ledroniste/Hexactyl-V2.git
cd Hexactyl-V2

# 4. Configuration de l'environnement (.env)
echo "[4/5] Configuration des variables d'environnement..."
if [ -f ".env.example" ]; then
    cp .env.example .env
    # Détection automatique de l'IP publique
    IP_PUBLIC=$(curl -s ifconfig.me)
    sed -i "s|APP_URL=http://localhost|APP_URL=http://$IP_PUBLIC:8080|g" .env
    echo "URL configurée : http://$IP_PUBLIC:8080"
else
    echo "Erreur : .env.example introuvable dans le dépôt."
    exit 1
fi

# 5. Lancement des conteneurs (Panel, DB, Redis)
echo "[5/5] Déploiement de Docker-Compose..."
# Utilisation du fichier docker-compose fourni dans ton zip
docker-compose -f docker/docker-compose.yml up -d

echo "--------------------------------------------------"
echo " INSTALLATION TERMINÉE AVEC SUCCÈS ! "
echo "--------------------------------------------------"
echo " Accès Client & Admin : http://$IP_PUBLIC:8080"
echo " Configuration des Wings : ./wings-auto/deploy-wings.sh" 
echo "--------------------------------------------------"
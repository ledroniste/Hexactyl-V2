#!/bin/bash
# Installation Automatisée Hexactyl-V2 par Ledroniste

echo "--- [1/4] Installation des dépendances système ---"
apt update && apt upgrade -y
apt install -y bash curl ufw sudo git docker.io docker-compose

echo "--- [2/4] Sécurisation du serveur (UFW) ---"
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8080/tcp
ufw allow 2022/tcp
ufw --force enable

echo "--- [3/4] Configuration de l'environnement ---"
# Téléchargement des fichiers depuis ton nouveau repo
REPO_URL="https://raw.githubusercontent.com/ledroniste/Hexactyl-V2/main"
curl -sSL "$REPO_URL/docker/docker-compose.yml" -o docker-compose.yml
curl -sSL "$REPO_URL/.env.example" -o .env

# Génération automatique d'un mot de passe pour la DB
sed -i "s/strongpassword/$(openssl rand -hex 16)/g" .env

echo "--- [4/4] Lancement de Hexactyl (Client & Admin) ---"
docker-compose up -d

echo "--------------------------------------------------"
echo "INSTALLATION TERMINÉE !"
echo "Panel Client/Admin : http://$(curl -s ifconfig.me):8080"
echo "Identifiants par défaut : Voir ton fichier .env"
echo "--------------------------------------------------"

#!/bin/bash

# Vérification des privilèges
if [[ $EUID -ne 0 ]]; then echo "Ce script doit être lancé en root" ; exit 1 ; fi

echo "--- Installation automatisée de Hexactyl-V2 ---"

# 1. Mise à jour et dépendances
apt update && apt upgrade -y
apt install -y docker.io docker-compose ufw curl sudo git

# 2. Sécurisation avec UFW
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8080/tcp
ufw --force enable

# 3. Génération automatique du fichier .env
# Au lieu de laisser l'utilisateur le faire, on le génère automatiquement
cat <<EOF > .env
APP_NAME=Hexactyl
APP_ENV=production
APP_URL=http://$(hostname -I | awk '{print $1}')
DB_HOST=mariadb
DB_PORT=3306
DB_DATABASE=hexactyl
DB_USERNAME=hexactyl
DB_PASSWORD=$(openssl rand -base64 16)
EOF

# 4. Lancement
docker-compose -f docker/docker-compose.yml up -d

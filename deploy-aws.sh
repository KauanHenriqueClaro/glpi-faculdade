#!/bin/bash
# Instala o GLPI no AWS Lightsail (Ubuntu 24.04)
# Uso: bash deploy-aws.sh
set -e

echo "=== Atualizando sistema ==="
sudo apt update && sudo apt upgrade -y

echo "=== Instalando Docker ==="
sudo apt install -y docker.io docker-compose-v2
sudo usermod -aG docker "$USER"
sudo systemctl enable --now docker

echo "=== Baixando projeto do GitHub ==="
mkdir -p ~/glpi && cd ~/glpi
git clone https://github.com/KauanHenriqueClaro/glpi-faculdade.git . || true

echo "=== Criando .env ==="
if [ ! -f .env ]; then
  PASS=$(openssl rand -hex 16)
  printf 'GLPI_DB_NAME=glpi\nGLPI_DB_USER=glpi\nGLPI_DB_PASSWORD=%s\n' "$PASS" > .env
  echo "Senha do banco gerada: $PASS  (tambem esta no arquivo .env)"
else
  echo ".env ja existe, mantendo."
fi

echo "=== Subindo containers ==="
docker compose up -d
sleep 10

echo "=== Status ==="
docker compose ps
IP=$(curl -s ifconfig.me)
echo "GLPI disponivel em: http://${IP}:8080"
echo "NAO ESQUECA: liberar a porta 8080 no firewall do Lightsail (Networking > IPv4 Firewall)."

#!/bin/bash
# Inicializa el clúster Docker Swarm en el nodo manager.
# Uso: ./init-swarm.sh [IP_PRIVADA_DEL_MANAGER]
set -e
IP=${1:-$(hostname -I | awk '{print $1}')}
docker swarm init --advertise-addr "$IP"
echo "--- Comando para unir un WORKER ---"
docker swarm join-token worker
echo "--- Comando para unir otro MANAGER ---"
docker swarm join-token manager

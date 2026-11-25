#!/bin/bash
# Cambia el número de réplicas de un servicio.
# Uso: ./scale.sh ms-cursos 4
set -e
docker service scale "aulanube_$1=$2"
docker service ls

#!/bin/bash
# Despliega (o actualiza) el stack AulaNube en el clúster.
set -e
docker stack deploy -c docker-compose.yml aulanube --with-registry-auth
docker stack services aulanube

# AulaNube - Infraestructura (Docker Swarm)

Despliegue de los microservicios de AulaNube en un clúster Docker Swarm sobre AWS (EC2).

## Contenido
- `docker-compose.yml`: stack con los servicios y la red overlay.
  - `ms-cursos` (puerto 8082) y su base MariaDB `db-cursos`.
  - `ms-productos` (puerto 8081) y su base MySQL `db-productos`.
- `scripts/init-swarm.sh`: inicializa el clúster en el nodo manager.
- `scripts/deploy.sh`: despliega o actualiza el stack.
- `scripts/scale.sh`: cambia el número de réplicas de un servicio.

## Requisitos
- Docker instalado en cada nodo.
- Puertos abiertos entre nodos: 2377/tcp (gestión), 7946/tcp y udp (descubrimiento), 4789/udp (red overlay).
- Puertos 8081 y 8082 accesibles para consumir los servicios.
- Las imágenes deben estar publicadas en Docker Hub para que los workers puedan descargarlas.

## 1. Inicializar el nodo manager
    chmod +x scripts/*.sh
    ./scripts/init-swarm.sh <IP_PRIVADA_DEL_MANAGER>

El script muestra los comandos para unir workers y managers.

## 2. Añadir un nodo worker
En la máquina del worker, ejecutar el comando entregado por el manager:

    docker swarm join --token <TOKEN_WORKER> <IP_PRIVADA_MANAGER>:2377

## 3. Añadir otro nodo manager
En el manager actual, obtener el token:

    docker swarm join-token manager

Y ejecutar en el nuevo nodo:

    docker swarm join --token <TOKEN_MANAGER> <IP_PRIVADA_MANAGER>:2377

## 4. Verificar los nodos
En un manager:

    docker node ls

## 5. Desplegar los servicios
    ./scripts/deploy.sh
    docker stack services aulanube
    docker service ps aulanube_ms-cursos

## 6. Escalar un servicio
    ./scripts/scale.sh ms-cursos 4
    ./scripts/scale.sh ms-productos 3

## 7. Eliminar el stack
    docker stack rm aulanube

## Notas de diseño
- Las bases de datos quedan fijadas al nodo manager con una restricción de ubicación y usan volúmenes para no perder datos.
- Los microservicios tienen política de reinicio `on-failure`: si arrancan antes que su base de datos, Swarm los reinicia hasta que conecten.
- Cada microservicio tiene su propia base de datos (una por dominio).
- No publicar los tokens de unión del clúster. Se pueden regenerar con `docker swarm join-token --rotate worker`.

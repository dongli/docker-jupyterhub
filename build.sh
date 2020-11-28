#!/bin/bash

password=admin@2020

docker build -t tljh-systemd .

if ! docker top tljh-dev &> /dev/null; then
  docker stop tljh-dev
  docker rm tljh-dev
fi

docker run \
  --privileged \
  --detach \
  --name=tljh-dev \
  --publish 12000:80 \
  --mount type=bind,source=$(pwd)/the-littlest-jupyterhub,target=/srv/src \
  tljh-systemd

docker exec -it tljh-dev python3 /srv/src/bootstrap/bootstrap.py --admin admin:${password}
docker exec -it tljh-dev tljh-config set user_environment.default_app jupyterlab
docker exec -it tljh-dev sed -i 's@# HOME=/home@HOME=/srv/data@' /etc/default/useradd
docker commit tljh-dev dongli/jupyterhub:1.0

docker stop tljh-dev
docker rm tljh-dev

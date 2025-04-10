#!/usr/bin/env bash

set -e

mkdir docker
mkdir grafana
mkdir influx

goDocker(){ cd ./docker }
goHome(){ cd./ }
patching(){
  apt-get update -y;
  DEBIAN_FRONTEND=noninteractive apt install git -y;
  DEBIAN_FRONTEND=noninteractive apt install curl -y;
  DEBIAN_FRONTEND=noninteractive apt install apt-transport-https -y;
  DEBIAN_FRONTEND=noninteractive apt install pwgen -y;
}

#SETUP
patching;
git clone https://github.com/docker/docker-install.git --depth 1 --branch=master ./docker
#DOWNLOAD AND INSTALL DOCKER
goDocker;
curl -fsSL https://get.docker.com -o get-docker.sh
sh install.sh
#DOCKER COMPOSE
goHome;
docker compose -f ./docker-compose.yaml up -d
#SHOW IP
ipaddr=$(ip addr show | grep -E '^\s*inet' | grep -m1 global | awk '{ print $2 }' | sed 's|/.*||')
echo "Actual IP: "$ipaddr

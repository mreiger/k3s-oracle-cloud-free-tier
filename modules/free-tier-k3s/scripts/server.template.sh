#!/bin/bash
set -x

# yum update -y oracle-cloud-agent
# systemctl disable firewalld --now
apt-get update && apt-get -y install netcat-openbsd

iptables -w 60 -A INPUT -i ens3 -p tcp  --dport 6443 -j DROP
iptables -w 60 -I INPUT -i ens3 -p tcp -s 10.0.0.0/8  --dport 6443 -j ACCEPT

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" K3S_CLUSTER_SECRET='${cluster_token}' sh -s - server --tls-san="k3s.local"

while ! nc -z localhost 6443; do
  sleep 1
done

mkdir /home/ubuntu/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
sed -i "s/127.0.0.1/$(curl -s ifconfig.co)/g" /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/ -R

iptables -w 60 -D INPUT -i ens3 -p tcp --dport 6443 -j DROP
iptables -w 60 -I INPUT -i ens3 -p tcp --dport 6443 -j ACCEPT

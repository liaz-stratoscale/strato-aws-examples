#!/usr/bin/env bash

sudo yum update -y
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion httpd-tools
sudo yum-config-manager --enable rhui-REGION-rhel-server-extras
sudo yum install -y NetworkManager
sudo systemctl restart dbus
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo yum install -y docker

sudo bash -c 'cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=/dev/xvdf
VG=docker-vg
EOF'
sudo docker-storage-setup

##Prevent reverse DNS lookup which slows down ssh
sudo sed -i 's/#UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config

sudo systemctl stop docker
sudo systemctl enable docker
sudo rm -rf /var/lib/docker/*
sudo systemctl restart docker

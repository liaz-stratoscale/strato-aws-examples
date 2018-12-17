#!/usr/bin/env bash

sudo yum update -y
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y "@Development Tools" python2-pip openssl-devel python-devel gcc libffi-devel git tmux
mkdir -p /home/centos/openshift_ansible_3_11
git clone -b release-3.11 https://github.com/openshift/openshift-ansible /home/centos/openshift_ansible_3_11
sudo yum install -y ansible

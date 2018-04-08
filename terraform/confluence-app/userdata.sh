#! /bin/bash -v

sudo /sbin/ifconfig eth0 mtu 1416
sudo systemctl start webserver.service
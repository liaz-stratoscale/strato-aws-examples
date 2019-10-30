#!/bin/bash

export HASH=270933fd9b89267d7923f0747eb2e839cbd39337  # 6.7.0

yum upgrade -y
yum install -y
yum install epel-release -y
yum install python-pip -y
pip install python-logstash -y

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y
yum install docker-ce -y
usermod -aG docker $(whoami)
systemctl enable docker.service
systemctl start docker.service

yum install docker-compose -y

pip uninstall urllib3 -y
pip install urllib3==1.22 -y

yum install wget -y
yum install unzip -y

wget https://github.com/deviantony/docker-elk/archive/$HASH.zip
unzip $HASH.zip
cd docker-elk-$HASH/

printf 'input {
	tcp {
                port => 5000
		codec => json
        }
}

filter {
        if [type] == "json" {

                json {
                        source => "message"
                }

                if "_jsonparsefailure" in [tags] {
                        drop {}
                }
        }
}

output {
	elasticsearch {
		hosts => "elasticsearch:9200"
	}
}
' > logstash/pipeline/logstash.conf

docker-compose up -d

#

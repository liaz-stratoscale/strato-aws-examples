aws_ami = "ami-104e6c103c444b9fa1e756a033b05a60"
symphony_ip = "10.16.145.226"
# Amazon AWS Access Key
aws_access_key = "c6d0c18137974f529db396d458c5c332"
# Amazon AWS Secret Key
aws_secret_key = "5f0a0578d29a4d759a515e6edc8dd6da"


# Admin password to access Rancher
admin_password = "admin"
# Resources will be prefixed with this to avoid clashing names
prefix = "mycluster"
# Name of custom cluster that will be created
cluster_name = "quickstart"
# rancher/rancher image tag to use
rancher_version = "latest"
# Count of agent nodes with role all
count_worker_nodes = "2"
# Count of agent nodes with role etcd
# Docker version of host running `rancher/rancher`
docker_version_server = "18.09"
# Docker version of host being added to a cluster (running `rancher/rancher-agent`)
docker_version_agent = "18.09"
# AWS Instance Type
type = "t3.large"

public_keypair_path = "~/work/sandbox/keypairs/liaz_prv.pub"

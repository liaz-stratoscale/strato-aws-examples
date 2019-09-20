# Sample tfvars file 
# Stratoscale Symphony credentials

run_on_aws = false

# STRATOSCALE
symphony_ip = "10.16.146.31"
access_key = "<>"
secret_key = "<>"
web_ami = "ami-7e2117b28bb3437898834e3dc3d086b9"

# AWS
# access_key = "<>"
# secret_key = "<>"
# web_ami = "ami-04763b3055de4860b"

# Number of web servers (Load balancer will automatically manage target groups)
web_number = "2"

# Use Public Xenial cloud image ami
# Recommend use of Xenial's latest cloud image
# located here: https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
web_instance_type = "t2.medium"
public_keypair_path = "/Users/liaz/work/sandbox/keypairs/liaz_prv.pub"

#Database Information (wordpress containe will use wordpress database by default)

db_user = "admin"
db_password = "Stratoscale!Orchestration!"





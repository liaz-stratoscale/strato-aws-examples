# .tfvars Sample File

# Region Credentials
symphony_ip = "10.16.146.106"
access_key = "eba0f36b44d14c44b3615aa77728c7f2"
secret_key = "e8f0e323057d4f648fd1f83e64ea53d4"

# Number of web servers (Load balancer will automatically manage target groups)
web_number = "2"

# Use Public Xenial cloud image ami
# Recommend use of Xenial's latest cloud image
# located here: https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
web_ami = "ami-288ba42e7c9247ca9cd60052c48681c1"
web_instance_type = "t2.medium"
public_keypair_path = "/Users/liaz/work/sandbox/keypairs/liaz_prv.pub"

#Database Information (wordpress containe will use wordpress database by default)

db_user = "admin"
db_password = "Stratoscale!Orchestration!"





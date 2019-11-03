# Sample tfvars file 
# Stratoscale Symphony credentials

symphony_ip = "<region ip>"
access_key = "<access key>"
secret_key = "<secret key>"

# Use Public Centos cloud image ami
# Recommend use of Centos's latest cloud image
# located here: https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
elk_ami = "<image ID>"
elk_instance_type = "t2.large"
public_keypair_path = "<path to public key pair"

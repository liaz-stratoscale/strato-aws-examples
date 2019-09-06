# .tfvars Sample File

# Region Credentials
symphony_ip = "<region ip>"
access_key = "<access key>"
secret_key = "<secret key>"

# Recommend use of Centos latest cloud image
# located here: https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2

ami_spark_node = "<image ID>"
public_keypair_path = "<path to public key pair>"

# optional
spark_workers_number = 2
# spark_workers_type = <number of instances>
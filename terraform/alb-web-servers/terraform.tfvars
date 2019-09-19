# .tfvars Sample File

run_on_aws = false

# Region Credentials
# SYMP
symphony_ip = "demo7.stratoscale.com"
access_key = "d10c3c134898416b81ec3240a2a413ce"
secret_key = "52aba4ab4aaf465eabbf55a3ef28705b"

# AWS
//access_key = "<>"
//secret_key = "<>"

# Recommend use of Xenial's latest cloud image
# located here: https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img 
# SYMP
ami_webserver = "ami-011c0f5f8bff4c52a3cc4f6789853bd0"

# AWS
# ami_webserver = "ami-04763b3055de4860b"

# optional
# web_servers_type = "<instance-type>"
# web_servers_number = <number of instances>


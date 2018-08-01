# .tfvars Sample File
# Remember to omit the .sample from the extension prior to running Terraform


# Region Credentials
symphony_ip = "demo4.stratoscale.com"
access_key = "e5d245b16c924750b2c8bfcc648a693f"
secret_key = "0233b68c8ef04e0aad2ff9a335bcb15f"

# Reccomend for you to use Xenial's latest cloud image
# located here: https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img 

#demo4 xenial

ami_webserver = "ami-f8d581e6cf6448258ce1253de50cfc3a"



# optional
# instance_type = "<instance-type>"
# instance_number = <number of instances>
# .tfvars Sample File

# Region Credentials
symphony_ip = "10.16.146.100"
access_key = "22b4526aa75e40a29fdfa7f2267c2148"
secret_key = "7a3d5189fbb64dd6b48e96b2a7b21abf"

# Recommend use of Xenial's latest cloud image
# located here: https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img 
ami_image = "ami-24f246d54d1d405ab640c16d238269a4"

# optional
instance_type = "t2.medium"
instance_number = 2


kp_public_path = "/Users/liaz/work/sandbox/keypairs/liaz_prv.pub"

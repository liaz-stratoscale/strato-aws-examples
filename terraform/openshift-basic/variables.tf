##
## Access
##
variable "symphony_ip" {}
variable "secret_key" {}
variable "access_key" {}

##
## Region
##
variable "aws_region" {
  default     = "us-west-1"
}

##
## AMI
##
variable "aws_ami" {}



##
## Key pairs
##
variable "bastion_key_path" {
  description = "My public ssh key"
}
variable "openshift_key_path" {
  description = "My public ssh key"
}
variable "bastion_key_name" {
  description = "Desired name of AWS key pair"
  default     = "bastion"
}
variable "openshift_key_name" {
  description = "Desired name of AWS key pair"
  default     = "openshift"
}


##
## VPC
##
variable "vpc_cidr" {
    default = "20.0.0.0/16"
  description = "the vpc cdir range"
}

##
## Subnets
##
variable "public_subnet" {
  default = "20.0.0.0/24"
  description = "Public subnet"
}

##
## DNS
##
variable "dns_domain_name" {}
variable "dns_servers" {}
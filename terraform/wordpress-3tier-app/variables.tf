variable "secret_key" {
}

variable "access_key" {
}

variable "symphony_ip" {
  default = null
}

variable "region" {
  default = "us-east-1"
}

variable "web_number" {
}

variable "web_ami" {
}

variable "web_instance_type" {
}

variable "public_keypair_path" {
}

variable "db_password" {
}

variable "db_user" {
}

variable "run_on_aws" {
  default = false
  type = bool
}


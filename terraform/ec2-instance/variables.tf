# Region Credentials
variable "symphony_ip" {
  default = null
}
variable "secret_key" {}
variable "access_key" {}
variable "ami_image" {}
variable "instance_number" {
  default = 1
}
variable "instance_type" {
  default = "t2.micro"
}

variable "run_on_aws" {
  default = false
  type = bool
}


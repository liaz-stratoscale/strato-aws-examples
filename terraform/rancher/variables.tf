variable "aws_ami" {
  default     = "xxx"
  # https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
  description = "ami of Ubuntu Cloud image"
}

variable "aws_access_key" {
  default     = "xxx"
  description = "Amazon AWS Access Key"
}

variable "aws_secret_key" {
  default     = "xxx"
  description = "Amazon AWS Secret Key"
}

variable "symphony_ip" {
  default     = "xxx"
}

variable "rancher_version" {
  default     = "latest"
  description = "Rancher Server Version"
}

variable "prefix" {
  default     = "yourname"
  description = "Cluster Prefix - All resources created by Terraform have this prefix prepended to them"
}

variable "count_worker_nodes" {
  default     = "1"
  description = "Number of Rancher Nodes"
}

variable "admin_password" {
  default     = "admin"
  description = "Password to set for the admin account in Rancher"
}

variable "cluster_name" {
  default     = "quickstart"
  description = "Kubernetes Cluster Name"
}

variable "type" {
  default     = "t3.medium"
  description = "Amazon AWS Instance Type"
}

variable "docker_version_server" {
  default     = "18.09"
  description = "Docker Version to run on Rancher Server"
}

variable "docker_version_agent" {
  default     = "18.09"
  description = "Docker Version to run on Kubernetes Nodes"
}

variable "public_keypair_path" {
  description = "Path to SSH public key pair"
}

variable "rancher_k8s_versions" {
  default = "1.14.9 1.15.6 1.16.3"
}
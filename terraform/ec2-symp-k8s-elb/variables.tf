variable "secret_key" {}
variable "access_key" {}
variable "symphony_ip" {}

variable "symp_domain" {}
variable "symp_user" {}
variable "symp_password" {}
variable "symp_project" {
  description = "Project Name"
}

# Kubernetes cluster variables
variable "k8s_name" {
  description = "Kubernetres cluster name. Must be unique in this project"
}
variable "k8s_eng" {
  description = "Kubernetes engine version"
  default = "1.11"
}
variable "k8s_size" {
  description = "Size of data disk of each node"
  default = "50"
}
variable "k8s_count" {
  description = "Initial cluster node count"
  default = "2"
}
variable "k8s_type" {
  description = "Instance type of each node"
  default = "t2.large"
}
# Kubernetes cluster variables
variable "k8s_configfile_path" {
  description = "Path to place the Kubernetes config file"
  default = "~/.kube/config"
}

# EFS EIP - Required due to Terraform bug DBAAS-2121
variable "pv_efs_eip" {
  description = "EIP of EFS required for NFS PV"
}

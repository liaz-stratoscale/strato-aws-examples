variable "k8s_cluster_dependency_id" {
  description = "Here you pass the computed ID of the K8S cluster. Make sure it starts after k8s cluster is created."
}

variable "k8s_cluster_eip_id" {
  description = "Here you pass the computed EIP ID of the K8S cluster. Make sure EIP is up while the APP uses it."
}

variable "k8s_configfile_path" {
  default = "~/.kube/config"
}

variable "pv_efs_ip" {
  description = "IP of EFS required for NFS PV"
}

# Wordpress variables
variable "db_host" {
  description = "IP address for the DB"
}

variable "db_name" {
  description = "Name for the DB"
}

variable "db_user" {
  description = "Username for the DB"
}

variable "db_password" {
  description = "Password for the DB"
}




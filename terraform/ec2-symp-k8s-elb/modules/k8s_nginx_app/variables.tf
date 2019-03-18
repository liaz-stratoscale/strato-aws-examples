variable "k8s_cluster_dependency_id" {
  description = "Here you pass the computed ID of the K8S cluster. Make sure pp starts after k8s cluster is created."
}

variable "k8s_cluster_eip_id" {
  description = "Here you pass the computed EIP ID of the K8S cluster. Make sure EIP is up while the APP uses it."
}

variable "k8s_configfile_path" {
  default = "/Users/liaz/.kube/config"
}

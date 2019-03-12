variable "k8s_cluster_dependency_id" {
  description = "Here you pass the computed ID of the K8S cluster. Make sure pp starts after k8s cluster is created."
}

variable "k8s_configfile_path" {
  default = "/Users/liaz/.kube/config"
}

# we must use the whole result returned from k8s_info due to this bug:
# https://github.com/hashicorp/terraform/issues/11806

output "k8s_nodes_ids" {
  value = "${formatlist("i-%s",split(",",replace(lookup(data.external.k8s_info.result,"nodes_id"), "-" , "" )))}"
}

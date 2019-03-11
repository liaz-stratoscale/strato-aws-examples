output "lb_eip" {
  value = "${aws_alb.alb.dns_name}:${aws_alb_listener.list.port}"
}

output "k8s_nodes" {
  value = "${module.my_k8s.k8s_nodes_ids}"
}

module "k8s_grafana" {
  source = "./modules/k8s_grafana"

  k8s_cluster_dependency_id = "${module.my_k8s.k8s_cluster_id}"
  k8s_cluster_eip_id = "${aws_eip.k8s_eip.id}"
  k8s_configfile_path = "${var.k8s_configfile_path}"

  pv_efs_ip = "${var.pv_efs_eip}"
}

resource "aws_alb_target_group" "grafana_targ" {
  port = "${module.k8s_grafana.service_out_port}"
  protocol = "HTTP"
  vpc_id = "${aws_vpc.app_vpc.id}"
}

resource "aws_alb_target_group_attachment" "grafana_attach_web_servers" {
  target_group_arn = "${aws_alb_target_group.grafana_targ.arn}"
  target_id       = "${element(module.my_k8s.k8s_nodes_ids,count.index)}"
  count = "${var.k8s_count}"
}

resource "aws_alb_listener" "grafana_list" {
  "default_action" {
    target_group_arn = "${aws_alb_target_group.grafana_targ.arn}"
    type = "forward"
  }
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = 3000
}
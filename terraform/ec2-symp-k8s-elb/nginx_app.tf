module "nginx_app" {
  source = "./modules/k8s_nginx_app"

  k8s_cluster_dependency_id = "${module.my_k8s.k8s_cluster_id}"
  k8s_cluster_eip_id = "${aws_eip.k8s_eip.id}"
  k8s_configfile_path = "${var.k8s_configfile_path}"
}

resource "aws_alb_target_group" "targ" {
  port = "${module.nginx_app.service_out_port}"
  protocol = "HTTP"
  vpc_id = "${aws_vpc.app_vpc.id}"
}

resource "aws_alb_target_group_attachment" "attach_web_servers" {
  target_group_arn = "${aws_alb_target_group.targ.arn}"
  target_id       = "${element(module.my_k8s.k8s_nodes_ids,count.index)}"
  count = "${var.k8s_count}"
}

resource "aws_alb_listener" "list" {
  "default_action" {
    target_group_arn = "${aws_alb_target_group.targ.arn}"
    type = "forward"
  }
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = 80
}
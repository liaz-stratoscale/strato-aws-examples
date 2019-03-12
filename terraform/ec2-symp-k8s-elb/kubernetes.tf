module "my_k8s" {
  source = "./modules/symp_k8s"

  symp_domain = "${var.symp_domain}"
  symp_host = "${var.symphony_ip}"
  symp_password = "${var.symp_password}"
  symp_project = "${var.symp_project}"
  symp_user = "${var.symp_user}"
  k8s_name = "${var.k8s_name}"
  k8s_subnet = "${aws_subnet.pub_subnet.id}"
  k8s_eip = "${aws_eip.k8s_eip.id}"
  k8s_configfile_path = "${var.k8s_configfile_path}"
}

resource "aws_eip" "k8s_eip" {
  vpc = true
}

module "nginx_app" {
  source = "./modules/k8s_nginx_app"

  k8s_cluster_dependency_id = "${module.my_k8s.k8s_cluster_id}"
  k8s_configfile_path = "${var.k8s_configfile_path}"
}

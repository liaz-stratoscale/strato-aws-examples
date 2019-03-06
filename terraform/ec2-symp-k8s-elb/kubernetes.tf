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
}

resource "aws_eip" "k8s_eip" {
  vpc = true
}

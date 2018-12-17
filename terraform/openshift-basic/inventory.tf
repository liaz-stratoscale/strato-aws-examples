data "template_file" "inventory" {
  template = "${file("${path.cwd}/inventory-template.txt")}"
  vars {
    #public_subdomain = "${aws_lb.infra_alb.dns_name}"
    #admin_hostname = "${aws_lb.master_alb.dns_name}"
    public_subdomain = "${aws_eip.master_eip.public_ip}"
    admin_hostname = "${aws_eip.master_eip.public_ip}"
    master_hostname = "${aws_instance.master.private_dns}"
    infra_hostname = "${aws_instance.infra.private_dns}"
    worker_hostname = "${aws_instance.worker.private_dns}"
  }
}
resource "local_file" "inventory" {
  content     = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/ansible-hosts"
}
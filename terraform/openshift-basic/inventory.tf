data "template_file" "inventory" {
  template = "${file("${path.cwd}/inventory-template.txt")}"
  vars {
    public_subdomain = "apps.${aws_eip.infra_eip.public_ip}.xip.io"
    admin_hostname = "console.${aws_eip.master_eip.public_ip}.xip.io"
    master_hostname = "${aws_instance.master.private_dns}"
    infra_hostname = "${aws_instance.infra.private_dns}"
    worker_hostname = "${aws_instance.worker.private_dns}"
  }
}
resource "local_file" "inventory" {
  content     = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/ansible-hosts"
}
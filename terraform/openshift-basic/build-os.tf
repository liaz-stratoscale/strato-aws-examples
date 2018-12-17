data "template_file" "build-os" {
  template = "${file("${path.cwd}/build-os-template.txt")}"
  vars {
    bastion_hostname = "${aws_eip.bastion_eip.public_ip}"
  }
}

resource "local_file" "build-os" {
  content     = "${data.template_file.build-os.rendered}"
  filename = "${path.cwd}/build-os.sh"
}
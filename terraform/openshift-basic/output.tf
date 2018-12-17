output "bastion_ip" {
  value = "${aws_eip.bastion_eip.public_ip}"
}

output "master_ip" {
  value = "${aws_eip.master_eip.public_ip}"
}

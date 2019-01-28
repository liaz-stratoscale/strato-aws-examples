output "bastion_ip" {
  value = "${aws_eip.bastion_eip.public_ip}"
}

output "master_ip" {
  value = "${aws_eip.master_eip.public_ip}"
}

output "infra_ip" {
  value = "${aws_eip.infra_eip.public_ip}"
}

output "worker_ip" {
  value = "${aws_eip.worker_eip.public_ip}"
}


output "console_url" {
  value = "https://console.${aws_eip.master_eip.public_ip}.xip.io:8443"
}

resource "local_file" "create_set_hostnames" {
  content = <<EOF
ssh -o StrictHostKeyChecking=no centos@${aws_eip.master_eip.public_ip} -i ${var.openshift_private_key_path} "sudo hostnamectl set-hostname ${aws_instance.master.private_dns}"
ssh -o StrictHostKeyChecking=no centos@${aws_eip.worker_eip.public_ip} -i ${var.openshift_private_key_path} "sudo hostnamectl set-hostname ${aws_instance.worker.private_dns}"
ssh -o StrictHostKeyChecking=no centos@${aws_eip.infra_eip.public_ip} -i ${var.openshift_private_key_path} "sudo hostnamectl set-hostname ${aws_instance.infra.private_dns}"
EOF
  filename = "./set_hostname.sh"
}

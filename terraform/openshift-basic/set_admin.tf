resource "local_file" "create_set_admin" {
  content = <<EOF
ssh -o StrictHostKeyChecking=no centos@${aws_eip.master_eip.public_ip} -i ${var.openshift_private_key_path} "sudo htpasswd -b /etc/origin/master/htpasswd ${var.openshift_admin_username} ${var.openshift_admin_password}"
ssh -o StrictHostKeyChecking=no centos@${aws_eip.master_eip.public_ip} -i ${var.openshift_private_key_path} "oc adm policy add-cluster-role-to-user cluster-admin ${var.openshift_admin_username}"
EOF
  filename = "./set_admin.sh"
}

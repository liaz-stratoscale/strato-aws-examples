resource "aws_key_pair" "app_keypair" {
  public_key = file(pathexpand(var.public_keypair_path))
  key_name   = "${var.prefix}_rancher_kp"
}

resource "aws_security_group" "rancher_sg_allowall" {
  name = "${var.prefix}-allowall"
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
//    "Name": "Rancher SG",
    "kubernetes.io/cluster/mycluster": "owned"
  }
}

data "template_cloudinit_config" "rancherserver-cloudinit" {
  part {
    content_type = "text/cloud-config"
    content      = "hostname: ${var.prefix}-rancherserver\nmanage_etc_hosts: true"
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.userdata_server.rendered
  }
}

resource "aws_eip" "rancher_server_eip" {
  vpc = true
}

resource "aws_eip_association" "rancher_server_eip_assoc" {
  allocation_id = aws_eip.rancher_server_eip.id
  instance_id = aws_instance.rancherserver.id
}

resource "aws_instance" "rancherserver" {
  ami             = var.aws_ami
  instance_type   = var.type
  key_name        = aws_key_pair.app_keypair.key_name
  vpc_security_group_ids = [aws_security_group.rancher_sg_allowall.id]
  user_data       = data.template_cloudinit_config.rancherserver-cloudinit.rendered
  subnet_id       = aws_subnet.pub_subnet.id

  tags = {
    Name = "${var.prefix}-rancherserver"
  }
  root_block_device {
    volume_size   = 50
  }
}

########## IAM STACK ################
data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "kube-node-role" {
  name               = "${var.prefix}-rancher-kube-node-role"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "ec2-eks-cluster-policy" {
  role       = aws_iam_role.kube-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "ec2-eks-service-policy" {
  role       = aws_iam_role.kube-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_instance_profile" "test_profile" {
  name  = "${var.prefix}-rancher-kube-node-instance-profile"
  role = aws_iam_role.kube-node-role.name
}

########## ########## ################

########## Route53 stack ################
resource "aws_route53_zone" "symphon_dns_zone" {
  name = "symphon.amazonaws.com."
  vpc {
    vpc_id = aws_vpc.app_vpc.id
  }
  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_record" "ec2_symphon_dns_record" {
  zone_id = aws_route53_zone.symphon_dns_zone.zone_id
  name    = "ec2"
  type    = "A"
  ttl     = "300"
  records = [var.symphony_ip]
}

resource "aws_route53_record" "elb_symphon_dns_record" {
  zone_id = aws_route53_zone.symphon_dns_zone.zone_id
  name    = "elasticloadbalancing"
  type    = "A"
  ttl     = "300"
  records = [var.symphony_ip]
}

########## ########## ################
data "template_cloudinit_config" "rancher-node-cloudinit" {
  count = var.count_worker_nodes

  part {
    content_type = "text/cloud-config"
    content      = "hostname: ${var.prefix}-rancheragent-${count.index}-all\nmanage_etc_hosts: true"
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.userdata_agent_all.rendered
  }
}

resource "aws_eip" "agent_eip" {
  vpc             = true
  count = var.count_worker_nodes
}

resource "aws_eip_association" "agent_eip_assoc" {
  allocation_id = aws_eip.agent_eip[count.index].id
  instance_id   = aws_instance.rancher-node[count.index].id
  count = var.count_worker_nodes
}

resource "aws_instance" "rancher-node" {
  count = var.count_worker_nodes
  ami = var.aws_ami
  instance_type = var.type
  key_name = aws_key_pair.app_keypair.key_name
  vpc_security_group_ids = [aws_security_group.rancher_sg_allowall.id]
  user_data = data.template_cloudinit_config.rancher-node-cloudinit[count.index].rendered
  subnet_id = aws_subnet.pub_subnet.id
  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = "${var.prefix}-ranchernode-${count.index}-all"
    "kubernetes.io/cluster/mycluster": "owned"
  }

  depends_on = [
    aws_eip_association.rancher_server_eip_assoc]
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
}

resource "null_resource" "configure_certs" {

  depends_on = [aws_instance.rancher-node]

  provisioner "file" {
    source = "./files/certs/amazonaws.crt"
    destination = "/home/ubuntu/amazonaws.crt"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_eip.agent_eip[count.index].public_ip
    }
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-get install -y ca-certificates",
              "sudo cp /home/ubuntu/amazonaws.crt /usr/local/share/ca-certificates/amazonaws.crt",
              "sudo update-ca-certificates"]

    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_eip.agent_eip[count.index].public_ip
    }
  }
  count = var.count_worker_nodes
}

resource "null_resource" "configure_disk_mapper" {

  depends_on = [aws_instance.rancher-node]

  provisioner "file" {
    source = "./files/disk_mapper/disk_mapper.py"
    destination = "/home/ubuntu/disk_mapper.py"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_eip.agent_eip[count.index].public_ip
    }
  }

  provisioner "file" {
    source = "./files/disk_mapper/99-disk_mapper.rules"
    destination = "/home/ubuntu/99-disk_mapper.rules"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_eip.agent_eip[count.index].public_ip
    }
  }

  count = var.count_worker_nodes
}

resource "null_resource" "wait_for_cloud_init" {

  depends_on = [aws_instance.rancher-node]

  provisioner "remote-exec" {
    inline = [
      "/bin/bash -c \"timeout 1200 sed '/finished-user-data/q' <(tail -f /var/log/cloud-init-output.log)\""
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_eip.agent_eip[count.index].public_ip
    }
  }

  count = var.count_worker_nodes
}

data "template_file" "userdata_server" {
  template = file("files/cloud-init/userdata_server")

  vars = {
    admin_password        = var.admin_password
    cluster_name          = var.cluster_name
    docker_version_server = var.docker_version_server
    rancher_version       = var.rancher_version
    rancher_server_eip    = aws_eip.rancher_server_eip.public_ip
  }
}

data "template_file" "userdata_agent_all" {
  template = file("files/cloud-init/userdata_agent")

  vars = {
    admin_password       = var.admin_password
    cluster_name         = var.cluster_name
    docker_version_agent = var.docker_version_agent
    rancher_version      = var.rancher_version
    server_address       = aws_eip.rancher_server_eip.public_ip
    rancher_k8s_versions = var.rancher_k8s_versions
  }
}

output "rancher-url" {
  value = ["https://${aws_eip.rancher_server_eip.public_ip}"]
}

output "worker-eips" {
  value = zipmap(aws_instance.rancher-node[*].private_ip,aws_eip.agent_eip[*].public_ip)
}

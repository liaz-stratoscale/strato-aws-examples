##
## Key Pairs
##
resource "aws_key_pair" "bastion" {
  key_name   = "${var.bastion_key_name}"
  public_key = "${file(var.bastion_key_path)}"
}

resource "aws_key_pair" "openshift" {
  key_name   = "${var.openshift_key_name}"
  public_key = "${file(var.openshift_key_path)}"
}

##
## Instances
##

## Bastion
resource "aws_instance" "bastion" {
  ami = "${var.aws_ami}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PublicSubnet.id}"
  vpc_security_group_ids = [
    "${aws_security_group.sec_bastion.id}",
  ]
  key_name = "${aws_key_pair.bastion.id}"
  tags {
    Name = "OpenShift-Bastion"
  }
}

resource "null_resource" "init_bastion" {
  connection {
    type = "ssh"
    user = "centos"
    host = "${aws_eip.bastion_eip.public_ip}"
    private_key = "${file(var.bastion_private_key_path)}"
    agent = "false"
  }

  provisioner "remote-exec" {
    script = "./scripts/prep-bastion.sh"
  }

  provisioner "file" {
    source = "${var.openshift_private_key_path}"
    destination = "/home/centos/.ssh/${basename(var.openshift_private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 600 /home/centos/.ssh/${basename(var.openshift_private_key_path)}",
    ]
  }
}

resource "null_resource" "copy_hosts_file_to_bastion" {
  connection {
    type = "ssh"
    user = "centos"
    host = "${aws_eip.bastion_eip.public_ip}"
    private_key = "${file(var.bastion_private_key_path)}"
    agent = "false"
  }

  provisioner "file" {
    source = "${path.cwd}/ansible-hosts"
    destination = "/home/centos/ansible-hosts"
  }
}


######## Openshift
## Master
resource "aws_instance" "master" {
  ami = "${var.aws_ami}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PublicSubnet.id}"
  vpc_security_group_ids = [
    "${aws_security_group.sec_openshift.id}",
  ]
  key_name = "${aws_key_pair.openshift.id}"
  tags {
    Name = "OpenShift-Master"
  }
}

resource "null_resource" "init_master" {
  provisioner "remote-exec" {

    script = "./scripts/prep-openshift.sh"

    connection {
      type = "ssh"
      user = "centos"
      host = "${aws_eip.master_eip.public_ip}"
      private_key = "${file(var.openshift_private_key_path)}"
      agent = "false"
    }
  }
}

# Openshift node must be configured with correct hostname, else it will be exposed
# to this bug https://bugzilla.redhat.com/show_bug.cgi?id=1625911
# It comes up with bogus hostname blabla.novalocal due to JIRA ????
resource "null_resource" "set_master_hostname" {
  provisioner "remote-exec" {

    inline = [
      "sudo sh -c \"echo ${aws_instance.master.private_dns} > /etc/hostname\"",
    ]

    connection {
      type = "ssh"
      user = "centos"
      host = "${aws_eip.master_eip.public_ip}"
      private_key = "${file(var.openshift_private_key_path)}"
      agent = "false"
    }
  }
}

## Worker
resource "aws_instance" "worker" {
  ami = "${var.aws_ami}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PublicSubnet.id}"
  key_name = "${aws_key_pair.openshift.id}"
  vpc_security_group_ids = [
    "${aws_security_group.sec_openshift.id}",
  ]
  tags {
    Name = "OpenShift-Worker"
  }
}

resource "null_resource" "init_worker" {
  provisioner "remote-exec" {

    script = "./scripts/prep-openshift.sh"

    connection {
      type = "ssh"
      user = "centos"
      host = "${aws_eip.worker_eip.public_ip}"
      private_key = "${file(var.openshift_private_key_path)}"
      agent = "false"
    }
  }
}

resource "null_resource" "set_worker_hostname" {
  provisioner "remote-exec" {

    inline = [
      "sudo sh -c \"echo ${aws_instance.worker.private_dns} > /etc/hostname\"",
    ]

    connection {
      type = "ssh"
      user = "centos"
      host = "${aws_eip.worker_eip.public_ip}"
      private_key = "${file(var.openshift_private_key_path)}"
      agent = "false"
    }
  }
}

# Infra
resource "aws_instance" "infra" {
  ami = "${var.aws_ami}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PublicSubnet.id}"
  vpc_security_group_ids = [
    "${aws_security_group.sec_openshift.id}",
  ]
  key_name = "${aws_key_pair.openshift.id}"
  tags {
    Name = "OpenShift-Infra"
  }
}

resource "null_resource" "init_infra" {
  provisioner "remote-exec" {

    script = "./scripts/prep-openshift.sh"

    connection {
      type = "ssh"
      user = "centos"
      host = "${aws_eip.infra_eip.public_ip}"
      private_key = "${file(var.openshift_private_key_path)}"
      agent = "false"
    }
  }
}

resource "null_resource" "set_infra_hostname" {
  provisioner "remote-exec" {

    inline = [
      "sudo sh -c \"echo ${aws_instance.infra.private_dns} > /etc/hostname\"",
    ]

    connection {
      type = "ssh"
      user = "centos"
      host = "${aws_eip.infra_eip.public_ip}"
      private_key = "${file(var.openshift_private_key_path)}"
      agent = "false"
    }
  }
}

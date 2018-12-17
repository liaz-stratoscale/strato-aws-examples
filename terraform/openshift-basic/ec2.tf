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
  instance_type        = "t2.medium"
  subnet_id            = "${aws_subnet.PublicSubnet.id}"
  security_groups = [
    "${aws_security_group.sec_bastion.id}",
  ]
  #associate_public_ip_address = true
  key_name = "${aws_key_pair.bastion.id}"
  user_data = "${data.template_file.prep-bastion.rendered}"
  tags {
    Name = "OpenShift-Bastion"
  }
}


## Master
resource "aws_instance" "master" {
  ami = "${var.aws_ami}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PublicSubnet.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  #associate_public_ip_address = true
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.prep-openshift.rendered}"
  tags {
    Name = "OpenShift-Master"
  }
}

## Worker
resource "aws_instance" "worker" {
  ami = "${var.aws_ami}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PublicSubnet.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  #associate_public_ip_address = true
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.prep-openshift.rendered}"
  tags {
    Name = "OpenShift-Worker"
  }
}

# Infra
resource "aws_instance" "infra" {
  ami = "${var.aws_ami}"
  instance_type        = "t2.large"
  subnet_id            = "${aws_subnet.PublicSubnet.id}"
  security_groups = [
    "${aws_security_group.sec_openshift.id}",
  ]
  #associate_public_ip_address = true
  key_name = "${aws_key_pair.openshift.id}"
  user_data = "${data.template_file.prep-openshift.rendered}"
  tags {
    Name = "OpenShift-Infra"
  }
}

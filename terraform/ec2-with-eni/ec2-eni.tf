resource "aws_vpc" "test_vpc" {
  cidr_block = "172.127.0.0/16"
  enable_dns_hostnames = false
  enable_dns_support = false
}

resource "aws_internet_gateway" "myapp_gw" {
  vpc_id = "${aws_vpc.test_vpc.id}"
}

resource "aws_subnet" "test1-network" {
  availability_zone = "${var.avl_zone}"
  vpc_id     = "${aws_vpc.test_vpc.id}"
  cidr_block = "172.127.1.0/24"
  # workaround for bug NET-1113
  lifecycle {
    ignore_changes = ["availability_zone"]
  }
}

resource "aws_subnet" "test2-network" {
  availability_zone = "${var.avl_zone}"
  vpc_id     = "${aws_vpc.test_vpc.id}"
  cidr_block = "172.127.2.0/24"
  # workaround for bug NET-1113
  lifecycle {
    ignore_changes = ["availability_zone"]
  }
}

resource "aws_instance" "ec2_instance" {
  availability_zone = "${var.avl_zone}"
  ami = "${var.aws_ami}"
  instance_type = "t2.micro"
  network_interface {
    device_index = 0
    network_interface_id = "${aws_network_interface.test1.id}"
  }
  network_interface {
    device_index = 1
    network_interface_id = "${aws_network_interface.test2.id}"
  }
  tags {
    Name = "dual_nic_vm"
  }
}

resource "aws_network_interface" "test1" {
  subnet_id = "${aws_subnet.test1-network.id}"
  private_ips = ["172.127.1.101"]
}

resource "aws_network_interface" "test2" {
  subnet_id = "${aws_subnet.test2-network.id}"
  private_ips = ["172.127.2.202"]
}

resource "aws_eip" "myapp_instance_eip_test1" {
  depends_on = ["aws_internet_gateway.myapp_gw"]
  vpc = true
}

resource "aws_eip_association" "myapp_eip_assoc_test1" {
  # instance_id = "${aws_instance.ec2_instance.id}"
  allocation_id = "${aws_eip.myapp_instance_eip_test1.id}"
  network_interface_id = "${aws_network_interface.test1.id}"
}

resource "aws_eip" "myapp_instance_eip_test2" {
  depends_on = ["aws_internet_gateway.myapp_gw"]
  vpc = true
}

resource "aws_eip_association" "myapp_eip_assoc_test2" {
  # instance_id = "${aws_instance.ec2_instance.id}"
  allocation_id = "${aws_eip.myapp_instance_eip_test2.id}"
  # private_ip_address = "${aws_network_interface.test2.private_ip}"
  network_interface_id = "${aws_network_interface.test2.id}"
}

# workaround for bug NET-1112
resource "aws_route" "route_def_table_to_igw" {
  route_table_id = "${aws_vpc.test_vpc.default_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.myapp_gw.id}"
}

##
## New VPC
resource "aws_vpc" "openshift-vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
      Name = "OpenShift VPC"
    }
}

##
## DHCP options
##
resource "aws_vpc_dhcp_options" "dns_domain" {
  domain_name_servers = ["${var.dns_servers}"]
  domain_name = "${var.dns_domain_name}"
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.openshift-vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_domain.id}"
}


##
## Subnets
##
resource "aws_subnet" "PublicSubnet" {
  vpc_id = "${aws_vpc.openshift-vpc.id}"
  cidr_block = "${var.public_subnet}"
  tags {
        Name = "Public Subnet"
  }
}

##
## IGW
##
resource "aws_internet_gateway" "gw" {
   vpc_id = "${aws_vpc.openshift-vpc.id}"
    tags {
        Name = "Internet Gateway"
    }
}

##
## Route table
##
## Add route to IGW to main VPC table
resource "aws_route_table_association" "PublicSubnet" {
    subnet_id = "${aws_subnet.PublicSubnet.id}"
    route_table_id = "${aws_vpc.openshift-vpc.main_route_table_id}"
}

resource "aws_route" "PublicRoute" {
  route_table_id = "${aws_vpc.openshift-vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.gw.id}"
}

resource "aws_eip" "bastion_eip" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true
}

resource "aws_eip" "master_eip" {
  instance = "${aws_instance.master.id}"
  vpc      = true
}

resource "aws_eip" "worker_eip" {
  instance = "${aws_instance.worker.id}"
  vpc      = true
}

resource "aws_eip" "infra_eip" {
  instance = "${aws_instance.infra.id}"
  vpc      = true
}


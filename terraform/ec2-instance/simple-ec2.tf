# Create instances, and name them according to count
resource "aws_instance" "ec2_instance" {
    ami = "${var.ami_image}"

    tags{
        Name="web_server_${count.index}"
        Role="java_server"
    }
    # Can use any aws instance type supported by symphony
    key_name = "${aws_key_pair.kp_demo.key_name}"
    instance_type = "${var.instance_type}"
    count="${var.instance_number}"
}


resource "aws_eip" "demo_eip" {
    vpc = true
    count="${var.instance_number}"
}


resource "aws_eip_association" "demo_eip_assoc" {
    instance_id = "${element(aws_instance.ec2_instance.*.id, count.index)}"
    allocation_id = "${element(aws_eip.demo_eip.*.id, count.index)}"
    count="${var.instance_number}"
}


resource "aws_key_pair" "kp_demo" {
    key_name_prefix = "demo_kp_"
    public_key = "${file(var.kp_public_path)}"
}

resource "aws_default_vpc" "default" {
  tags {
    Name = "Default VPC"
  }
}

resource "aws_vpc_dhcp_options_association" "dhcp_opts_assoc_default" {
    dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
    vpc_id = "${aws_default_vpc.default.id}"
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
}

output "web-server public ips" {
  value = "${zipmap(aws_instance.ec2_instance.*.id, aws_instance.ec2_instance.*.public_ip)}"
}

resource "aws_default_security_group" "def_sec_grp" {
  vpc_id = "${aws_default_vpc.default.id}"

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instance_app" {
    ami = "${var.ami_image}"

    tags{
        Name="app_server_${count.index}"
    }
    # Can use any aws instance type supported by symphony
    key_name = "${aws_key_pair.kp_demo.key_name}"
    instance_type = "${var.instance_type}"
    count=2
}

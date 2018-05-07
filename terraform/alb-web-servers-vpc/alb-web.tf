# Creating a VPC & Networking
resource "aws_vpc" "myapp_vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_support = false

  tags {
    Name = "liaz_vpc"
  }
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.myapp_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}

resource "aws_subnet" "myapp_subnet"{
  cidr_block = "192.168.10.0/24"
  vpc_id = "${aws_vpc.myapp_vpc.id}"
}

resource "aws_internet_gateway" "myapp_gw" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"
}

# Creating two instances of web server ami
resource "aws_instance" "web1" {
  ami = "${var.ami_webserver}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.myapp_subnet.id}"

  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
}

resource "aws_instance" "web2" {
  ami = "${var.ami_webserver}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.myapp_subnet.id}"

  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
}

##################################

# Creating and attaching the load balancer
resource "aws_alb" "alb" {
  subnets = ["${aws_subnet.myapp_subnet.id}"]
  internal = true
//  tags {
//    Name = "liaz_alb"
//  }
}

resource "aws_alb_target_group" "targ" {
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.myapp_vpc.id}"
//  tags {
//    Name = "liaz_alb"
//  }
}

resource "aws_alb_target_group_attachment" "attach_web1" {
  target_group_arn = "${aws_alb_target_group.targ.arn}"
  target_id       = "${aws_instance.web1.id}"
  port             = 80
}

resource "aws_alb_target_group_attachment" "attach_web2" {
  target_group_arn = "${aws_alb_target_group.targ.arn}"
  target_id       = "${aws_instance.web2.id}"
  port             = 80
}

resource "aws_alb_listener" "list" {
  "default_action" {
      target_group_arn = "${aws_alb_target_group.targ.arn}"
      type = "forward"
  }
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = 8080
}

resource "aws_security_group" "allow_all" {
  name        = "alb_allow_all"
  description = "Allow all traffic"
  vpc_id      = "${aws_vpc.myapp_vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 1
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol        = "tcp"
    from_port       = 1
    to_port         = 65535
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "udp"
    from_port   = 1
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol        = "udp"
    from_port       = 1
    to_port         = 65535
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "icmp"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

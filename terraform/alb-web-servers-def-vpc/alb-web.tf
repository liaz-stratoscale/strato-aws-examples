# Creating a VPC & Networking
resource "aws_vpc" "myapp_vpc" {
    cidr_block = "192.168.0.0/16"
    enable_dns_support = false

  # tags {
  #   Name = "liaz_vpc"
  # }
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
    subnet_id = "${aws_subnet.subnet1.id}"

    security_groups = ["${var.sg_web_servers}"]
}

resource "aws_instance" "web2" {
    ami = "${var.ami_webserver}"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.subnet1.id}"

    security_groups = ["${var.sg_web_servers}"]
}

##################################

# Creating and attaching the load balancer
resource "aws_alb" "alb" {
    subnets = ["${aws_subnet.subnet1.id}"]
    internal = true
}

resource "aws_alb_target_group" "targ" {
    port = 80
    protocol = "HTTP"
    vpc_id = "${aws_vpc.default.id}"
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
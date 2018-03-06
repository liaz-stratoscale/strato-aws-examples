data "aws_ami" "linux"{
    filter{
        name="name"
        values=["*webserver-centos*"]
    }
}

module "http_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "1.15.0"

  name        = "http-icmp-ssh-sg"
  description = "SG for ELB test"
  vpc_id      = "${module.conf_vpc.vpc_id}"

//  egress_cidr_blocks = ["0.0.0.0/0"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

//  egress_rules = ["all-all"]
  ingress_rules = ["all-icmp"]
  ingress_rules = ["http-80-tcp"]
  # TODO: fix this. workaround for missing bastion
  ingress_rules = ["ssh-tcp"]
}

################
# VPC
################
module "conf_vpc" {
  # source  = "terraform-aws-modules/vpc/aws"
  source  = "/Users/liaz/work/sandbox/terraform-aws-vpc"
  version = "1.23.0"

  name = "Confluence-VPC"

  cidr = "172.20.0.0/16"

  azs                 = ["symphony1"]
  private_subnets     = ["172.20.10.0/24"]
  public_subnets      = ["172.20.20.0/24"]
  database_subnets    = ["172.20.30.0/24"]

  create_database_subnet_group = false
  map_public_ip_on_launch = false

  enable_dns_support = false
  enable_nat_gateway = false
  enable_vpn_gateway = false

  enable_s3_endpoint       = false
  enable_dynamodb_endpoint = false

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "confluence.strato"
  dhcp_options_domain_name_servers = ["8.8.8.8", "8.8.4.4"]

  tags = {
    Owner       = "liazk"
    Name        = "Confluence-Cluster"
  }
}

# Workaround to private subnets created without GW till router table is created
resource "aws_route" "private_subnet_access_igw" {
  route_table_id = "${element(module.conf_vpc.private_route_table_ids,0)}"
  gateway_id = "${module.conf_vpc.igw_id}"
  destination_cidr_block = "0.0.0.0/0"
}

################
# ALB
################
resource "aws_alb" "alb" {
    subnets = ["${element(module.conf_vpc.public_subnets,0)}"]
    internal = false
    load_balancer_type = "network"
  # Security group attachment not working in ALB
  # JIRA bug - ?????
  security_groups      = ["${module.http_sg.this_security_group_id}"]
  # Tags are not working in ALB
  # JIRA bug - ?????
//    tags = {
//      Owner       = "liazk"
//      Environment = "Confluence-App"
//    }
  lifecycle {
    ignore_changes = ["security_groups"]
  }
}

resource "aws_alb_target_group" "targ" {
    port = 80
    protocol = "HTTP"
    health_check {
      interval = 10
      timeout = 5
    }
    vpc_id = "${module.conf_vpc.vpc_id}"

    lifecycle {
      ignore_changes = ["port", "target_type", "vpc_id"]
    }
}

resource "aws_alb_listener" "confluence_listener" {
    "default_action" {
        target_group_arn = "${aws_alb_target_group.targ.arn}"
        type = "forward"
    }
    load_balancer_arn = "${aws_alb.alb.arn}"
    port = 80
    lifecycle {
      ignore_changes = ["protocol"]
    }
}

# Attach instances to above ALB
resource "aws_alb_target_group_attachment" "attach_instances" {
    count = "${var.number_of_instances}"
    target_group_arn = "${aws_alb_target_group.targ.arn}"
    target_id        = "${element(aws_instance.myapp_instance.*.id, count.index)}"
    port             = 80
}


################
# EC2 instances
################
# Creating an instance
resource "aws_instance" "myapp_instance" {

    count = "${var.number_of_instances}"
    ami                         = "${data.aws_ami.linux.id}"
    instance_type               = "t2.medium"
    security_groups             = ["${module.http_sg.this_security_group_id}"]
    subnet_id                   = "${element(module.conf_vpc.private_subnets,0)}"
    associate_public_ip_address = true
    # Cannot use keypair with Terraform. Using username/password root/liaz1234
    key_name                    = "${var.keypair}"

    ##### Workaround root_block_device.0.delete_on_termination: "false" => "true" (forces new resource)
    lifecycle {
     ignore_changes = ["root_block_device", "security_groups"]
    }
}

# Workaround to missing bastion
resource "aws_eip" "private_instance_eip" {
  count = "${var.number_of_instances}"
  vpc = true
}

resource "aws_eip_association" "myapp_eip_assoc" {
  count = "${var.number_of_instances}"
  instance_id = "${element(aws_instance.myapp_instance.*.id, count.index)}"
  allocation_id = "${element(aws_eip.private_instance_eip.*.id, count.index)}"
}

#####################
# RDS Postgresql
#####################
# Create db instance 1
resource "aws_db_instance" "dbinst1" {
  identifier = "confdb"
  instance_class = "m1.medium"
  allocated_storage = 10
  engine = "postgresql"
  name = "db123"
  password = "dbpassword"
  username = "terraform"
  engine_version = "9.6.00"
  skip_final_snapshot = true
  db_subnet_group_name = "${element(module.conf_vpc.database_subnets,0)}"
}

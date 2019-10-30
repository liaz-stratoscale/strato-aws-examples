#Deploy ELK instances

resource "aws_key_pair" "app_keypair" {
  public_key = file(var.public_keypair_path)
  key_name   = "elk_kp"
}

resource "aws_instance" "elk-server" {
  ami = var.elk_ami

  # The public SG is added for SSH and ICMP
  vpc_security_group_ids = [aws_security_group.elk-sec.id, aws_security_group.allout.id]
  instance_type          = var.elk_instance_type
  subnet_id              = aws_subnet.elk_subnet.id
  key_name               = aws_key_pair.app_keypair.key_name

  tags = {
    Name = "elk-server"
  }
  user_data  = file("./install-elk.sh")

  root_block_device {
    volume_size = 50
  }
}

resource "aws_eip" "elk_eip" {
  depends_on = [aws_internet_gateway.app_igw]
}

resource "aws_eip_association" "myapp_eip_assoc" {
  instance_id   = aws_instance.elk-server.id
  allocation_id = aws_eip.elk_eip.id
}

output "ELK_Elastic_IP" {
  value = aws_eip.elk_eip.public_ip
}

output "elk-server_private_ips" {
  value = zipmap(
    aws_instance.elk-server.*.id,
    aws_instance.elk-server.*.private_ip,
  )
}

resource "aws_security_group" "elk-sec" {
  name   = "elkserver-secgroup"
  vpc_id = aws_vpc.app_vpc.id

  # Internal HTTP access from anywhere
  # logstash
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # kibana
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ssh from anywhere (for debugging)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ping access from anywhere
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allout" {
  name   = "allout-secgroup"
  vpc_id = aws_vpc.app_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


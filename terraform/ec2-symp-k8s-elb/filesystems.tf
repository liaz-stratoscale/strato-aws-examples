resource "aws_security_group" "efs_sg" {
  name        = "efs_sg"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.app_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_efs_file_system" "myefs" {
  creation_token = "test-efs2"
  lifecycle {
    ignore_changes = ["throughput_mode"]
  }

}

resource "aws_efs_mount_target" "efs_target1" {
  file_system_id = "${aws_efs_file_system.myefs.id}"
  subnet_id      = "${aws_subnet.pub_subnet.id}"
  security_groups = ["${aws_security_group.efs_sg.id}"]
}
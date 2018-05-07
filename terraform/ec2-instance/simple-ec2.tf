//resource "aws_default_vpc" "default_vpc" {}
data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "ec2_instance" {
    ami = "${var.ami_my_image}"

    tags{
        Name="liaz_ebs_instance_${count.index}"
    }
    # Can use any aws instance type supported by symphony
    instance_type = "t2.micro"
    count=1
    vpc_security_group_ids = ["${aws_security_group.sg_test_1.id}"]
}


resource "aws_ebs_volume" "my_volume" {
    availability_zone = "${var.avl_zone}"
    size = 10
    # workaround for BK-5544
    type = "gp2"
    tags {
        Name="volume_king"
    }
}

resource "aws_volume_attachment" "attach_my_volume_to_instance" {
    device_name = "/dev/xvdc"
    instance_id = "${aws_instance.ec2_instance.id}"
    volume_id = "${aws_ebs_volume.my_volume.id}"
}

resource "aws_ebs_snapshot" "snapshot_my_volume" {
    volume_id = "${aws_ebs_volume.my_volume.id}"
    tags {
        Name="snapshot_king"
    }
}

resource "aws_ebs_volume" "my_volume_from_snap" {
    availability_zone = "${var.avl_zone}"
    snapshot_id = "${aws_ebs_snapshot.snapshot_my_volume.id}"
    size = 10
    tags {
        Name="volume_queen"
    }
}

resource "aws_volume_attachment" "attach_my_volume_from_snap_to_instance_2" {
    device_name = "/dev/xvdb"
    instance_id = "${aws_instance.ec2_instance.id}"
    volume_id = "${aws_ebs_volume.my_volume_from_snap.id}"
}

resource "aws_security_group" "sg_test_1" {
  name = "liaz_sg"
  description = "My special SG"
//  vpc_id = "${aws_default_vpc.default_vpc.id}"
  vpc_id = "${data.aws_vpc.default.id}"

  ingress {
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "-1"
    to_port = "-1"
  }
}


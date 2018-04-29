# Filter a centos based image
data "aws_ami" "linux"{
    filter{
        name="name"
        values=["*cirros*"]
    }
}

# Create 3 instances, and name them according to count
resource "aws_instance" "ec2_instance" {
    ami = "${data.aws_ami.linux.image_id}"

    tags{
        Name="instance${count.index}"
    }
    # Can use any aws instance type supported by symphony
    instance_type = "t2.micro"
    count=1

    root_block_device {
        volume_size = 40
        volume_type = "standard"
    }
}
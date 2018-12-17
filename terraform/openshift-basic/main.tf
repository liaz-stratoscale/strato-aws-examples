provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"


    endpoints {
        ec2 = "https://${var.symphony_ip}/api/v2/aws/ec2/"
    }

    insecure = "true"
    s3_force_path_style = true
    skip_metadata_api_check = true
    skip_credentials_validation = true

    region = "${var.aws_region}"
}

#data "aws_availability_zones" "available" {}

data "template_file" "prep-bastion" {
  template = "${file("./scripts/prep-bastion.sh")}"
}
data "template_file" "prep-openshift" {
  template = "${file("./scripts/prep-openshift.sh")}"
}
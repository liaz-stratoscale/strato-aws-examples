resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    # we don't support dns
    enable_dns_support = false
}

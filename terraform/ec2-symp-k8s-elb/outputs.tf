output "lb_eip" {
  value = "${aws_alb.alb.dns_name}"
}

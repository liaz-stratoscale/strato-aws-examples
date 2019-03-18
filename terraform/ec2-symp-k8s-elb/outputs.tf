output "lb_eip" {
  value = "${aws_alb.alb.dns_name}"
}

output "nginx_app_endpoint" {
  value = "${aws_alb.alb.dns_name}:${aws_alb_listener.list.port}"
}

output "wordpres_app_endpoint" {
  value = "${aws_alb.alb.dns_name}:${aws_alb_listener.wp_list.port}"
}

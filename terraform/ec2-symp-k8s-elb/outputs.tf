output "grafana_app_endpoint" {
  value = "${aws_alb.alb.dns_name}:${aws_alb_listener.grafana_list.port}"
}

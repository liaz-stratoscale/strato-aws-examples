output "service_out_port" {
  value = "${kubernetes_service.grafana_service.spec.0.port.0.node_port}"
}
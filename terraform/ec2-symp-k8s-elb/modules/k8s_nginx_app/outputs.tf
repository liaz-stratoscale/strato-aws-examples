output "service_out_port" {
  value = "${kubernetes_service.nginx.spec.0.port.0.node_port}"
}
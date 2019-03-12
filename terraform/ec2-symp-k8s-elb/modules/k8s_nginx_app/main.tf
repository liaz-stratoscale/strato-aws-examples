provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "null_resource" "depenecy_nothing" {
  triggers {
    cluster_k8s_id = "${var.k8s_cluster_dependency_id}"
  }
}


resource "kubernetes_pod" "nginx" {
  metadata {
    name = "nginx-example"
    labels {
      App = "nginx"
    }
  }

  spec {
    container {
      image = "nginx:1.7.8"
      name  = "example"

      port {
        container_port = 80
      }
    }
  }
  depends_on = ["null_resource.depenecy_nothing"]
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-example"
  }
  spec {
    selector {
      App = "${kubernetes_pod.nginx.metadata.0.labels.App}"
    }
    port {
      port = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
provider "kubernetes" {
  config_path = "${var.k8s_configfile_path}"
}

resource "null_resource" "depenecy_nothing" {
  triggers {
    cluster_k8s_id = "${var.k8s_cluster_dependency_id}"
    eip_k8s_id = "${var.k8s_cluster_eip_id}"
  }
}

resource "kubernetes_persistent_volume" "grafana_pv" {
    metadata {
        name = "${var.grafana_name}-pv"
    }
    spec {
        capacity {
            storage = "1Mi"
        }
        access_modes = ["ReadWriteMany"]
        persistent_volume_source {
          nfs {
            path = "/var/nfs"
            server = "${var.pv_efs_ip}"
          }
        }
    }

  # Forces waiting for the K8S and its EIP to be built
  depends_on = ["null_resource.depenecy_nothing"]
}

resource "kubernetes_persistent_volume_claim" "grafana_pv_claim" {
  metadata {
    name = "${var.grafana_name}-pv-claim"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests {
        storage = "${kubernetes_persistent_volume.grafana_pv.spec.0.capacity.storage}"
      }
    }
    volume_name = "${kubernetes_persistent_volume.grafana_pv.metadata.0.name}"
  }
}

resource "kubernetes_deployment" "grafana_deployment" {
  "metadata" {
    name = "${var.grafana_name}"
    labels {
      "k8s-app" = "${var.grafana_name}"
    }
  }
  "spec" {
    selector {
      match_labels {
        "k8s-app" = "${var.grafana_name}"
      }
    }
//    strategy {
//      type = "Recreate"
//    }
    "template" {
      "metadata" {
        name = "${var.grafana_name}"
        labels {
          "k8s-app" = "${var.grafana_name}"
        }
      }
      "spec" {
        container {
          name = "${var.grafana_name}"
          image = "${var.grafana_image}"
          env {
            name = "GF_PATHS_CONFIG"
            value = "/mnt/grafana/grafana.ini"
          }
          port {
            container_port = 3000
            name = "grafana"
          }
          volume_mount {
            mount_path = "/mnt/grafana"
            name = "grafana-persistent-storage"
          }
        }
        volume {
          name = "grafana-persistent-storage"
          persistent_volume_claim {
            claim_name = "${kubernetes_persistent_volume_claim.grafana_pv_claim.metadata.0.name}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "grafana_service" {
  metadata {
    name = "grafana-service"
    labels {
      "k8s-app" = "${var.grafana_name}"
    }
  }
  spec {
    selector {
      "k8s-app" = "${var.grafana_name}"
    }
    port {
      protocol = "TCP"
      port = "${kubernetes_deployment.grafana_deployment.spec.0.template.0.spec.0.container.0.port.0.container_port}"
      target_port = "${kubernetes_deployment.grafana_deployment.spec.0.template.0.spec.0.container.0.port.0.container_port}"
    }

    type = "NodePort"
  }
}

provider "kubernetes" {
  config_path = "${var.k8s_configfile_path}"
}

resource "null_resource" "depenecy_nothing" {
  triggers {
    cluster_k8s_id = "${var.k8s_cluster_dependency_id}"
    eip_k8s_id = "${var.k8s_cluster_eip_id}"
  }
}

resource "kubernetes_persistent_volume" "my_pv" {
    metadata {
        name = "wp-pv-demo"
    }
    spec {
        capacity {
            storage = "20Gi"
        }
        access_modes = ["ReadWriteMany"]
        persistent_volume_source {
          nfs {
            path = "/var/nfs"
            server = "${var.pv_efs_ips}"
          }
        }
    }

  depends_on = ["null_resource.depenecy_nothing"]
}


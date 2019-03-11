resource "null_resource" "create_k8s_cluster" {
  provisioner "local-exec" {
    command = "${path.module}/sh/k8s_create.sh"

    environment {
      "symp_host" = "${var.symp_host}"
      "symp_domain" = "${var.symp_domain}"
      "symp_user" = "${var.symp_user}"
      "symp_password" = "${var.symp_password}"
      "symp_prj" = "${var.symp_project}"
      "k8s_name" = "${var.k8s_name}"
      "k8s_eng" = "${var.k8s_eng}"
      "k8s_subnet" = "${var.k8s_subnet}"
      "k8s_size" = "${var.k8s_size}"
      "k8s_count" = "${var.k8s_count}"
      "k8s_type" = "${var.k8s_type}"
      "k8s_eip" = "${var.k8s_eip}"
    }
  }
}

data "external" "k8s_info" {
  program = ["bash", "${path.module}/sh/k8s_info.sh"]

  query = {
    "host" = "${var.symp_host}"
    "domain" = "${var.symp_domain}"
    "user" = "${var.symp_user}"
    "password" = "${var.symp_password}"
    "project_id" = "${var.symp_project}"
    "name" = "${var.k8s_name}"
  }

  depends_on = ["null_resource.create_k8s_cluster"]
}

resource "null_resource" "delete_k8s_cluster" {
  provisioner "local-exec" {
    when = "destroy"
    command = "${path.module}/sh/k8s_delete.sh"

    environment {
      "symp_host" = "${var.symp_host}"
      "symp_domain" = "${var.symp_domain}"
      "symp_user" = "${var.symp_user}"
      "symp_password" = "${var.symp_password}"
      "symp_prj" = "${var.symp_project}"
      "k8s_name" = "${var.k8s_name}"
    }
  }
}

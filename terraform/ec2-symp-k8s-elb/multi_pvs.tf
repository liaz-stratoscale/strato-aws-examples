module "k8s_multi_vps" {
  source = "modules/k8s_multi_pvs"

  k8s_cluster_dependency_id = "${module.my_k8s.k8s_cluster_id}"
  k8s_cluster_eip_id = "${aws_eip.k8s_eip.id}"
  k8s_configfile_path = "${var.k8s_configfile_path}"

  pv_efs_ips = "${aws_efs_mount_target.efs_target1.ip_address}"
  vps_count = "${var.pvs_count}"
}

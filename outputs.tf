output "clusters_created" {
  value = local.k3d_cluster_names
}

output "kubeconfigs_created" {
  value = local.kubeconfig_paths
}


locals {

  k3d_cluster_names = flatten([
    for filename in fileset(path.module, "manifests/k3d-config-*.yaml"): regex("k3d-config-(.+).yaml", filename)
  ])

  kubeconfig_paths = zipmap(
    flatten([for cluster_name in local.k3d_cluster_names : cluster_name]),
    flatten([for cluster_name in local.k3d_cluster_names : "~/.kube/k3d-${cluster_name}"])
  )

}

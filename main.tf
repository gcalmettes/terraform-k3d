provider "docker" {}

provider "helm" {
  kubernetes {
    config_paths = values(local.kubeconfig_paths)
  }
}


resource "null_resource" "cluster" {
  for_each = toset(local.k3d_cluster_names)
  provisioner "local-exec" {
    command = "k3d cluster create ${each.key} --config manifests/k3d-config-${each.key}.yaml"
  }
}

resource "null_resource" "kubeconfig" {
  for_each = local.kubeconfig_paths
  provisioner "local-exec" {
    command = "k3d kubeconfig get ${each.key} > ${each.value}"
  }
  depends_on = [
    null_resource.cluster
  ]
}

resource "null_resource" "cluster_delete" {
  for_each = toset(local.k3d_cluster_names)
  provisioner "local-exec" {
    command = "k3d cluster delete ${each.key}"
    when    = destroy
  }
}

resource "null_resource" "kubeconfig_delete" {
  for_each = toset(values(local.kubeconfig_paths))
  provisioner "local-exec" {
    command = "rm ${each.key}"
    when    = destroy
  }
}

data "docker_network" "k3d" {
  for_each = toset(local.k3d_cluster_names)
  name = "k3d-${each.key}"
  depends_on = [
    null_resource.cluster
  ]
}

module "nginx" {
  source = "./modules/releases"

 depends_on = [
    null_resource.kubeconfig,
 ]

}

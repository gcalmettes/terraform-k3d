resource "helm_release" "nginx" {
  name       = "nginx"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

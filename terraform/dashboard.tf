resource "kubernetes_namespace" "dashboard" {
  metadata {
    name = "dashboard"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }
  depends_on = [helm_release.linkerd]
}

resource "helm_release" "dashboard" {
  name       = "dashboard"
  repository = "https://kubernetes.github.io/dashboard" 
  chart      = "kubernetes-dashboard"
  namespace  = "dashboard"
  version    = "2.3.0"

  values = [
    "${file("dashboard.yaml")}"
  ]
  depends_on = [kubernetes_namespace.dashboard]
}

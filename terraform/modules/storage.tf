resource "kubernetes_namespace" "storage" {
  metadata {
    name = "storage"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.nfs-storage]
}

resource "helm_release" "storage" {
  name       = "storage"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "nfs-client-provisioner"
  namespace  = "storage"
  version    = "1.2.8"

  values = [
    file("${path.module}/storage.yaml")
  ]

  depends_on = [kubernetes_namespace.storage]
}

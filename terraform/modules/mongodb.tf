resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.storage]
}

resource "helm_release" "mongodb" {
  name       = "mongodb"
  chart      = "${path.module}/charts/mongodb"
  namespace  = "mongodb"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.mongodb]
}

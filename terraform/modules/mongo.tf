resource "kubernetes_namespace" "mongo" {
  metadata {
    name = "mongo"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.storage]
}

resource "helm_release" "mongo" {
  name       = "mongo"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  namespace  = "mongo"
  version    = "8.2.1"

  values = [
    file("${path.module}/mongo.yaml")
  ]

  depends_on = [kubernetes_namespace.mongo]
}

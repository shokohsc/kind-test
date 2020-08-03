resource "kubernetes_namespace" "postgresql" {
  metadata {
    name = "postgresql"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.storage]
}

resource "helm_release" "postgresql" {
  name       = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  namespace  = "postgresql"
  version    = "9.1.2"

  values = [
    file("${path.module}/postgresql.yaml")
  ]

  depends_on = [kubernetes_namespace.postgresql]
}

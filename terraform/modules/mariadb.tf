resource "kubernetes_namespace" "mariadb" {
  metadata {
    name = "mariadb"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.storage]
}

resource "helm_release" "mariadb" {
  name       = "mariadb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mariadb"
  namespace  = "mariadb"
  version    = "7.7.1"

  values = [
    file("${path.module}/mariadb.yaml")
  ]

  depends_on = [kubernetes_namespace.mariadb]
}

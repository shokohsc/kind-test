resource "kubernetes_namespace" "adminer" {
  metadata {
    name = "adminer"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.postgresql]
}

resource "helm_release" "adminer" {
  name       = "adminer"
  chart      = "${path.module}/charts/adminer"
  namespace  = "adminer"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.adminer]
}

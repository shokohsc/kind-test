resource "kubernetes_namespace" "adminer" {
  metadata {
    name = "adminer"
    labels = {
      namespace = "adminer"
    }
  }

  depends_on = [helm_release.traefik, helm_release.postgresql]
}

resource "helm_release" "adminer" {
  name       = "adminer"
  chart      = "${path.module}/charts/adminer"
  namespace  = "adminer"
  version    = "0.1.0"

  recreate_pods = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/adminer/values.yaml")
  ]

  depends_on = [kubernetes_namespace.adminer]
}

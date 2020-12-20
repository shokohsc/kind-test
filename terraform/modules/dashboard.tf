resource "kubernetes_namespace" "dashboard" {
  metadata {
    name = "dashboard"
    labels = {
      namespace = "dashboard"
    }
  }

  depends_on = [helm_release.traefik]
}

resource "helm_release" "dashboard" {
  name       = "dashboard"
  chart      = "${path.module}/charts/dashboard"
  namespace  = "dashboard"
  version    = "0.1.0"

  recreate_pods = true
  cleanup_on_fail = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/dashboard/values.yaml")
  ]

  depends_on = [kubernetes_namespace.dashboard]
}

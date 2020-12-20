resource "kubernetes_namespace" "commander" {
  metadata {
    name = "commander"
    labels = {
      namespace = "commander"
    }
  }

  depends_on = [helm_release.traefik, helm_release.nfs-wd1to, helm_release.nfs-wd2to, helm_release.nfs-shared]
}

resource "helm_release" "commander" {
  name       = "commander"
  chart      = "${path.module}/charts/commander"
  namespace  = "commander"
  version    = "0.1.0"

  recreate_pods = true
  cleanup_on_fail = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/commander/values.yaml")
  ]

  depends_on = [kubernetes_namespace.commander]
}

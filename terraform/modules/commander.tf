resource "kubernetes_namespace" "commander" {
  metadata {
    name = "commander"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.nfs-wd1to]
}

resource "helm_release" "commander" {
  name       = "commander"
  chart      = "${path.module}/charts/commander"
  namespace  = "commander"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.commander]
}

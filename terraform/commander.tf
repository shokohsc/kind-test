resource "kubernetes_namespace" "commander" {
  metadata {
    name = "commander"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }
  depends_on = [helm_release.nfs]
}

resource "helm_release" "commander" {
  name       = "commander"
  chart      = "./charts/commander"
  namespace  = "commander"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.commander]
}

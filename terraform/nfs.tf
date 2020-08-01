resource "kubernetes_namespace" "nfs" {
  metadata {
    name = "nfs"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }
  depends_on = [helm_release.linkerd]
}

resource "helm_release" "nfs" {
  name       = "nfs"
  chart      = "./charts/nfs"
  namespace  = "nfs"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.nfs]
}

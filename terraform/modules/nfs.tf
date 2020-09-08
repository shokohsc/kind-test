resource "kubernetes_namespace" "nfs" {
  metadata {
    name = "nfs"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.traefik]
}

resource "helm_release" "nfs-wd1to" {
  name       = "nfs-wd1to"
  chart      = "${path.module}/charts/nfs-wd1to"
  namespace  = "nfs"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.nfs]
}

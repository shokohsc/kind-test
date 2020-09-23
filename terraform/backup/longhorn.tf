resource "kubernetes_namespace" "longhorn-system" {
  metadata {
    name = "longhorn-system"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.nfs-wd1to]
}

resource "helm_release" "longhorn" {
  name       = "longhorn"
  chart      = "${path.module}/charts/longhorn"
  namespace  = "longhorn-system"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.longhorn-system]
}

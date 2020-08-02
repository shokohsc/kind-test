resource "kubernetes_namespace" "nfs" {
  metadata {
    name = "nfs"
    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }

  depends_on = [helm_release.linkerd]
}

resource "helm_release" "nfs-storage" {
  name       = "nfs-storage"
  chart      = "${path.module}/charts/nfs"
  namespace  = "nfs"
  version    = "0.1.0"

  values = [
    file("${path.module}/nfs-storage.yaml")
  ]

  depends_on = [kubernetes_namespace.nfs]
}

resource "helm_release" "nfs-wd1to" {
  name       = "nfs-wd1to"
  chart      = "${path.module}/charts/nfs"
  namespace  = "nfs"
  version    = "0.1.0"

  values = [
    file("${path.module}/nfs-wd1to.yaml")
  ]

  depends_on = [kubernetes_namespace.nfs]
}

resource "helm_release" "nfs-wd2to" {
  name       = "nfs-wd2to"
  chart      = "${path.module}/charts/nfs"
  namespace  = "nfs"
  version    = "0.1.0"

  values = [
    file("${path.module}/nfs-wd2to.yaml")
  ]

  depends_on = [kubernetes_namespace.nfs]
}

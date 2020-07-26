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
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "nfs-server-provisioner"
  namespace  = "nfs"
  version    = "1.1.1"

  values = [
    "${file("nfs.yaml")}"
  ]
  depends_on = [kubernetes_namespace.nfs]
}

resource "kubernetes_namespace" "pihole" {
  metadata {
    name = "pihole"
    annotations = {
      "linkerd.io/inject" = "disabled"
    }
  }

  depends_on = [helm_release.traefik, helm_release.nfs-server-provisioner]
}

resource "helm_release" "pihole" {
  name       = "pihole"
  chart      = "${path.module}/charts/pihole"
  namespace  = "pihole"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.pihole]
}

resource "kubernetes_namespace" "pihole" {
  metadata {
    name = "pihole"
    labels = {
      namespace = "pihole"
    }
  }

  depends_on = [helm_release.traefik, helm_release.nfs-server-provisioner]
}

resource "helm_release" "pihole" {
  name       = "pihole"
  chart      = "${path.module}/charts/pihole"
  namespace  = "pihole"
  version    = "0.1.0"

  recreate_pods = true
  cleanup_on_fail = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/pihole/values.yaml")
  ]

  depends_on = [kubernetes_namespace.pihole]
}

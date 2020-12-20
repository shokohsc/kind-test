resource "kubernetes_namespace" "openvpn-client" {
  metadata {
    name = "openvpn-client"
    labels = {
      namespace = "openvpn-client"
    }
  }

  depends_on = [helm_release.nfs-server-provisioner]
}

resource "helm_release" "openvpn-client" {
  name       = "openvpn-client"
  chart      = "${path.module}/charts/openvpn-client"
  namespace  = "openvpn-client"
  version    = "0.1.0"

  recreate_pods = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    file("${path.module}/charts/openvpn-client/values.yaml")
  ]

  depends_on = [kubernetes_namespace.openvpn-client]
}

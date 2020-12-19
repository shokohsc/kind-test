resource "kubernetes_namespace" "openvpn-server" {
  metadata {
    name = "openvpn-server"
    labels = {
      namespace = "openvpn-server"
    }
  }

  depends_on = [helm_release.pihole]
}

resource "helm_release" "openvpn-server" {
  name       = "openvpn-server"
  chart      = "${path.module}/charts/openvpn-server"
  namespace  = "openvpn-server"
  version    = "0.1.0"

  recreate_pods = true
  cleanup_on_fail = true
  max_history = 3
  dependency_update = true
  lint = true

  values = [
    "${file("charts/openvpn-server/values.yaml")}"
  ]

  depends_on = [kubernetes_namespace.openvpn-server]
}

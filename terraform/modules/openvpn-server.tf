resource "kubernetes_namespace" "openvpn-server" {
  metadata {
    name = "openvpn-server"
    annotations = {
      "linkerd.io/inject" = "disabled"
    }
  }

  depends_on = [helm_release.traefik]
}

resource "helm_release" "openvpn-server" {
  name       = "openvpn-server"
  chart      = "${path.module}/charts/openvpn-server"
  namespace  = "openvpn-server"
  version    = "0.1.0"

  depends_on = [kubernetes_namespace.openvpn-server]
}

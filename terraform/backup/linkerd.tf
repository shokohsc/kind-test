# step certificate create identity.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure
# step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --ca ca.crt --ca-key ca.key --profile intermediate-ca --not-after 8760h --no-password --insecure

resource "helm_release" "linkerd" {
  name       = "linkerd"
  chart      = "${path.module}/charts/linkerd"
  version    = "0.1.0"

  set {
      name  = "linkerd2.global.identityTrustAnchorsPEM"
      value = file("${path.module}/charts/linkerd/files/ca.crt")
  }
  set {
      name  = "linkerd2.identity.issuer.tls.crtPEM"
      value = file("${path.module}/charts/linkerd/files/issuer.crt")
  }
  set {
      name  = "linkerd2.identity.issuer.tls.keyPEM"
      value = file("${path.module}/charts/linkerd/files/issuer.key")
  }
  set {
      name  = "linkerd2.identity.issuer.crtExpiry"
      value = "2021-08-15T20:32:32Z"
  }
}

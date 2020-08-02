# step certificate create identity.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure
# step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --ca ca.crt --ca-key ca.key --profile intermediate-ca --not-after 8760h --no-password --insecure

resource "helm_release" "linkerd" {
  name       = "linkerd"
  repository = "https://helm.linkerd.io/stable" 
  chart      = "linkerd2"
  version    = "2.8.1"

  values = [
    file("${path.module}/linkerd.yaml")
  ]

  set {
      name  = "global.identityTrustAnchorsPEM"
      value = file("${path.module}/ca.crt")
  }
  set {
      name  = "identity.issuer.tls.crtPEM"
      value = file("${path.module}/issuer.crt")
  }
  set {
      name  = "identity.issuer.tls.keyPEM"
      value = file("${path.module}/issuer.key")
  }
  set {
      name  = "identity.issuer.crtExpiry"
      value = "2021-07-21T14:13:57Z"
  }
}

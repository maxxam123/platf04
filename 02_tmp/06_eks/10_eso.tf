resource "helm_release" "external-secrets" {
  name = "external-secrets"

  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true
  version          = "0.10.3"

  
  set {
    # name  = "service.type"
    # value = "ClusterIP"
    name = "installCRDs"
    value = true
  }
}

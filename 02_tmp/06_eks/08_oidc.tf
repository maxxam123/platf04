
data "tls_certificate" "eks" {
  url = "${aws_eks_cluster.example.identity.0.oidc.0.issuer}"
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["${data.tls_certificate.example.certificates.0.sha1_fingerprint}"]
  url             = "${aws_eks_cluster.example.identity.0.oidc.0.issuer}"
}
data "aws_iam_policy_document" "myapp_secrets" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:12-example:myapp"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "myapp_secrets" {
  name               = "${aws_eks_cluster.eks.name}-myapp-secrets"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "myapp_secrets" {
  name        = "${aws_eks_cluster.eks.name}-myapp-secrets"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example_s3" {
  policy_arn = aws_iam_policy.myapp_secrets.arn
  role       = aws_iam_role.myapp_secrets.arn
}

resource "aws_eks_pod_identity_association" "example" {
  cluster_name    = aws_eks_cluster.example.name
  namespace       = "example"
  service_account = "example-sa"
  role_arn        = aws_iam_role.example.arn
}

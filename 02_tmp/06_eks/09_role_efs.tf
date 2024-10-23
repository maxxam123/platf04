##################### ROLES FOR EFS-CSI-DRIVER #######################

resource "aws_efs_file_system" "eks" {
  creation_token = "my-product"
  
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = true
}

resource "aws_efs_mount_target" "zone_a" {
  file_system_id = aws_efs_file_system.eks.id
  subnet_id      = aws_subnet.private_zone2.id
  security_groups = [aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id]
}

data "aws_iam_policy_document" "efs_csi_driver" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "efs_csi_driver" {
  name               = "${aws_eks_cluster.eks.name}-efs-csi-driver"
  assume_role_policy = data.aws_iam_policy_document.efs_csi_driver.json
}

resource "aws_iam_role_policy_attachment" "efs_csi_driver" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.efs_csi_driver.name
}

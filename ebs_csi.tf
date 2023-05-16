resource "aws_iam_role" "eks_ebs_csi" {
  name = "eks_ebs_csi"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : var.openid_arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${replace(var.openid_url, "https://", "")}:aud" : "sts.amazonaws.com",
            "${replace(var.openid_url, "https://", "")}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ebs_csi" {
  name       = "eks_ebs_csi"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  roles      = [aws_iam_role.eks_ebs_csi.name]
}

data "aws_eks_addon_version" "latest" {
  addon_name = "aws-ebs-csi-driver"
  kubernetes_version = data.aws_eks_cluster.cluster.version
  most_recent = true
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version = data.aws_eks_addon_version.latest.version
  service_account_role_arn = aws_iam_role.eks_ebs_csi.arn
}

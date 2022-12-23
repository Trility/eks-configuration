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

resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.10.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.eks_ebs_csi.arn
}

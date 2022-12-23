resource "kubectl_manifest" "iam_rbac" {
  yaml_body = file("aws-auth-cm.yaml")
}

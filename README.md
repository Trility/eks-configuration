# EKS Configuration

## Dependencies
 - AWS VPC, private access and private EKS cluster

## Required Tools
 - Terraform

## Helpful Tools
 - AWS CLI
 - Helm CLI
 - Kubectl 

## Terraform plan/apply creates the following:
 - EKS EBS CSI - https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html
 - EKS Rbac - https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
 - AWS LB Controller - https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/
 - FluentBit - https://github.com/aws/eks-charts/tree/master/stable/aws-for-fluent-bit
 - External-DNS - https://github.com/kubernetes-sigs/external-dns
 - Supporting IAM roles and policies

## Variables
 - aws_lb_controller_version - helm search repo eks
 - aws_region - tested in us-west-2
 - cluster_name - User's choice
 - external_dns_version - helm search repo external-dns
 - hosted_zone_id - Private DNS Hosted Zone in Route53
 - openid_arn - ARN for EKS Cluster
 - openid_url - URL for EKS Cluster

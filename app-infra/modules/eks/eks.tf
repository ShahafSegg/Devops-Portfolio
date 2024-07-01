resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.private_subnets_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_policy
  ]
}

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name = var.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  depends_on = [aws_eks_cluster.eks]
}

# Cluster token
data "aws_eks_cluster_auth" "main" {
  name = var.cluster_name
}

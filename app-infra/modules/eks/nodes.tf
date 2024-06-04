#worker nodes
resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}_node_group"
  node_role_arn   = aws_iam_role.worker_nodes.arn
  subnet_ids      = var.subnets_ids

  scaling_config {
    desired_size = var.node_count
    max_size     = 3
    min_size     = 1
  }

  capacity_type  = "ON_DEMAND"
  disk_size      = 50
  instance_types = ["t3a.large"]

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.worker_cni_policy,
    aws_iam_role_policy_attachment.worker_registry_policy,
    aws_iam_role_policy_attachment.ebs_csi_policy,
    aws_eks_cluster.eks
  ]

}

# EKS Node Security Group
resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.cluster_name}_node_sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                        = "${var.cluster_name}_node_sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Nodes communication
resource "aws_security_group_rule" "nodes_internal" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  to_port                  = 65535
  type                     = "ingress"
}

# Allow worker Kubelets and pods to receive communication from the cluster control plane
resource "aws_security_group_rule" "nodes_cluster_inbound" {
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  to_port                  = 65535
  type                     = "ingress"
}




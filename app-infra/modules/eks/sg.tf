# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster_sg" {
  name   = "${var.cluster_name}_sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.cluster_name}_sg"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  to_port                  = 65535
  type                     = "egress"
}


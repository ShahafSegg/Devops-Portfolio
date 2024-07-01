resource "aws_subnet" "public_subnets" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_blocks_public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "${var.env}-public-${var.availability_zones[count.index]}"
    "KubernetesCluster"                         = var.cluster_name
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}


resource "aws_subnet" "private_subnets" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_blocks_private_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name"                            = "${var.env}-private-${var.availability_zones[count.index]}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}



module "network" {
  source = "./modules/network"

  availability_zones          = var.availability_zones
  vpc_cidr                    = var.vpc_cidr
  tags                        = var.tags
  cluster_name                = var.cluster_name
  env                         = var.env
  cidr_blocks_public_subnets  = var.cidr_blocks_public_subnets
  cidr_blocks_private_subnets = var.cidr_blocks_private_subnets
}

module "eks" {
  source = "./modules/eks"

  cluster_name        = var.cluster_name
  private_subnets_ids = module.network.private_subnets_ids
  instance_type       = var.instance_type
  node_count          = var.node_count
  tags                = var.tags
  key_pair_name       = var.key_pair_name
  vpc_id              = module.network.vpc_id
  account_id          = var.account_id
  region              = var.region
}

module "argocd" {
  source = "./modules/argocd"
}

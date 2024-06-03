region             = "ap-south-1"
availability_zones = ["ap-south-1a", "ap-south-1b"]
vpc_cidr           = "10.0.0.0/16"
instance_type      = "t3a.large"
node_count         = 3
cluster_name       = "shahaf-eks-cluster"
tags = {
  owner           = "shahaf.segev"
  bootcamp        = "20"
  expiration_date = "25-06-24"
}
key_pair_name = "shahaf-tf"
account_id    = 644435390668
env           = "staging"

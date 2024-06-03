# Terraform Infrastructure

This repository contains Terraform configurations for setting up infrastructure. To activate the Terraform scripts, follow the instructions below.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- [Terraform](https://www.terraform.io/downloads.html)

## Getting Started

Follow these steps to apply the Terraform configurations:

### 1. Clone the Repository

```sh
git clone https://gitlab.com/shahaf4/app-infra
cd app-infra
```

### 2. Prepare the Variables File

Create a .tfvars file with the necessary variables. The file should include the following fields (fill in your own values):
```sh
region             = "YOUR-REGION"
availability_zones = ["YOUR-AVAILABILITY-ZONE-1", "YOUR-AVAILABILITY-ZONE-2"]
vpc_cidr           = "YOUR-VPC-CIDR"
instance_type      = "YOUR-INSTANCE-TYPE"
node_count         = YOUR-NODE-COUNT
cluster_name       = "YOUR-CLUSTER-NAME"
tags = {
  owner           = "YOUR-NAME"
  some_tag        = "YOUR-TAG"
}
key_pair_name = "YOUR-KEY-PAIR-NAME"
account_id    = YOUR-ACCOUNT-ID
env           = "YOUR-ENVIRONMENT"
```

### 3. Apply the Terraform Configuration

```sh
terraform apply -var-file="YOUR-FILE.tfvars"
```
Replace YOUR-FILE.tfvars with the path to your .tfvars file.

```markdown
## Repository Structure
terraform-infrastructure/
├── README.md                 # This README file
├── backend.tf                # Backend configuration for Terraform state storage
├── main.tf                   # Main Terraform configuration file
├── main.tfvars               # Example Terraform variables file
├── modules                   # Directory containing reusable Terraform modules
│   ├── argocd                # ArgoCD module
│   │   ├── argocd.tf         # ArgoCD resources definition
│   │   ├── providers.tf      # Providers configuration for ArgoCD
│   │   └── secrets.tf        # Secrets management for ArgoCD
│   ├── eks                   # EKS (Elastic Kubernetes Service) module
│   │   ├── eks.tf            # EKS cluster resources definition
│   │   ├── iam.tf            # IAM roles and policies for EKS
│   │   ├── nodes.tf          # Node group configuration for EKS
│   │   ├── outputs.tf        # Outputs for the EKS module
│   │   ├── providers.tf      # Providers configuration for EKS
│   │   ├── sg.tf             # Security groups for EKS
│   │   └── variables.tf      # Variables for the EKS module
│   └── network               # Network module
│       ├── igw.tf            # Internet Gateway configuration
│       ├── outputs.tf        # Outputs for the network module
│       ├── routes.tf         # Route tables configuration
│       ├── subnets.tf        # Subnets configuration
│       ├── variables.tf      # Variables for the network module
│       └── vpc.tf            # VPC (Virtual Private Cloud) configuration
├── namespaces.tf             # Namespaces configuration
├── outputs.tf                # Outputs for the overall infrastructure
├── providers.tf              # Providers configuration for the overall infrastructure
├── secrets.tf                # Secrets management for the overall infrastructure
└── variables.tf              # Variables for the overall infrastructure

```

# Contact

###### If you have any questions or need further assistance, please feel free to contact me at shahafseg@gmail.com

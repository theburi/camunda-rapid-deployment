#     # The configuration for the `remote` backend.
#     terraform {
#       backend "remote" {
#         # The name of your Terraform Cloud organization.
#         organization = "rapid-deployment"
#
#         # The name of the Terraform Cloud workspace to store Terraform state files in.
#         workspaces {
#           name = "Rapid-Github"
#         }
#       }
#     }
#
#     # An example resource that does nothing.
#     resource "null_resource" "example" {
#       triggers = {
#         value = "A example resource that does nothing!"
#       }
#     }

#  backend "local" {
#    path = "terraform.tfstate"
#  }

#    backend "remote" {
#        # The name of your Terraform Cloud organization.
#        organization = "rapid-deployment"
#        # The name of the Terraform Cloud workspace to store Terraform state files in.
#        workspaces {
#            name = "Rapid-Github"
#            }
#    }


terraform {
    backend "local" {
      path = "terraform.tfstate"
    }


    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.65.0" 
        }
        kubernetes = {
        source  = "hashicorp/kubernetes"
        version = "~> 2.30.0"
        }
        helm = {
        source  = "hashicorp/helm"
        version = "~> 2.8.0"
        }
    }
}

provider "aws" {
  region = "eu-west-1"
}

# Configure the Kubernetes provider
provider "kubernetes" {
  host                   = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token

  # Optionally, you can configure exec-based authentication
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.name]
  }
}

# Helm provider configuration
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)

    # Optionally, configure exec-based authentication
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}

# Data source to fetch the EKS cluster authentication token
data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
  depends_on = [module.eks_cluster]
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
  depends_on = [module.eks_cluster]
}


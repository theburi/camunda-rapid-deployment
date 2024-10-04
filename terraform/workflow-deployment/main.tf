
terraform {
    backend "s3" { 
      bucket         = "andrey-tf"        # Replace with your S3 bucket name
      key            = "workflow/workflow-deployment.tfstate" # This is the path where state file will be stored in S3
      region         = "eu-west-1"             # e.g., us-west-2
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
    }
}

provider "aws" {
  region = "eu-west-1"
}

# Configure the Kubernetes provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token

  # Optionally, you can configure exec-based authentication
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", "demo-cluster-name"]
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

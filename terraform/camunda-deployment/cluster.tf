module "eks_cluster" {
  source = "git::https://github.com/camunda/camunda-tf-eks-module//modules/eks-cluster?ref=2.1.0"

  region = "eu-west-1"    # change to your AWS region
  name   = "cluster-name" # change to name of your choosing
  np_instance_types = ["t3.medium"]

  # Set CIDR ranges or use the defaults
  cluster_service_ipv4_cidr = "10.190.0.0/16"
  cluster_node_ipv4_cidr    = "10.192.0.0/16"
}

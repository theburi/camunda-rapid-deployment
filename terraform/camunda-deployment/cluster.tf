module "eks_cluster" {
  source = "git::https://github.com/camunda/camunda-tf-eks-module//modules/eks-cluster?ref=2.1.0"

  region                = "eu-west-1"    # change to your AWS region
  name                  = "cluster-name" # change to name of your choosing
  np_instance_types     = ["m6i.xlarge"]
  np_desired_node_count = 4

  # Set CIDR ranges or use the defaults
  cluster_service_ipv4_cidr = "10.190.0.0/16"
  cluster_node_ipv4_cidr    = "10.192.0.0/16"
}

data "aws_iam_user" "second_user" {
  user_name = "andrey.belik@camunda.com" # Replace with the IAM user you want to add
}

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [module.eks_cluster]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = <<YAML
- userarn: ${data.aws_iam_user.second_user.arn}
  username: second-user-name # Kubernetes username
  groups:
    - system:masters
YAML
  }
}
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

# Add your SSO role to the aws-auth ConfigMap
resource "kubernetes_config_map" "aws_auth" {
  depends_on = [module.eks_cluster]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
- rolearn: arn:aws:iam::123302325581:role/AWSReservedSSO_SystemAdministrator_3272c85503826b83
  username: andrey.belik
  groups:
    - system:masters
YAML
  }
}
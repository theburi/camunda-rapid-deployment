module "postgresql" {
  source                     = "git::https://github.com/camunda/camunda-tf-eks-module//modules/aurora?ref=2.1.0"
  engine_version             = "15.4"
  auto_minor_version_upgrade = false
  cluster_name               = "cluster-name-postgresql" # change "cluster-name" to your name
  default_database_name      = "camunda"

  # Please supply your own secret values
  username         = "secret_user"
  password         = "secretvalue%23"
  vpc_id           = module.eks_cluster.vpc_id
  subnet_ids       = module.eks_cluster.private_subnet_ids
  cidr_blocks      = concat(module.eks_cluster.private_vpc_cidr_blocks, module.eks_cluster.public_vpc_cidr_blocks)
  instance_class   = "db.t3.medium"
  iam_auth_enabled = true

  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  depends_on = [module.eks_cluster]
}
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = var.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.eks_cluster.cluster_endpoint
}

output "cert_manager_arn" {
  value       = module.eks_cluster.cert_manager_arn
  description = "The Amazon Resource Name (ARN) of the AWS IAM Roles for Service Account mapping for the cert-manager"
}

output "external_dns_arn" {
  value       = module.eks_cluster.external_dns_arn
  description = "The Amazon Resource Name (ARN) of the AWS IAM Roles for Service Account mapping for the external-dns"
}



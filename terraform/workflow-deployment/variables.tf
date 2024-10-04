variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "demo-cluster-name"
}

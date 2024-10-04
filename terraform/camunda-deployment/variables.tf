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

variable "user_name" {
  description = "DB User Name"
  type        = string
  default     = "user_name"
}

variable "secret_password" {
  description = "DB User Password"
  type        = string
  default     = "secretvalue%23"
}

variable "default_database_name" {
  description = "Database name"
  type        = string
  default     = "camunda"
}
variable "aws_region" {
  description = "Região AWS principal"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Nome do ambiente"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "solidarytech"
}

variable "kubernetes_version" {
  description = "Versao do Kubernetes para EKS"
  type        = string
  nullable    = true
  default     = null
}

variable "db_engine_version" {
  description = "Versao do engine Postgres para RDS"
  type        = string
  default     = "16"
}

variable "vpc_cidr" {
  description = "CIDR block da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZs disponíveis"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs das subnets privadas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDRs das subnets públicas"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
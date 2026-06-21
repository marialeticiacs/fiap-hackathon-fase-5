module "vpc" {
  source               = "../../modules/vpc"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "eks" {
  source             = "../../modules/eks"
  project_name       = var.project_name
  environment        = var.environment
  kubernetes_version = var.kubernetes_version
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_nodes_sg_id    = aws_security_group.eks_nodes.id
}

module "rds" {
  source             = "../../modules/rds"
  project_name       = var.project_name
  environment        = var.environment
  db_engine_version  = var.db_engine_version
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = aws_security_group.rds.id
}

module "elasticache" {
  source             = "../../modules/elasticache"
  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  elasticache_sg_id  = aws_security_group.elasticache.id
}

module "sqs" {
  source           = "../../modules/sqs"
  project_name     = var.project_name
  environment      = var.environment
  eks_node_role_arn = module.eks.node_group_role_arn
}

module "dynamodb" {
  source       = "../../modules/dynamodb"
  project_name = var.project_name
  environment  = var.environment
}
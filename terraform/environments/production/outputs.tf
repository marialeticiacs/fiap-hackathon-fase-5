output "eks_cluster_name"     { value = module.eks.cluster_name }
output "eks_cluster_endpoint" { value = module.eks.cluster_endpoint }
output "rds_endpoint"         { value = module.rds.db_endpoint }
output "redis_endpoint"       { value = module.elasticache.redis_endpoint }
output "sqs_queue_url"        { value = module.sqs.queue_url }
output "dynamodb_table_name"  { value = module.dynamodb.table_name }

output "ecr_repositories" {
  value = {
    for k, v in aws_ecr_repository.services : k => v.repository_url
  }
}
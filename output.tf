output "db_arn" {
  value = module.dynamo_db_back.dynamodb_table_arn
}

output "MAIN_CLUSTER_NAME" {
  value = module.aws_ecs_cluster.ecs_cluster_name
}

output "MAIN_CLUSTER_ID" {
  value = module.aws_ecs_cluster.ecs_cluster_id
}

output "MAIN_VPC_ID" {
  value = module.vpc-main.main_vpc_id
}

output "MAIN_VPC_SUBNET_IDS" {
  value = module.vpc-main.public_subnet_ids
}

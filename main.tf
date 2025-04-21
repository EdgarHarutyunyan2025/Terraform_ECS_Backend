#========= VPC ===========

module "vpc-main" {
  source              = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//vpc"
  vpc_name            = "MAIN-VPC"
  vpc_cidr            = var.main_vpc
  public_subnet_cidrs = var.main_public_subnet
}

#========= ECR ===========

module "ecr_back" {
  source       = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//ecr"
  ecr_name     = "my_back_ecr"
  docker-image = var.docker_image

  lifecycle_description  = "Delete all images older than 7 days"
  lifecycle_tag_status   = "any"
  lifecycle_count_type   = "sinceImagePushed"
  lifecycle_count_number = 7
}

#========= SG ===========

module "back_sg" {
  source      = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//sg"
  allow_ports = var.allow_ports
  vpc_id      = module.vpc-main.main_vpc_id

  sg_name  = var.sg_name
  sg_owner = var.sg_owner

}

#========= ROLE ===========

module "role_dynamo_db" {
  source        = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//role_back"
  dynamo_db_arn = module.dynamo_db_back.dynamodb_table_arn
  log_name      = var.log_name
}

#========= ECS Cluster ===========

module "aws_ecs_cluster" {
  #source      = "../modules/ecs_cluster"
  source      = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//ecs_cluster"
  cluser_name = "Fargat-Cluster"
}

#========= ECS Service ===========

module "aws_ecs_service_back" {
  #source                  = "../modules/ecs_sevice"
  source                  = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//ecs_sevice"
  cluser_name             = module.aws_ecs_cluster.ecs_cluster_name
  service_name            = var.service_name
  cluster_id              = module.aws_ecs_cluster.ecs_cluster_id
  task_definition_id      = module.task_definition_back.task_definition_id
  launch_type             = var.launch_type
  service_subnets         = module.vpc-main.public_subnet_ids
  service_security_groups = [module.back_sg.sg_id]

  target_group_arn = module.aws_alb_back.alb_tg_arn
  container_name   = var.back_container_name
  container_port   = 8080

}


module "task_definition_back" {
  #source                   = "../modules/task_definition"
  source                   = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//task_definition"
  family                   = var.family
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = module.role_dynamo_db.dynamo_role_arn
  task_role_arn            = module.role_dynamo_db.dynamo_role_arn

  container_name   = var.back_container_name
  container_image  = module.ecr_back.repository_url
  container_cpu    = var.container_cpu
  container_memory = var.container_memory
  essential        = var.essential
  container_port   = var.container_port
  host_port        = var.container_port

  log_name = var.log_name

}


#========= ALB ===========


module "aws_alb_back" {
  #source                     = "../modules/load_balancer"
  source                     = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//load_balancer"
  lb_name                    = var.lb_name
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = [module.back_sg.sg_id]
  subnets                    = module.vpc-main.public_subnet_ids
  enable_deletion_protection = var.enable_deletion_protection

  tg_name     = var.tg_name
  tg_port     = var.tg_port
  tg_protocol = var.tg_protocol
  vpc_id      = module.vpc-main.main_vpc_id

  health_check_path     = var.health_path-1
  health_check_protocol = var.health_check_protocol
  health_check_port     = var.health_check_port

  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol

}

#========== Autoscaling Group ============

module "autoscaling_group_backend" {
  source       = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//autoscaling_group"
  resource_id  = "service/${module.aws_ecs_cluster.ecs_cluster_name}/${module.aws_ecs_service_back.ecs_service_name}"
  max_capacity = 1
  min_capacity = 1
}


#========== Dynamo DB ============

module "dynamo_db_back" {
  source = "git::https://github.com/EdgarHarutyunyan2025/Terraform_ECS_Modules.git//dynamo_db"
}

#========== Cloudwatch Log ============

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = var.log_name
}

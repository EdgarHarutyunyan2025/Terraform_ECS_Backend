module "ecr_back" {
  source       = "../modules/ecr"
  ecr_name     = "my_back_ecr"
  docker-image = "supervisord_db"
}

#========= SG ===========

module "back_sg" {
  source      = "../modules/sg"
  allow_ports = var.allow_ports
  vpc_id      = data.terraform_remote_state.front.outputs.FRONT_VPC_ID

  sg_name  = var.sg_name
  sg_owner = var.sg_owner

}

#========= ROLE ===========

module "role_dynamo_db" {
  source = "../modules/role_back"

  dynamo_db_arn = module.dynamo_db_back.dynamodb_table_arn

  log_name = var.log_name

}


module "aws_ecs_service_back" {
  source                  = "../modules/ecs_sevice"
  cluser_name             = data.terraform_remote_state.front.outputs.FRONT_CLUSTER_NAME
  service_name            = var.service_name
  cluster_id              = data.terraform_remote_state.front.outputs.FRONT_CLUSTER_ID
  task_definition_id      = module.task_definition_back.task_definition_id
  launch_type             = var.launch_type
  service_subnets         = [data.terraform_remote_state.front.outputs.FRONT_VPC_SUBNET_IDS[0]]
  service_security_groups = [module.back_sg.sg_id]

  target_group_arn = module.aws_alb_back.alb_tg_arn
  container_name   = var.back_container_name
  #  container_port   = var.container_port
  container_port = 8080

}


module "task_definition_back" {
  source                   = "../modules/task_definition"
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
  source                     = "../modules/load_balancer"
  lb_name                    = var.lb_name
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = [module.back_sg.sg_id]
  subnets                    = data.terraform_remote_state.front.outputs.FRONT_VPC_SUBNET_IDS
  enable_deletion_protection = var.enable_deletion_protection

  tg_name     = var.tg_name
  tg_port     = var.tg_port
  tg_protocol = var.tg_protocol
  vpc_id      = data.terraform_remote_state.front.outputs.FRONT_VPC_ID

  health_check_path     = var.health_path-1
  health_check_protocol = var.health_check_protocol
  health_check_port     = var.health_check_port

  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol

}


module "autoscaling_group_backend" {
  source       = "../modules/autoscaling_group"
  resource_id  = "service/${data.terraform_remote_state.front.outputs.FRONT_CLUSTER_NAME}/${module.aws_ecs_service_back.ecs_service_name}"
  max_capacity = 1
  min_capacity = 1
}




#-----------dynamo-------------

module "dynamo_db_back" {
  source = "../modules/dynamo_db"
}






resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = var.log_name
}

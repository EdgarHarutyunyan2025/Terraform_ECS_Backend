#============ VPC VARS ==============

main_vpc           = "192.168.0.0/16"
main_public_subnet = ["192.168.10.0/24", "192.168.20.0/24"]

#============ SG VARS ===============

sg_name     = "back_sg"
sg_owner    = "Edgar"
allow_ports = ["8080", "80"]

#============ ECS VARS ==============

cluser_name  = "fargate_cluster"
service_name = "Back_Servise"
launch_type  = "FARGATE"

#============ ALB VARS ==============

lb_name                    = "BACK-ALB"
internal                   = false
load_balancer_type         = "application"
enable_deletion_protection = false
tg_name                    = "back-tg"
tg_port                    = 8080
tg_protocol                = "HTTP"
health_path-1              = "/add"
health_check_port          = 8080
health_check_protocol      = "HTTP"
listener_port              = 8080
listener_protocol          = "HTTP"

#============ Task Def VARS ==============

family                   = "back_task"
network_mode             = "awsvpc"
requires_compatibilities = ["FARGATE"]
cpu                      = "512"
memory                   = "1024"
back_container_name      = "back-container"
container_image          = "nimmis/alpine-apache"
container_cpu            = 512
container_memory         = 1024
essential                = true
container_port           = 8080
log_name                 = "back"

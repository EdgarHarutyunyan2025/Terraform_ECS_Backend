#============ VPC VARS ==============

variable "main_vpc" {
  default = "192.168.0.0/16"
}

variable "main_public_subnet" {
  default = ["192.168.10.0/24", "192.168.20.0/24"]
}

#============ ECS VARS ==============


variable "cluser_name" {
  default = "fargate_cluster"
}

variable "service_name" {
  default = "back_servise"
}

variable "launch_type" {
  default = "FARGATE"
}

variable "docker_image" {
  default = ""
}

#============ SG VARS ==============

variable "sg_name" {
  default = "back-sg"
}

variable "sg_owner" {
  default = "Edgar"
}

variable "allow_ports" {
  default = ["8080", "22"]
}

#============ ALB VARS ==============

variable "lb_name" {
  default = "BACK-ALB"
}

variable "internal" {
  default = false
}

variable "load_balancer_type" {
  default = "application"
}


variable "enable_deletion_protection" {
  default = false
}

variable "tg_name" {
  default = "back-tg"
}

variable "tg_port" {
  default = 8080
}

variable "tg_protocol" {
  default = "HTTP"
}

variable "health_check_port" {
  default = 8080
}

variable "health_path-1" {
  default = "/"
}

variable "health_check_protocol" {
  default = "HTTP"
}

variable "listener_port" {
  default = 8080
}

variable "listener_protocol" {
  default = "HTTP"
}


#============ Task Def VARS ==============

variable "family" {
  default = "back_task"
}

variable "network_mode" {
  default = "awsvpc"
}

variable "requires_compatibilities" {
  default = ["FARGATE"]
}

variable "cpu" {
  default = "512"
}

variable "memory" {
  default = "1024"
}

variable "back_container_name" {
  default = "back-container"
}

variable "container_image" {
  default = "nimmis/alpine-apache"
}

variable "container_cpu" {
  type    = number
  default = 512
}

variable "container_memory" {
  type    = number
  default = 1024
}

variable "essential" {
  default = true
}

variable "container_port" {
  default = 8080
}

variable "log_name" {
  default = "back"
}

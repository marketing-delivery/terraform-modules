variable "ecs_cluster_id" {
  description = "ID of the ECS Fargate cluster"
}

variable "ecs_cluster_name" {
  
}

variable "name" {
  
}

variable "tags" {
  description = "tags applied to the resources"
}

variable "image_uri" {
  
}

variable "task_execution_role_arn" {
  
}

variable "subnets" {
  type        = list(string)
  description = "List of subnets to launch the task in"
}

variable "region" {
  
}

variable "health_check_endpoint" {
  
}

variable "service_role_arn" {
  
}

variable "target_group_arn" {
  default = ""
}

variable "task_security_group_arn" {
  
}

variable "container_port" {
  type = number
  default = 80
}

variable "task_cpu" {
  type = number
  default = 256
}

variable "task_memory" {
  type = number
  default = 512
}

variable "max_capacity" {
  type = number
  default = 3
}

variable "min_capacity" {
  type = number
  default = 1
}

variable "desired_count" {
  type = number
  default = 1
}

# variable "alb_listener_arn" {
#   description = "ARN of the Application Load Balancer listener"
# }

# variable "api_name" {
#   description = "Name of your API Gateway"
# }

# variable "https_certificate_arn" {
#   description = "ARN of the ACM certificate for HTTPS"
# }

locals {
  tags = "${merge(var.tags, { "Module" = "ecs-task/${var.name}" })}"
}

variable "environment" {
  description = "A map of environment variables to pass to the container"
  type        = map(string)
  default     = {}
}

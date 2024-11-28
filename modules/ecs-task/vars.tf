variable "ecs_cluster_id" {
  description = "ID of the ECS Fargate cluster"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS Fargate cluster"
}

variable "name" {
  description = "Name of the task"
}

variable "tags" {
  description = "tags applied to the resources"
}

variable "image_uri" {
  description = "URI of the container image"
}

variable "task_execution_role_arn" {
  description = "ARN of the task execution role"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnets to launch the task in"
}

variable "region" {
  description = "Region for the task"
}

variable "health_check_endpoint" {
  description = "Health check endpoint for the task"
}

variable "target_group_arn" {
  description = "ARN of the target group for the task"
  default     = ""
}

variable "task_security_group_arn" {
  description = "ARN of the security group for the task"
}

variable "container_port" {
  type        = number
  description = "Port number for the container"
  default     = 80
}

variable "task_cpu" {
  type        = number
  description = "CPU units for the task (Fargate requires this) (256 = 0.25 vCPU, 512 = 0.5 vCPU, 1024 = 1 vCPU, 2048 = 2 vCPU)"
  default     = 256
}

variable "task_memory" {
  type        = number
  description = "Memory for the task (Fargate requires this) (512 = 0.5 GB, 1024 = 1 GB, 2048 = 2 GB, 4096 = 4 GB)"
  default     = 512
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of tasks to run"
  default     = 3
}

variable "min_capacity" {
  type        = number
  description = "Minimum number of tasks to run"
  default     = 1
}

variable "desired_count" {
  type        = number
  description = "Desired number of tasks to run"
  default     = 1
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
  tags = merge(var.tags, { "Module" = "ecs-task/${var.name}" })
}

variable "environment" {
  description = "A map of environment variables to pass to the container"
  type        = map(string)
  default     = {}
}

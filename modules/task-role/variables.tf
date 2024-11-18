variable "name" {
  description = "The name of the role"
  type        = string
  default     = "ecs-task-execution-role"
}

variable "tags" {
  description = "tags applied to the resources"
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  type        = string
}

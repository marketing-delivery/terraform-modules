variable "name" {
  description = "The name of the role"
  type        = string
  default     = "ecs-task-execution-role"
}

variable "tags" {
  description = "tags applied to the resources"
}

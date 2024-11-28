variable "name" {
  description = "Cluster name"
}

variable "tags" {
  description = "tags applied to the resources"
}

variable "log_group" {
}

variable "log_retention_days" {
  default = 0
}

locals {
  tags = merge(var.tags, { "Module" = "ecs-cluster/${var.name}" })
}
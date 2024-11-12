variable "name" {
}

variable "vpc_id" {
}

variable "alb_arn" {
  
}

variable "container_port" {
  type = number
  default = 80
}

variable "health_check_path" {
  type = string
  default = "/"
}

variable "tls_policy" {
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "tags" {
  description = "tags applied to the resources"
  default = {}
}

variable "certificate_arn" {
  
}

locals {
  tags = "${merge(var.tags, { "Module" = "alb/${var.name}" })}"
}
variable "name" {
}

variable "vpc_id" {
}

variable "domain" {
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

locals {
  tags = "${merge(var.tags, { "Module" = "alb/${var.domain}" })}"
}
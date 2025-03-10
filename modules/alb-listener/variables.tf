variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "alb_arn" {
  type = string
}

variable "is_https" {
  type    = bool
  default = true
}

variable "container_port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "tls_policy" {
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "tags" {
  description = "tags applied to the resources"
  default     = {}
}

variable "certificate_arn" {
  type    = string
  default = null
}

#variable "allowed_origins" {
#  description = "List of allowed origins for CORS"
#  type        = list(string)
#  default     = []
#}

variable "enable_cors" {
  description = "Enable CORS support"
  type        = bool
  default     = false
}

locals {
  tags = merge(var.tags, { "Module" = "alb/${var.name}" })
}
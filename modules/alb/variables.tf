variable "name" {
}

# variable "internal" {
#     default = false
# }

variable "vpc_id" {
}

variable "vpc_subnets" {
}

#  variable "domain" {
#  }

# variable "extra_domains" {
#   default = []
# }

# variable "default_target_arn" {
#   default = ""
# }

# variable "ecs_sg" {
#   default = []
# }

# variable "tls" {
#   default = true
# }

# variable "tls_policy" {
#   default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
# }

# variable "idle_timeout" {
#   default = 60
# }

# variable "access_logs" {
#   description = "An access logs block"
#   type        = map(string)
#   default     = {}
# }

# variable "tcp_ingress" {
#   type = map(list(string))
#   default = {
#     "80"  = ["0.0.0.0/0"]
#     "443" = ["0.0.0.0/0"]
#   }
# }

# variable "drop_invalid_header_fields" {
#   type    = bool
#   default = false
# }

# variable "enable_deletion_protection" {
#   description = "Enable Deletion Protection"
#   default     = true
# }

# variable "desync_mitigation_mode"  {
#   default = "defensive"
# }

variable "container_port" {
  type    = number
  default = 80
}

variable "tags" {
  description = "tags applied to the resources"
  default     = {}
}

variable "security_group_id" {
  default = ""
}

locals {
  tags = merge(var.tags, { "Module" = "alb/${var.name}" })
}
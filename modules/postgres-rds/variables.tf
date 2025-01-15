variable "identifier" {
  type        = string
  description = "The identifier for the rds instance and the secret"
}

variable "db_name" {
  type = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9]*$", var.db_name))
    error_message = "The database name must begin with a letter and contain only alphanumeric characters."
  }
}

variable "username" {
  type    = string
  default = "postgres"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "The instance class to use for the database"
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "The amount of storage to allocate for the database in GB"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnets to associate with the database"
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Whether to enable multi-AZ deployment"
}

variable "tags" {
  type        = map(string)
  description = "The tags to associate with the database"
}

variable "deletion_protection" {
  type        = bool
  default     = false
  description = "Whether to enable deletion protection"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = true
  description = "Whether to skip final snapshot"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the security group will be created"
}
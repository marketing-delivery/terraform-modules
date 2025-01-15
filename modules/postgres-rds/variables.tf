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

variable "max_allocated_storage" {
  description = "Maximum storage allocation limit for RDS instance (in GB)"
  type        = number
  default     = 100
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

variable "maintenance_window" {
  type        = string
  default     = "Mon:00:00-Mon:03:00"
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'"
}

variable "backup_window" {
  type        = string
  default     = "03:00-06:00"
  description = "The daily time range during which automated backups are created if enabled. Must not overlap with maintenance_window"
}

variable "backup_retention_period" {
  type        = number
  default     = 0
  description = "The days to retain backups for. 0 to disable automated backups"
  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 0 and 35 days"
  }
}
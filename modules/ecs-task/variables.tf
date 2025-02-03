variable "name" {
  description = "Name of the ECS task and service"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_:]+$", var.name))
    error_message = "The name value '${var.name}' must contain only alphanumeric characters, hyphens, underscores, and colons."
  }
} 
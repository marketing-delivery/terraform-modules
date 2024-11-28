variable "name" {
  description = "name of the s3 bucket"
  type        = string
}

variable "tags" {
  description = "tags applied to the bucket"
  type        = map(string)
}

variable "account_ids" {
  description = "account ids to give access to the bucket"
  type        = list(number)
}

variable "has_random_suffix" {
  description = "whether to append a random suffix to the bucket name"
  type        = bool
  default     = false
}
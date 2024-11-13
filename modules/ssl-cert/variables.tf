variable "domain_name" {
  description = "The domain name for the SSL certificate"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the certificate"
  type        = map(string)
  default     = {}
}

variable "registered_domain" {
  type        = string
  description = "The registered domain name for Route53 zone lookup"
} 
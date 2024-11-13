variable "domain_name" {
  description = "The domain name for the SSL certificate"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the certificate"
  type        = map(string)
  default     = {}
}

variable "route53_zone_id" {
  description = "The ID of the Route53 hosted zone where DNS validation records will be created"
  type        = string
} 
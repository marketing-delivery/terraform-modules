variable "domain_name" {
  type        = string
  description = "Domain name for the certificate and Route53 record"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "route53_zone_id" {
  type        = string
  description = "Route53 zone ID"
}

variable "alb_dns_name" {
  type        = string
  description = "ALB DNS name for alias record"
}

variable "alb_zone_id" {
  type        = string
  description = "ALB zone ID for alias record"
} 
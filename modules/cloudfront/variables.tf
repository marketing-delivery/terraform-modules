variable "tags" {
  
}

variable "domain" {
  default = ""
  
}

variable "bucket_id" {
  
}

variable "bucket_arn" {
  
}

variable "bucket_regional_domain_name" {
  
}

variable "web_acl_id" {
  description = "Unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution. To specify a web ACL created using the latest version of AWS WAF (WAFv2), use the ACL ARN, for example aws_wafv2_web_acl.example.arn. To specify a web ACL created using AWS WAF Classic, use the ACL ID, for example aws_waf_web_acl.example.id. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned."
}

variable "response_headers_policy_id" {
  default = null
}
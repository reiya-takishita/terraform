variable "name" {
  description = "WAFv2 web ACL name"
  type        = string
}

variable "scope" {
  description = "CLOUDFRONT or REGIONAL"
  type        = string
  default     = "REGIONAL"
}

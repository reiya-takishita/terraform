variable "name" {
  description = "CloudTrail trail name"
  type        = string
  default     = "org-trail"
}

variable "bucket_name" {
  description = "S3 bucket name for CloudTrail logs"
  type        = string
}

variable "cloudwatch_logs_group_arn" {
  description = "Optional CloudWatch Logs Group ARN"
  type        = string
  default     = null
}

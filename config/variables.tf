variable "bucket_name" {
  description = "S3 bucket name for AWS Config delivery"
  type        = string
}

variable "role_arn" {
  description = "IAM Role ARN for AWS Config to assume"
  type        = string
}

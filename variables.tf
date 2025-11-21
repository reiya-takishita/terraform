variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "リソース名のプレフィックス"
  type        = string
  default     = "example10"
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
  default     = "10.0.0.0/16"
}

variable "web_instance_type" {
  description = "WebサーバーEC2のインスタンスタイプ"
  type        = string
  default     = "t3.micro"
}

variable "bucket_name" {
  description = "S3バケット名"
  type        = string
  default     = "example-bucket-12345"
}

variable "s3_versioning_enabled" {
  description = "S3バージョニングを有効にする"
  type        = bool
  default     = true
}

variable "cloudfront_price_class" {
  description = "CloudFront価格クラス"
  type        = string
  default     = "PriceClass_100"
}

variable "environment" {
  description = "Environment (dev, stg, prod)"
  type        = string
  default     = "dev"
}

variable "environment2" {
  description = "Environment (dev, stg, prod)"
  type        = string
  default     = "dev"
}

variable "repository_url" {
  description = "Git repository URL (GitHub, GitLab, Bitbucket, CodeCommit)"
  type        = string
  default     = "your-repository-url"
}

variable "repository_branch" {
  description = "Git branch to deploy"
  type        = string
  default     = "main"
}

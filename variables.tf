variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1" # お使いのリージョンに合わせて変更してください
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for Public Subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for Public Subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_app_subnet_a_cidr" {
  description = "CIDR block for Private App Subnet A"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_app_subnet_b_cidr" {
  description = "CIDR block for Private App Subnet B"
  type        = string
  default     = "10.0.12.0/24"
}

variable "private_db_subnet_a_cidr" {
  description = "CIDR block for Private DB Subnet A"
  type        = string
  default     = "10.0.21.0/24"
}

variable "private_db_subnet_b_cidr" {
  description = "CIDR block for Private DB Subnet B"
  type        = string
  default     = "10.0.22.0/24"
}

variable "az_a" {
  description = "Availability Zone A"
  type        = string
  default     = "ap-northeast-1a" # お使いのリージョンに合わせて変更してください
}

variable "az_b" {
  description = "Availability Zone B"
  type        = string
  default     = "ap-northeast-1b" # お使いのリージョンに合わせて変更してください
}

# S3バケット名を定義
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

# S3バケットのタグを定義
variable "s3_bucket_tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "amplify" {
  source = "./modules/amplify"

  aws_region        = var.region
  project_name      = var.project_name
  environment       = var.environment
  repository_url    = var.repository_url
  repository_branch = var.repository_branch
}

# S3バケットモジュール
module "s3_bucket" {
  source = "./modules/s3_bucket"

  bucket_name = var.s3_bucket_name
  tags = merge(
    var.s3_bucket_tags,
    {
      Project     = var.project_name
      Environment = var.environment
    }
  )
  # その他の設定は modules/s3_bucket/variables.tf のデフォルト値を使用
  # 必要に応じてここでオーバーライドできます
  # acl           = "private"
  # force_destroy = false
  # enable_versioning = true
  # lifecycle_rules = [
  #   {
  #     id                        = "expire-old-versions"
  #     status                    = "Enabled"
  #     expiration_days           = 365
  #     transition_days           = null
  #     transition_storage_class  = null
  #   }
  # ]
  # sse_algorithm     = "AES256"
  # enable_logging    = true
  # target_bucket_name = "your-s3-log-bucket-name" # ログバケットは別途作成または既存を指定
  # target_prefix     = "s3-access-logs/"
}

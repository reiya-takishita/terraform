# S3バケットリソース
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  acl           = var.acl
  force_destroy = var.force_destroy

  tags = var.tags

  # S3バケットのバージョン管理設定
  dynamic "versioning" {
    for_each = var.enable_versioning ? [1] : []
    content {
      enabled = true
    }
  }
}

# S3バケットのパブリックアクセスブロック設定
# セキュリティベストプラクティスとして、デフォルトで全てブロックするように設定
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
# S3バケットのライフサイクルルール設定
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status

      # オブジェクト有効期限ルール (expiration_daysが設定されている場合)
      dynamic "expiration" {
        for_each = rule.value.expiration_days != null ? [1] : []
        content {
          days = rule.value.expiration_days
        }
      }

      # オブジェクト移行ルール (transition_daysとtransition_storage_classが設定されている場合)
      dynamic "transition" {
        for_each = rule.value.transition_days != null && rule.value.transition_storage_class != null ? [1] : []
        content {
          days          = rule.value.transition_days
          storage_class = rule.value.transition_storage_class
        }
      }
    }
  }
}

# S3バケットのサーバーサイド暗号化設定
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
      # KMSキーIDはsse_algorithmがaws:kmsの場合のみ設定
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? var.sse_kms_key_id : null
    }
  }
}

# S3バケットのアクセスログ設定
resource "aws_s3_bucket_logging" "this" {
  count = var.enable_logging ? 1 : 0

  bucket        = aws_s3_bucket.this.id
  target_bucket = var.target_bucket_name
  target_prefix = var.target_prefix
}

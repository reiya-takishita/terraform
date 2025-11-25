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

      # Filter (optional)
      dynamic "filter" {
        for_each = lookup(rule.value, "filter", null) != null ? [rule.value.filter] : []
        content {
          # filterブロックは、`prefix` または `tags` または `and` を含むことができる。
          # `tags` を指定する場合は `and` ブロックが必要。`prefix` と `tags` の両方指定も `and` で。
          dynamic "and" {
            for_each = (lookup(filter.value, "prefix", null) != null || lookup(filter.value, "tags", null) != null) ? [1] : []
            content {
              prefix = lookup(filter.value, "prefix", null)
              tags   = lookup(filter.value, "tags", null)
            }
          }
        }
      }

      # Current version expiration (optional)
      dynamic "expiration" {
        for_each = lookup(rule.value, "expiration", null) != null ? [rule.value.expiration] : []
        content {
          days                         = lookup(expiration.value, "days", null)
          date                         = lookup(expiration.value, "date", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      # Noncurrent version expiration (optional)
      dynamic "noncurrent_version_expiration" {
        for_each = lookup(rule.value, "noncurrent_version_expiration", null) != null ? [rule.value.noncurrent_version_expiration] : []
        content {
          noncurrent_days = noncurrent_version_expiration.value.noncurrent_days
        }
      }

      # Current version transitions (optional)
      dynamic "transition" {
        for_each = lookup(rule.value, "transitions", null)
        content {
          days          = lookup(transition.value, "days", null)
          date          = lookup(transition.value, "date", null)
          storage_class = transition.value.storage_class
        }
      }

      # Noncurrent version transitions (optional)
      dynamic "noncurrent_version_transition" {
        for_each = lookup(rule.value, "noncurrent_version_transitions", null)
        content {
          noncurrent_days = noncurrent_version_transition.value.noncurrent_days
          storage_class   = noncurrent_version_transition.value.storage_class
        }
      }
      # Abort incomplete multipart uploads (optional)
      dynamic "abort_incomplete_multipart_upload" {
        for_each = lookup(rule.value, "abort_incomplete_multipart_upload_days", null) != null ? [1] : []
        content {
          days_after_initiation = rule.value.abort_incomplete_multipart_upload_days
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

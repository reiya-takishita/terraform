# S3バケットのID（名前）
output "bucket_id" {
  description = "S3バケットの名前。"
  value       = aws_s3_bucket.this.id
}

# S3バケットのARN
output "bucket_arn" {
  description = "S3バケットのARN。"
  value       = aws_s3_bucket.this.arn
}

# S3バケットのドメイン名
output "bucket_domain_name" {
  description = "S3バケットのドメイン名。"
  value       = aws_s3_bucket.this.bucket_domain_name
}

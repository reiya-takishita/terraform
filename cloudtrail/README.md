# CloudTrail モジュール

CloudTrail のトレイルを最小構成で作成します（複数リージョン/グローバルイベント有効）。

## 使い方
```hcl
module "cloudtrail" {
  source       = "../cloudtrail"
  name         = "org-trail"
  bucket_name  = var.trail_bucket_name
  # cloudwatch_logs_group_arn = aws_cloudwatch_log_group.trail.arn
}
```

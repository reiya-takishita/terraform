# AWS Config モジュール

AWS Config のレコーダ・配信チャネルを有効化します（最小構成）。

## 使い方
```hcl
module "config" {
  source     = "../config"
  bucket_name = var.config_bucket_name
  role_arn    = var.config_role_arn
}
```

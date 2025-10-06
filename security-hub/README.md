# Security Hub モジュール

AWS Security Hub を有効化し、任意のスタンダードに購読します。

## 使い方
```hcl
module "security_hub" {
  source        = "../security-hub"
  enabled       = true
  standards_arns = [
    # 例: CIS AWS Foundations Benchmark v1.4.0
    "arn:aws:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/1.4.0",
  ]
}
```

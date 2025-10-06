# GuardDuty モジュール

AWS GuardDuty を有効化します。

## 使い方
```hcl
module "guardduty" {
  source                         = "../guardduty"
  enabled                        = true
  finding_publishing_frequency   = "FIFTEEN_MINUTES"
}
```
